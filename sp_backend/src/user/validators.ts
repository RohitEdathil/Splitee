import { body } from "express-validator";

const editUserValidator = [
  body("name").optional().isString().withMessage("Invalid name format"),
  body("email").optional().isEmail().withMessage("Invalid email format"),
];

export { editUserValidator };
