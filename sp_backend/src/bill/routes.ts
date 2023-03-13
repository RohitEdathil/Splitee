import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import { createBillController } from "./controllers";
import { createBillValidator } from "./validators";

const router = Router();

router.post(
  "/create",
  createBillValidator,
  validationMiddleware,
  createBillController
);

export default router;
