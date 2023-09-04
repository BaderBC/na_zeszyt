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

  async findAll() {
    return await this.prisma.sheet.findMany();
  }

  async findOne(name: string) {
    let sheet;
    try {
      sheet = await this.prisma.sheet.findUniqueOrThrow({
        where: { name: name },
      });
    } catch (e) {
      if (!(e instanceof Prisma.PrismaClientKnownRequestError)) return;
      if (e.code === 'P2025') {
        throw new HttpException('Sheet not found', 404);
      }
    }
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
}
