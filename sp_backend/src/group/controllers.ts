import { NextFunction, Request, Response } from "express";
import { db } from "../db";
import { BadRequestError } from "../error/types";

async function createGroupController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const name: string = req.body.name;

  const userId: string = req.userId;

  // Fetch user
  const createdBy = await db.user.findFirst({
    where: {
      userId: userId,
    },
  });

  // Create group
  await db.group.create({
    data: {
      name: name,
      usersIds: [createdBy.id],
    },
  });

  res.status(200).json({ message: "Group created" });
}

async function editGroupController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const name: string = req.body.name;
  const id: string = req.params.id;

  const userId: string = req.userId;

  // Fetch user
  const editedBy = await db.user.findFirst({
    where: {
      userId: userId,
    },
  });

  // Fetch group
  const group = await db.group.findFirst({
    where: {
      id: id,
    },
  });

  // Check if group exists
  if (!group) {
    next(new BadRequestError("Group does not exist"));
    return;
  }

  // Check if user is in group
  if (!group.usersIds.includes(editedBy.id)) {
    next(new BadRequestError("User is not in group"));
    return;
  }

  // Edit group
  await db.group.update({
    where: {
      id: group.id,
    },
    data: {
      name: name,
    },
  });

  res.status(200).json({ message: "Group edited" });
}

export { createGroupController, editGroupController };
