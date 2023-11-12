import { HttpException, Injectable } from '@nestjs/common';
import { SheetDto } from './dto/sheet.dto';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';

@Injectable()
export class SheetService {
  constructor(private readonly prisma: PrismaService) {}

  async create(sheetDto: SheetDto) {
    try {
      await this.prisma.sheet.create({
        data: {
          name: sheetDto.name,
        },
      });
    } catch (e) {
      if (!(e instanceof Prisma.PrismaClientKnownRequestError)) return;
      if (e.code === 'P2002') {
        throw new HttpException('Sheet name already exists', 409);
      }
    }
  }

  async findAll(includeProducts?: boolean) {
    const sheets: any[] = await this.prisma.sheet.findMany({
      include: this.getProductInclude(includeProducts || false),
    });
    sheets.map((e) => {
      e.productsCount = e._count.productsOnSheet;
      delete e._count;
      return e;
    });
    return sheets;
  }

  async findOne(name: string, includeProducts?: boolean) {
    let sheet;
    try {
      sheet = await this.prisma.sheet.findUniqueOrThrow({
        where: { name: name },
        include: this.getProductInclude(includeProducts || false),
      });
    } catch (e) {
      if (!(e instanceof Prisma.PrismaClientKnownRequestError)) return;
      if (e.code === 'P2025') {
        throw new HttpException('Sheet not found', 404);
      }
    }
    sheet.productsCount = sheet._count.productsOnSheet;
    delete sheet._count;
    return sheet;
  }

  async update(name: string, sheetDto: SheetDto) {
    try {
      await this.prisma.sheet.update({
        where: { name },
        data: { name: sheetDto.name },
      });
    } catch (e) {
      if (!(e instanceof Prisma.PrismaClientKnownRequestError)) return;
      if (e.code === 'P2002') {
        throw new HttpException('Sheet name already exists', 409);
      }
    }
  }

  async remove(name: string) {
    await this.prisma.sheet.delete({
      where: { name },
    });
  }

  private getProductInclude(includeProducts: boolean): Prisma.sheetInclude {
    const include: Prisma.sheetInclude = {
      _count: {
        select: { productsOnSheet: true },
      },
    };

    if (includeProducts) {
      Object.assign(include, {
        productsOnSheet: {
          include: { product: true },
          orderBy: [{ is_active: 'desc' }, { added_date: 'desc' }],
        },
      });
    }

    return include;
  }
}
