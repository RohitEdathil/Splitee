import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import {
  changeStatusController,
  createBillController,
  deleteBillController,
  editBillController,
} from "./controllers";
import {
  changeStatusValidator,
  createBillValidator,
  deleteBillValidator,
  editBillValidator,
} from "./validators";

const router = Router();

router.post(
  "/create",
  createBillValidator,
  validationMiddleware,
  createBillController
);

router.put(
  "/status",
  changeStatusValidator,
  validationMiddleware,
  changeStatusController
);

router.put(
  "/:billId",
  editBillValidator,
  validationMiddleware,
  editBillController
);

router.delete(
  "/delete",
  deleteBillValidator,
  validationMiddleware,
  deleteBillController
);

export default router;
