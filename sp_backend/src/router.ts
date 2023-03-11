import { Router } from "express";

// App modules
import auth from "./auth/routes";

const router = Router();

router.use("/auth", auth);

export default router;
