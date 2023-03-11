import { PrismaClient } from "@prisma/client";

const db = new PrismaClient();

function initDB() {
  db.$connect().then(() => {
    console.log("Connected to database");
  });
}

export { db, initDB };
