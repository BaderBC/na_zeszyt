import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { SheetModule } from './sheet/sheet.module';
import { PrismaModule } from './prisma/prisma.module';
import { ProductsOnSheetModule } from './products-on-sheet/products-on-sheet.module';
import { ProductsModule } from './products/products.module';

@Module({
  imports: [SheetModule, PrismaModule, ProductsOnSheetModule, ProductsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
