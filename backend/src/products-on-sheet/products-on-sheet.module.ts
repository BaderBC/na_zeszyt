import { Module } from '@nestjs/common';
import { ProductsOnSheetService } from './products-on-sheet.service';
import { ProductsOnSheetController } from './products-on-sheet.controller';

@Module({
  controllers: [ProductsOnSheetController],
  providers: [ProductsOnSheetService],
})
export class ProductsOnSheetModule {}
