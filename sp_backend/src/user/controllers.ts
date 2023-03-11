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
    response["groups"] = user.groupIds;
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

export { userDataController, editUserController };
