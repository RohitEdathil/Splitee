import { body, query } from "express-validator";

const editUserValidator = [
  body("name").optional().isString().withMessage("Invalid name format"),
  body("email").optional().isEmail().withMessage("Invalid email format"),
];

const searchUserValidator = [
  query("query")
    .notEmpty()
    .withMessage("Query must be present")
    .isString()
    .withMessage("Invalid query format"),
];

export { editUserValidator, searchUserValidator };
