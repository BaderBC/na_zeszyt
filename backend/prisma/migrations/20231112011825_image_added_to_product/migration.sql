/*
  Warnings:

  - Made the column `code` on table `product` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "product" ADD COLUMN     "image" BYTEA,
ALTER COLUMN "code" SET NOT NULL;

-- AlterTable
ALTER TABLE "productOnSheet" ALTER COLUMN "added_date" SET DEFAULT NOW();
