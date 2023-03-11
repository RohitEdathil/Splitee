import { Request, Response, NextFunction } from "express";
import { BadRequestError } from "./types";

import { validationResult } from "express-validator";

function errorMiddleware(
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) {
  if (err instanceof BadRequestError) {
    res.status(403).send({
      error: {
        message: err.message,
      },
    });
  } else {
    console.log(err);
    res.status(500).send({
      error: {
        message: "Something went wrong",
      },
    });
  }
}

const validationMiddleware = (req, res, next) => {
  const validationErrors = validationResult(req);
  if (!validationErrors.isEmpty()) {
    throw new BadRequestError(validationErrors.array()[0].msg);
  }
  next();
};

export { errorMiddleware, validationMiddleware };
