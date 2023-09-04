import { HttpException, Injectable } from '@nestjs/common';
import { ProductDto } from './dto/product.dto';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';

@Injectable()
export class ProductsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: ProductDto) {
    try {
      await this.prisma.product.create({ data: dto });
    } catch (e) {
      if (!(e instanceof Prisma.PrismaClientKnownRequestError)) throw e;
      if (e.code === 'P2002') {
        throw new Error('Product with this code already exists');
      }
    }
  }

  async findAll() {
    return await this.prisma.product.findMany();
  }

  async update(id: number, dto: ProductDto) {
    try {
      await this.prisma.product.update({
        where: { id },
        data: dto,
      });
    } catch (e) {
      if (!(e instanceof Prisma.PrismaClientKnownRequestError)) throw e;
      if (e.code === 'P2002') {
        throw new HttpException('Product with this code already exists', 400);
      }
    }
  }

  async remove(id: number) {
    await this.prisma.product.delete({
      where: { id },
    });
  }
}
