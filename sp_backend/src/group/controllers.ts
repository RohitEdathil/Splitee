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
  const newGroup = await db.group.create({
    data: {
      name: name,
      users: {
        connect: {
          id: createdBy.id,
        },
      },
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

async function joinGroupController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const groupId: string = req.body.groupId;

  // Fetch user
  const user = await db.user.findFirst({
    where: {
      userId: req.userId,
    },
  });

  // Fetch group
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
  if (group.usersIds.includes(user.id)) {
    next(new BadRequestError("User is already in group"));
    return;
  }

  // Add user to group
  await db.group.update({
    where: {
      id: group.id,
    },
    data: {
      users: {
        connect: {
          id: user.id,
        },
      },
    },
  });

  res.status(200).json({ message: "Joined in group" });
}

async function leaveGroupController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const groupId = req.body.groupId;

  // Fetch user
  const user = await db.user.findFirst({
    where: {
      userId: req.userId,
    },
  });

  // Fetch group
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

  // Remove user from group
  await db.group.update({
    where: {
      id: group.id,
    },
    data: {
      users: {
        disconnect: {
          id: user.id,
        },
      },
    },
  });

  res.status(200).json({ message: "Left group" });
}

export {
  createGroupController,
  editGroupController,
  joinGroupController,
  leaveGroupController,
};
