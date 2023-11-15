import { Injectable } from '@nestjs/common';
import { ProductOnSheetDto } from './dto/product-on-sheet.dto';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateProductOnSheetDto } from './dto/update-product-on-sheet.dto';

@Injectable()
export class ProductsOnSheetService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: ProductOnSheetDto) {
    const { prisma } = this;
    let productId: number;

    console.log('product_code', dto.product_code);

    if (dto.product_code) {
      const { id: _productId } = await prisma.product.findFirstOrThrow({
        where: { code: dto.product_code },
        select: { id: true },
      });
      productId = _productId;
    }

    const productOnSheet = await this.prisma.productOnSheet.create({
      data: {
        count: dto.count,
        sheetId: dto.sheetId,
        productId: dto.productId || productId,
      },
      select: { id: true },
    });

    return { productOnSheetId: productOnSheet.id };
  }

  async increaseCount(code?: string, id?: number, count?: number) {
    let where: any;

    if (id) {
      where = { id };
    } else {
      where = { product: { code }, is_active: true };
    }

    const dbRes = await this.prisma.productOnSheet.updateMany({
      where,
      data: {
        count: { increment: count || 1 },
      },
    });
    return dbRes ? dbRes[0] : null;
  }

  async createOrIncreaseCount(dto: ProductOnSheetDto) {
    const activeProducts = await this.prisma.productOnSheet.findMany({
      where: {
        is_active: true,
        sheetId: dto.sheetId,
        product: { code: dto.product_code },
      },
    });
    if (activeProducts.length > 0) {
      return await this.increaseCount(dto.product_code, null, dto.count);
    }
    return await this.create(dto);
  }

  async findAll() {
    return await this.prisma.productOnSheet.findMany();
  }

  async update(id: number, dto: UpdateProductOnSheetDto) {
    await this.prisma.productOnSheet.update({
      where: { id },
      data: dto,
    });
  }

  async remove(id: number) {
    await this.prisma.productOnSheet.delete({ where: { id } });
  }
}
