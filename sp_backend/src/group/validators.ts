import { body, param } from "express-validator";

const createGroupValidator = [
  body("name")
    .isString()
    .isLength({ min: 1, max: 150 })
    .withMessage("Name must be between 1 and 150 characters"),
];

const editGroupValidator = [
  body("name")
    .isString()
    .isLength({ min: 1, max: 150 })
    .withMessage("Name must be between 1 and 150 characters"),
  param("id")
    .notEmpty()
    .withMessage("Id is required")
    .isMongoId()
    .withMessage("Invalid id"),
];

export { createGroupValidator, editGroupValidator };
