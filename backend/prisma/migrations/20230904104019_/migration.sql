/*
  Warnings:

  - You are about to drop the `Sheet` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "TypeOfMeasure" AS ENUM ('unit', 'kg');

-- DropTable
DROP TABLE "Sheet";

-- CreateTable
CREATE TABLE "sheet" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "products" INTEGER[],

    CONSTRAINT "sheet_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "productOnSheet" (
    "id" SERIAL NOT NULL,
    "added_date" TIMESTAMP(3) NOT NULL DEFAULT NOW(),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "type_of_measure" "TypeOfMeasure" NOT NULL DEFAULT 'unit',
    "count" DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    "universalProductCodeId" INTEGER NOT NULL,
    "sheetId" INTEGER NOT NULL,

    CONSTRAINT "productOnSheet_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product" (
    "id" SERIAL NOT NULL,
    "code" TEXT,
    "name" TEXT,

    CONSTRAINT "product_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "product_code_key" ON "product"("code");

-- AddForeignKey
ALTER TABLE "productOnSheet" ADD CONSTRAINT "productOnSheet_universalProductCodeId_fkey" FOREIGN KEY ("universalProductCodeId") REFERENCES "product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "productOnSheet" ADD CONSTRAINT "productOnSheet_sheetId_fkey" FOREIGN KEY ("sheetId") REFERENCES "sheet"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
