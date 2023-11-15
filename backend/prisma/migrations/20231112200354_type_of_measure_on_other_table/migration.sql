/*
  Warnings:

  - You are about to drop the column `type_of_measure` on the `productOnSheet` table. All the data in the column will be lost.
  - Made the column `name` on table `product` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "product" ADD COLUMN     "type_of_measure" "TypeOfMeasure" NOT NULL DEFAULT 'unit',
ALTER COLUMN "name" SET NOT NULL;

-- AlterTable
ALTER TABLE "productOnSheet" DROP COLUMN "type_of_measure",
ALTER COLUMN "added_date" SET DEFAULT NOW();
