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

const joinGroupValidator = [
  body("groupId")
    .notEmpty()
    .withMessage("Group id is required")
    .isMongoId()
    .withMessage("Invalid group id"),
];

export { createGroupValidator, editGroupValidator, joinGroupValidator };
