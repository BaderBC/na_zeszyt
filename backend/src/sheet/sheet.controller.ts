import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Delete,
  Query,
} from '@nestjs/common';
import { SheetService } from './sheet.service';
import { SheetDto } from './dto/sheet.dto';

@Controller('sheet')
export class SheetController {
  constructor(private readonly sheetService: SheetService) {}

  @Post()
  async create(@Body() sheetDto: SheetDto) {
    await this.sheetService.create(sheetDto);
  }

  @Get()
  findOne(@Query('name') name: string) {
    if (name) {
      return this.sheetService.findOne(name);
    }
    return this.sheetService.findAll();
  }

  @Patch()
  update(@Query('name') name: string, @Body() sheetDto: SheetDto) {
    return this.sheetService.update(name, sheetDto);
  }

  @Delete()
  remove(@Query('name') name: string) {
    return this.sheetService.remove(name);
  }
}
