/*
  Warnings:

  - You are about to drop the column `universalProductCodeId` on the `productOnSheet` table. All the data in the column will be lost.
  - Added the required column `productId` to the `productOnSheet` table without a default value. This is not possible if the table is not empty.

*/

-- CUSTOM MIGRATION:

ALTER TABLE "productOnSheet" RENAME COLUMN "universalProductCodeId" TO "productId";
