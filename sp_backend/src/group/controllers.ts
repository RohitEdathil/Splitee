import { MaxHeap, MinHeap } from "@datastructures-js/heap";
import { Status } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import { db } from "../db";
import { BadRequestError } from "../error/types";
import { getGroupById, userInGroup } from "./services";
import { balanceValue, IBalance } from "./structures";

async function createGroupController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const name: string = req.body.name;

  // Create group
  const newGroup = await db.group.create({
    data: {
      name: name,
      users: {
        connect: {
          id: req.uid,
        },
      },
    },
  });

  res.status(200).json({ message: "Group created" });
}

async function editGroupController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const name: string = req.body.name;
  const id: string = req.params.id;

  // Fetch group
  const group = await getGroupById(id);

  // Check if group exists
  if (!group) {
    next(new BadRequestError("Group does not exist"));
    return;
  }

  // Check if user is in group
  if (!userInGroup(group, req.uid)) {
    next(new BadRequestError("User is not in group"));
    return;
  }

  // Edit group
  await db.group.update({
    where: {
      id: group.id,
    },
    data: {
      name: name,
    },
  });

  res.status(200).json({ message: "Group edited" });
}

async function joinGroupController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const groupId: string = req.body.groupId;

  // Fetch group
  const group = await getGroupById(groupId);

  // Check if group exists
  if (!group) {
    next(new BadRequestError("Group does not exist"));
    return;
  }

  // Check if user is in group
  if (userInGroup(group, req.uid)) {
    next(new BadRequestError("User is already in group"));
    return;
  }

  // Add user to group
  await db.group.update({
    where: {
      id: group.id,
    },
    data: {
      users: {
        connect: {
          id: req.uid,
        },
      },
    },
  });

  res.status(200).json({ message: "Joined in group" });
}

async function leaveGroupController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const groupId = req.body.groupId;

  // Fetch group
  const group = await getGroupById(groupId);

  // Check if group exists
  if (!group) {
    next(new BadRequestError("Group does not exist"));
    return;
  }

  // Check if user is in group
  if (!userInGroup(group, req.uid)) {
    next(new BadRequestError("User is not in group"));
    return;
  }

  // Remove user from group
  await db.group.update({
    where: {
      id: group.id,
    },
    data: {
      users: {
        disconnect: {
          id: req.uid,
        },
      },
    },
  });

  // Set all bills as individual
  await db.bill.updateMany({
    where: {
      groupId: group.id,
      creditorId: req.uid,
    },
    data: {
      groupId: null,
    },
  });

  // Fetch associated owes
  const owes = await db.owe.findMany({
    where: {
      bill: {
        groupId: group.id,
      },
      debtorId: req.uid,
    },
  });

  // Set all owes as individual
  await Promise.all(
    owes.map(async (owe) => {
      await db.bill.update({
        where: {
          id: owe.billId,
        },
        data: {
          groupId: null,
        },
      });
    })
  );
  res.status(200).json({ message: "Left group" });
}

async function getGroupDataController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const groupId = req.params.id;

  // Fetch group
  const group = await db.group.findUnique({
    where: {
      id: groupId,
    },
    include: {
      users: {
        select: {
          id: true,
          userId: true,
          name: true,
        },
      },
      bills: {
        include: {
          owes: true,
        },
      },
    },
  });

  // Check if group exists
  if (!group) {
    next(new BadRequestError("Group does not exist"));
    return;
  }

  // Check if user is in group
  if (!userInGroup(group, req.uid)) {
    next(new BadRequestError("User is not in group"));
    return;
  }

  res.status(200).json(group);
}

async function redistributeController(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const groupId = req.params.groupId;

  // Fetch group
  const group = await getGroupById(groupId);

  // Check if group exists
  if (!group) {
    next(new BadRequestError("Group does not exist"));
    return;
  }

  // Check if user is in group
  if (!userInGroup(group, req.uid)) {
    next(new BadRequestError("User is not in group"));
    return;
  }

  // Fetch all bills
  const bills = await db.bill.findMany({
    where: {
      groupId: group.id,
    },
    include: {
      owes: true,
    },
  });

  const balance: Map<string, number> = new Map();

  // Calculate balance for each user
  for (const bill of bills) {
    if (!balance.has(bill.creditorId)) balance.set(bill.creditorId, 0);

    for (const owe of bill.owes) {
      if (!balance.has(owe.debtorId)) balance.set(owe.debtorId, 0);

      if (owe.status === Status.PAID) continue;

      balance.set(bill.creditorId, balance.get(bill.creditorId)! + owe.amount);
      balance.set(owe.debtorId, balance.get(owe.debtorId)! - owe.amount);
    }
  }

  // Min and Max heaps
  const minHeap: MinHeap<IBalance> = new MinHeap(balanceValue);
  const maxHeap: MaxHeap<IBalance> = new MaxHeap(balanceValue);

  // Insert all balances into heaps
  for (const [userId, amount] of balance) {
    if (amount < 0) minHeap.insert({ userId, amount });
    else if (amount > 0) maxHeap.insert({ userId, amount });
  }

  const newRoughBills: Map<string, Map<string, number>> = new Map();

  // Redistribute
  while (minHeap.size() > 0 && maxHeap.size() > 0) {
    // Pick largest creditor and smallest debtor
    const minVal = minHeap.extractRoot();
    const maxVal = maxHeap.extractRoot();

    if (!newRoughBills.has(maxVal.userId))
      newRoughBills.set(maxVal.userId, new Map());

    if (!newRoughBills.get(maxVal.userId).has(minVal.userId))
      newRoughBills.get(maxVal.userId).set(minVal.userId, 0);

    // Difference between the two
    const diff = minVal.amount + maxVal.amount;
    // Amount to be transferred
    const amount = Math.min(-minVal.amount, maxVal.amount);

    newRoughBills.get(maxVal.userId).set(minVal.userId, amount);

    // If difference is 0, then both are settled
    // If difference is > 0, then maxVal is still left with some amount
    // If difference is < 0, then minVal is still left with some amount
    if (diff < 0) {
      minHeap.insert({ userId: minVal.userId, amount: diff });
    } else if (diff > 0) {
      maxHeap.insert({ userId: maxVal.userId, amount: diff });
    }
  }

  // Delete all old owes
  await db.owe.deleteMany({
    where: {
      bill: {
        groupId: group.id,
      },
    },
  });

  // Delete all old bills
  await db.bill.deleteMany({
    where: {
      groupId: group.id,
    },
  });

  const idToName: Map<string, string> = new Map();

  // Fetch all users
  const users = await db.user.findMany({
    where: {
      id: {
        in: Array.from(balance.keys()),
      },
    },
  });

  // Map user id to name
  for (const user of users) {
    idToName.set(user.id, user.name);
  }

  // Create new bills
  await Promise.all(
    Array.from(newRoughBills).map(async ([creditorId, owes]) => {
      await db.bill.create({
        data: {
          creditorId,
          groupId: group.id,
          amount: balance.get(creditorId)!,
          title: "[Simplified] " + idToName.get(creditorId)!,
          owes: {
            create: Array.from(owes).map(([debtorId, amount]) => ({
              debtorId,
              amount,
              status: "PENDING",
            })),
          },
        },
      });
    })
  );

  res.json({ message: "Redistributed Successfully" });
}

export {
  createGroupController,
  editGroupController,
  joinGroupController,
  leaveGroupController,
  getGroupDataController,
  redistributeController,
};
