import { body, param } from "express-validator";

const createBillValidator = [
  body("title")
    .notEmpty()
    .withMessage("Title is required")
    .isString()
    .withMessage("Title must be a string"),
  body("amount")
    .notEmpty()
    .withMessage("Amount is required")
    .isNumeric()
    .withMessage("Amount must be a number"),
  body("groupId").optional().isMongoId().withMessage("Invalid group id"),
  body("owes").notEmpty().withMessage("Owes is required"),
  body("owes.*").isInt({ min: 0 }).withMessage("Owes must be a number"),
];

const deleteBillValidator = [
  body("billId")
    .notEmpty()
    .withMessage("Bill id is required")
    .isMongoId()
    .withMessage("Invalid bill id"),
];

const editBillValidator = [
  param("billId")
    .notEmpty()
    .withMessage("Bill id is required")
    .isMongoId()
    .withMessage("Invalid bill id"),

  body("title").optional().isString().withMessage("Title must be a string"),
  body("amount").optional().isNumeric().withMessage("Amount must be a number"),
  body("owes.*")
    .optional()
    .isInt({ min: 0 })
    .withMessage("Owes must be a number"),
];

export { createBillValidator, deleteBillValidator, editBillValidator };
