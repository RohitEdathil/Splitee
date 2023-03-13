import { NextFunction, Request, Response } from "express";
import { connect } from "http2";
import { db } from "../db";
import { BadRequestError } from "../error/types";

async function createBillController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const title: string = req.body.title;
  const amount: number = req.body.amount;
  const groupId: string = req.body.groupId;

  const owes: Map<string, number> = new Map(Object.entries(req.body.owes));

  // Fetch user
  const user = await db.user.findFirst({
    where: {
      userId: req.userId,
    },
  });

  if (groupId) {
    // Find the group
    const group = await db.group.findFirst({
      where: {
        id: groupId,
      },
    });

    // Check if group exists
    if (!group) {
      next(new BadRequestError("Group does not exist"));
      return;
    }

    // Check if user is in group
    if (!group.usersIds.includes(user.id)) {
      next(new BadRequestError("User is not in group"));
      return;
    }
  }

  // Check if all owe keys are valid MongoIds
  if (!Array.from(owes.keys()).every((key) => key.match(/^[0-9a-fA-F]{24}$/))) {
    next(new BadRequestError("Invalid user id"));
    return;
  }

  // Fetch all debtors
  const debtors = await db.user.findMany({
    where: {
      id: {
        in: Array.from(owes.keys()),
      },
    },
  });

  // Check if all debtors exist
  if (debtors.length !== owes.size) {
    next(new BadRequestError("Debtor does not exist"));
    return;
  }

  // Check is amount == sum of owes
  const sum = Array.from(owes.values()).reduce((a, b) => a + b, 0);
  if (sum !== amount) {
    next(new BadRequestError("Amount does not match sum of owes"));
    return;
  }

  const data = {};

  // Only add group if it exists
  if (groupId) {
    data["group"] = {
      connect: {
        id: groupId,
      },
    };
  }

  // Create bill
  await db.bill.create({
    data: {
      ...data,
      title,
      amount,

      creditor: {
        connect: {
          id: user.id,
        },
      },
      owes: {
        createMany: {
          data: Array.from(owes.entries()).map(([userId, amount]) => ({
            amount,
            status: "PENDING",
            debtorId: userId,
          })),
        },
      },
    },
  });

  res.status(200).json({
    message: "Bill created successfully",
  });
}

export { createBillController };
