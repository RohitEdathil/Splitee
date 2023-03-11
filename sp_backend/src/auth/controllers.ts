import { NextFunction, Request, Response } from "express";
import { db } from "../db";
import { BadRequestError } from "../error/types";
import { sign } from "jsonwebtoken";
import { hash, compare } from "bcrypt";
import { validationResult } from "express-validator/src/validation-result";

async function signUpController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const { userId, name, password, email } = req.body;

  // Check if the username is taken
  const existingUser = await db.user.findFirst({
    where: {
      userId: userId,
    },
  });
  if (existingUser != null) {
    next(new BadRequestError("Username is taken"));
    return;
  }

  // Create the user
  await db.user.create({
    data: {
      userId: userId,
      name: name,
      password: await hash(password, 3),
      email: email,
    },
  });

  // Generate the JWT token
  const token = sign({ userId: userId }, process.env.JWT_SECRET, {
    expiresIn: "30d",
  });

  res.json({ token: token });
}

function signInController(req: Request, res: Response) {
  // Ensure that all required arguments are present
}

export { signUpController, signInController };
