import { IGetCompareValue } from "@datastructures-js/heap";

interface IBalance {
  amount: number;
  userId: string;
}

const balanceValue: IGetCompareValue<IBalance> = (value) => value.amount;

export { balanceValue, IBalance };
