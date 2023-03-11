import { Router } from "express";
import { validationMiddleware } from "../error/middleware";
import { signUpController, signInController } from "./controllers";
import { signupValidation } from "./validators";

const router = Router();

router.post(
  "/signup",
  signupValidation,
  validationMiddleware,
  signUpController
);
router.post("/signin", signInController);

export default router;
