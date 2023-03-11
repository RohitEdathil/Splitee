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
  const userId: string = req.body.userId;
  const name: string = req.body.name;
  const password: string = req.body.password;
  const email: string = req.body.email;

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

async function signInController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const userId: string = req.body.userId;
  const password: string = req.body.password;

  // Fetch the user
  const user = await db.user.findFirst({
    where: {
      userId: userId,
    },
  });

  // No user found
  if (user == null) {
    next(new BadRequestError("Invalid username or password"));
    return;
  }

  // Check the password
  const passwordMatch = await compare(password, user.password);
  if (!passwordMatch) {
    next(new BadRequestError("Invalid username or password"));
    return;
  }

  // Generate the JWT token
  const token = sign({ userId: userId }, process.env.JWT_SECRET, {
    expiresIn: "30d",
  });

  res.json({ token: token });
}

export { signUpController, signInController };
