import { Router } from "express";
import { signUpController, signInController } from "./controllers";

const router = Router();

router.post("/signup", signUpController);
router.post("/signin", signInController);

export default router;
