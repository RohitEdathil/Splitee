import { NextFunction, Request, Response } from "express";
import { db } from "../db";
import { BadRequestError } from "../error/types";

async function userDataController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const id = req.params.id;

  // Fetch the user
  const user = await db.user.findFirst({
    where: {
      userId: id,
    },
    include: {
      groups: req.userId === id,
    },
  });

  // Ensures the user exists
  if (user == null) {
    next(new BadRequestError("User not found"));
    return;
  }

  const response = {
    id: user.id,
    userId: user.userId,
    name: user.name,
  };

  // Only returns the email and groups if the user is requesting their own data
  if (req.userId === id) {
    response["email"] = user.email;
    response["groups"] = user.groups;
  }

  res.json(response);
}

async function editUserController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const id = req.userId;

  const name: String = req.body.name;
  const email: String = req.body.email;

  const mutation = {};

  // Only updates the name and email if they are not null
  if (name != null) {
    mutation["name"] = name;
  }
  if (email != null) {
    mutation["email"] = email;
  }

  // Updates the user
  const user = await db.user.update({
    where: {
      userId: id,
    },
    data: mutation,
  });

  res.json({
    message: "User updated",
  });
}

async function searchUserController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const query: string = req.query.query as string;

  if (query.length < 2) {
    res.json([]);
    return;
  }

  // Fetches the users
  const users = await db.user.findMany({
    where: {
      userId: {
        startsWith: query,
      },
    },
  });

  const response = users.map((user) => {
    return {
      id: user.id,
      userId: user.userId,
      name: user.name,
    };
  });

  res.json(response);
}

export { userDataController, editUserController, searchUserController };