import { NextFunction, Request, Response } from "express";
import { db } from "../db";
import { BadRequestError } from "../error/types";
import { getGroupById, userInGroup } from "./services";

async function createGroupController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const name: string = req.body.name;

  // Create group
  const newGroup = await db.group.create({
    data: {
      name: name,
      users: {
        connect: {
          id: req.uid,
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

  // Fetch group
  const group = await getGroupById(id);

  // Check if group exists
  if (!group) {
    next(new BadRequestError("Group does not exist"));
    return;
  }

  // Check if user is in group
  if (!userInGroup(group, req.uid)) {
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

  // Fetch group
  const group = await getGroupById(groupId);

  // Check if group exists
  if (!group) {
    next(new BadRequestError("Group does not exist"));
    return;
  }

  // Check if user is in group
  if (userInGroup(group, req.uid)) {
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
          id: req.uid,
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

  // Fetch group
  const group = await getGroupById(groupId);

  // Check if group exists
  if (!group) {
    next(new BadRequestError("Group does not exist"));
    return;
  }

  // Check if user is in group
  if (!userInGroup(group, req.uid)) {
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
          id: req.uid,
        },
      },
    },
  });

  res.status(200).json({ message: "Left group" });
}

async function getGroupDataController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const groupId = req.params.id;

  // Fetch group
  const group = await db.group.findUnique({
    where: {
      id: groupId,
    },
    include: {
      users: {
        select: {
          id: true,
          userId: true,
          name: true,
        },
      },
      bills: {
        include: {
          owes: true,
        },
      },
    },
  });

  // Check if group exists
  if (!group) {
    next(new BadRequestError("Group does not exist"));
    return;
  }

  // Check if user is in group
  if (!userInGroup(group, req.uid)) {
    next(new BadRequestError("User is not in group"));
    return;
  }

  res.status(200).json(group);
}

export {
  createGroupController,
  editGroupController,
  joinGroupController,
  leaveGroupController,
  getGroupDataController,
};
