import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import { createBillController, deleteBillController } from "./controllers";
import { createBillValidator, deleteBillValidator } from "./validators";

const router = Router();

router.post(
  "/create",
  createBillValidator,
  validationMiddleware,
  createBillController
);

router.delete(
  "/delete",
  deleteBillValidator,
  validationMiddleware,
  deleteBillController
);

export default router;
