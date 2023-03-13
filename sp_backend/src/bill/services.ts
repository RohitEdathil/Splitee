import { db } from "../db";

async function getBillById(billId: string) {
  return await db.bill.findFirst({
    where: {
      id: billId,
    },
  });
}

async function getOweById(oweId: string) {
  return await db.owe.findFirst({
    where: {
      id: oweId,
    },
    include: {
      bill: true,
    },
  });
}

export { getBillById, getOweById };
