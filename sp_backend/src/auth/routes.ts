import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import { signUpController, signInController } from "./controllers";
import { signUpValidation, signInValidation } from "./validators";

const router = Router();

router.post(
  "/signup",
  signUpValidation,
  validationMiddleware,
  signUpController
);
router.post(
  "/signin",
  signInValidation,
  validationMiddleware,
  signInController
);

export default router;
