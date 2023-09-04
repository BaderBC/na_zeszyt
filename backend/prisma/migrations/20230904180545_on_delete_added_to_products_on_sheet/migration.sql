-- DropForeignKey
ALTER TABLE "productOnSheet" DROP CONSTRAINT "productOnSheet_productId_fkey";

-- DropForeignKey
ALTER TABLE "productOnSheet" DROP CONSTRAINT "productOnSheet_sheetId_fkey";

-- AlterTable
ALTER TABLE "productOnSheet" ALTER COLUMN "added_date" SET DEFAULT NOW();

-- AddForeignKey
ALTER TABLE "productOnSheet" ADD CONSTRAINT "productOnSheet_productId_fkey" FOREIGN KEY ("productId") REFERENCES "product"("id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "productOnSheet" ADD CONSTRAINT "productOnSheet_sheetId_fkey" FOREIGN KEY ("sheetId") REFERENCES "sheet"("id") ON DELETE NO ACTION ON UPDATE CASCADE;
