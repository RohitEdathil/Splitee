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

async function inviteUserController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const groupId: string = req.body.groupId;
  const fromUser: string = req.userId;

  const toUsers: string[] = req.body.toUsers;

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

  // Fetch inviter
  const inviter = await db.user.findFirst({
    where: {
      userId: fromUser,
    },
  });

  // Check if user is in group
  if (!group.usersIds.includes(inviter.id)) {
    next(new BadRequestError("User is not in group"));
    return;
  }

  // Fetch users
  const users = await db.user.findMany({
    where: {
      id: {
        in: toUsers,
      },
    },
  });

  // Check if users exist
  if (users.length !== toUsers.length) {
    next(new BadRequestError("Some users do not exist"));
    return;
  }

  // For each user, check if they are already in group or is the user inviting themselves
  for (const user of users) {
    if (user.id === inviter.id) {
      next(new BadRequestError("User cannot invite themselves"));
      return;
    }
    if (group.usersIds.includes(user.id)) {
      next(new BadRequestError(`User ${user.userId} is already in group`));
      return;
    }
  }

  // Send invites
  await db.invite.createMany({
    data: users.map((user) => ({
      byUserId: inviter.id,
      userId: user.id,
      groupId: group.id,
      status: "PENDING",
    })),
  });

  res.status(200).json({ message: "Invites sent" });
}

export { createGroupController, editGroupController, inviteUserController };
