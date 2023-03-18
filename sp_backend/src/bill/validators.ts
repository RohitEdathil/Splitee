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
  body("owes.*").isNumeric().withMessage("Owes must be a number"),
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
  body("owes.*").optional().isNumeric().withMessage("Owes must be a number"),
];

const changeStatusValidator = [
  body("oweId")
    .notEmpty()
    .withMessage("Owe id is required")
    .isMongoId()
    .withMessage("Invalid debt"),
  body("status")
    .notEmpty()
    .withMessage("Status is required")
    .isIn(["PENDING", "PAID"])
    .withMessage("Invalid status"),
];

export {
  createBillValidator,
  deleteBillValidator,
  editBillValidator,
  changeStatusValidator,
};
