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

export { userDataController };
