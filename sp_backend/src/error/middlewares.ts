import { Request, Response, NextFunction } from "express";
import { BadRequestError, UnauthorizedError } from "./types";

import { validationResult } from "express-validator";

function errorMiddleware(
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) {
  if (err instanceof BadRequestError) {
    res.status(400).send({
      error: err.message,
    });
  } else if (err instanceof UnauthorizedError) {
    res.status(401).send({
      error: err.message,
    });
  } else {
    console.log(err);
    res.status(500).send({
      error: "Something went wrong",
    });
  }
}

const validationMiddleware = (req: Request, res, next) => {
  const validationErrors = validationResult(req);
  if (!validationErrors.isEmpty()) {
    throw new BadRequestError(validationErrors.array()[0].msg);
  }
  next();
};

export { errorMiddleware, validationMiddleware };
