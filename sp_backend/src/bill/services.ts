import { db } from "../db";

async function getBillById(billId: string) {
  return await db.bill.findFirst({
    where: {
      id: billId,
    },
  });
}

export { getBillById };
