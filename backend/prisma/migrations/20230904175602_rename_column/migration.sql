-- AlterTable
ALTER TABLE "productOnSheet" ALTER COLUMN "added_date" SET DEFAULT NOW();

-- RenameForeignKey
ALTER TABLE "productOnSheet" RENAME CONSTRAINT "productOnSheet_universalProductCodeId_fkey" TO "productOnSheet_productId_fkey";
