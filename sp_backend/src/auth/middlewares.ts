import { NextFunction, Request, Response } from "express";
import { JwtPayload, verify } from "jsonwebtoken";
import { UnauthorizedError } from "../error/types";

async function ensureLoggedIn(req: Request, res: Response, next: NextFunction) {
  // Ensures authorization header is present
  if (req.headers.authorization == null) {
    next(new UnauthorizedError("No token present"));
    return;
  }

  const token = req.headers.authorization.split(" ")[1];

  // Ensures token is present
  if (token == null) {
    next(new UnauthorizedError("No token present"));
    return;
  }

  let payload: string | JwtPayload;

  // Ensures token is valid
  try {
    payload = verify(token, process.env.JWT_SECRET);
  } catch (err) {
    next(new UnauthorizedError("Invalid token"));
    return;
  }
  if (payload == null) {
    next(new UnauthorizedError("Invalid token"));
    return;
  }

  // Passes the userId and uid to the request object
  req.userId = (payload as JwtPayload).userId;
  req.uid = (payload as JwtPayload).uid;

  next();
}

// For allowing typescript to recognize the userId property on the Request object
declare global {
  namespace Express {
    interface Request {
      userId: string;
      uid: string;
    }
  }
}

export { ensureLoggedIn };
