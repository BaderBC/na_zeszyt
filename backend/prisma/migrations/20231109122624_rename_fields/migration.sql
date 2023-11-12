/*
  Warnings:

  - You are about to drop the column `products` on the `sheet` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "productOnSheet" ALTER COLUMN "added_date" SET DEFAULT NOW();

-- AlterTable
ALTER TABLE "sheet" DROP COLUMN "products";
