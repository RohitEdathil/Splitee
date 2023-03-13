import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import {
  createBillController,
  deleteBillController,
  editBillController,
} from "./controllers";
import {
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
