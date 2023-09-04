/*
  Warnings:

  - A unique constraint covering the columns `[name]` on the table `sheet` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "productOnSheet" ALTER COLUMN "added_date" SET DEFAULT NOW();

-- CreateIndex
CREATE UNIQUE INDEX "sheet_name_key" ON "sheet"("name");
