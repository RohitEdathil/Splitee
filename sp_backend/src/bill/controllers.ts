import { NextFunction, Request, Response } from "express";
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
    if (!group.usersIds.includes(req.uid)) {
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
          id: req.uid,
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

async function deleteBillController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const billId: string = req.body.billId;

  // Find the bill
  const bill = await db.bill.findFirst({
    where: {
      id: billId,
    },
  });

  // Check if bill exists
  if (!bill) {
    next(new BadRequestError("Bill does not exist"));
    return;
  }

  // Check if user is in group
  if (!(bill.creditorId === req.uid)) {
    next(new BadRequestError("User is not the creditor"));
    return;
  }

  // Delete all owes
  await db.owe.deleteMany({
    where: {
      billId: billId,
    },
  });

  // Delete bill
  await db.bill.delete({
    where: {
      id: billId,
    },
  });

  res.status(200).json({
    message: "Bill deleted successfully",
  });
}

async function editBillController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const billId: string = req.params.billId;
  const title: string = req.body.title;
  const amount: number = req.body.amount;
  const owes: Map<string, number> = req.body.owes
    ? new Map(Object.entries(req.body.owes))
    : null;

  // Find the bill
  const bill = await db.bill.findFirst({
    where: {
      id: billId,
    },
  });

  // Check if bill exists
  if (!bill) {
    next(new BadRequestError("Bill does not exist"));
    return;
  }

  // Check if user is the creditor
  if (!(bill.creditorId === req.uid)) {
    next(new BadRequestError("User is not the creditor"));
    return;
  }

  const mutation = {};

  // Only add title if it exists
  if (title) {
    mutation["title"] = title;
  }

  // Only add amount if it exists
  if (amount) {
    mutation["amount"] = amount;
  }

  // Only add owes if it exists
  if (owes) {
    // Check if all owe keys are valid MongoIds
    if (
      !Array.from(owes.keys()).every((key) => key.match(/^[0-9a-fA-F]{24}$/))
    ) {
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

    // Delete all owes
    await db.owe.deleteMany({
      where: {
        billId: billId,
      },
    });

    // Create new owes
    await db.bill.update({
      where: {
        id: billId,
      },
      data: {
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
  }

  await db.bill.update({
    where: {
      id: billId,
    },
    data: {
      ...mutation,
    },
  });

  res.status(200).json({
    message: "Bill edited successfully",
  });
}

export { createBillController, deleteBillController, editBillController };
