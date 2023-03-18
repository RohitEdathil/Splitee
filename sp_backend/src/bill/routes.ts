import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import {
  changeStatusController,
  createBillController,
  deleteBillController,
  editBillController,
  getBillController,
} from "./controllers";
import {
  changeStatusValidator,
  createBillValidator,
  deleteBillValidator,
  editBillValidator,
  getBillValidator,
} from "./validators";

const router = Router();

router.get(
  "/:billId",
  getBillValidator,
  validationMiddleware,
  getBillController
);

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
