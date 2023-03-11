import { Request, Response, NextFunction } from "express";
import { BadRequestError } from "./types";

function errorMiddleware(
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) {
  if (err instanceof BadRequestError) {
    return res.status(403).send({
      error: {
        message: err.message,
      },
    });
  } else {
    console.log(err);
    return res.status(500).send({
      error: {
        message: "Something went wrong",
      },
    });
  }
}

export { errorMiddleware };
