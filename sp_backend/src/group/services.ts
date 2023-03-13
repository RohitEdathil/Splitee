import { Group } from "@prisma/client";
import { db } from "../db";

async function getGroupById(id: string) {
  return await db.group.findFirst({
    where: {
      id: id,
    },
  });
}

function userInGroup(group: Group, uid: string) {
  return group.usersIds.includes(uid);
}

export { getGroupById, userInGroup };
