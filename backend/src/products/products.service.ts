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

  async createFromEAN(EAN: string) {
    const url = `https://barcodes1.p.rapidapi.com/?query=${EAN}`;
    const options = {
      method: 'GET',
      headers: {
        'X-RapidAPI-Key': process.env.RAPID_API_KEY,
        'X-RapidAPI-Host': 'barcodes1.p.rapidapi.com',
      },
    };

    const res = await fetch(url, options).then((res) => res.json());
    const product = await res.product;

    let image: Buffer = null;
    if (product?.images?.length > 0)
      image = await this.imageUrlToBytes(product.images[0]);

    return this.prisma.product.create({
      data: {
        name: product.title,
        code: EAN,
        image,
      },
    });
  }

  async imageUrlToBytes(url: string): Promise<Buffer> {
    const res = await fetch(url);
    const blob = await res.blob();
    const arrayBuffer = await blob.arrayBuffer();
    return Buffer.from(arrayBuffer);
  }

  findOne(barcode: string) {
    return this.prisma.product.findUniqueOrThrow({
      where: { code: barcode },
    });
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
