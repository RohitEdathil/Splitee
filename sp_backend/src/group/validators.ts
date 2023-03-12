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

const inviteUserValidator = [
  body("groupId")
    .notEmpty()
    .withMessage("Group id is required")
    .isMongoId()
    .withMessage("Invalid group id"),

  body("toUsers")
    .notEmpty()
    .withMessage("Recipient user ids are required")
    .isArray({ min: 1 })
    .withMessage("Invalid user ids")
    .custom((value: any) => {
      return value.every((id: any) => {
        return id.match(/^[0-9a-fA-F]{24}$/);
      });
    })
    .withMessage("Invalid user ids"),
];

const respondInviteValidator = [
  body("inviteId")
    .notEmpty()
    .withMessage("Invite id is required")
    .isMongoId()
    .withMessage("Invalid invite id"),
  body("accept")
    .notEmpty()
    .withMessage("Accept is required")
    .isBoolean()
    .withMessage("Decisions must be true or false"),
];

export {
  createGroupValidator,
  editGroupValidator,
  inviteUserValidator,
  respondInviteValidator,
};
