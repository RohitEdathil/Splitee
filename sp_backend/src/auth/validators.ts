import { body } from "express-validator";

const signUpValidation = [
  body("name")
    .notEmpty()
    .withMessage("Missing name")
    .isString()
    .withMessage("Invalid name format"),

  body("password")
    .notEmpty()
    .withMessage("Missing password")
    .isString()
    .withMessage("Invalid password format"),

  body("email")
    .notEmpty()
    .withMessage("Missing email")
    .isEmail()
    .withMessage("Invalid email format"),

  body("userId")
    .notEmpty()
    .withMessage("Missing userId")
    .isString()
    .withMessage("Invalid userId format")
    .matches(/^[a-zA-Z0-9_]*$/)
    .withMessage("Invalid username format"),
];

const signInValidation = [
  body("userId")
    .notEmpty()
    .withMessage("Missing userId")
    .isString()
    .withMessage("Invalid userId format"),

  body("password")
    .notEmpty()
    .withMessage("Missing password")
    .isString()
    .withMessage("Invalid password format"),
];

export { signUpValidation, signInValidation };
