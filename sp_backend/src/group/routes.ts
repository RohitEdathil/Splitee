import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import { createGroupController, editGroupController } from "./controllers";
import { createGroupValidator, editGroupValidator } from "./validators";

const router = Router();

router.post(
  "/create",
  createGroupValidator,
  validationMiddleware,
  createGroupController
);

router.post(
  "/:id",
  editGroupValidator,
  validationMiddleware,
  editGroupController
);

export default router;
