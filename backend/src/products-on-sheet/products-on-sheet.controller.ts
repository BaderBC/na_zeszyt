import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Delete,
  UsePipes,
  Query,
} from '@nestjs/common';
import { ProductsOnSheetService } from './products-on-sheet.service';
import { ProductOnSheetDto } from './dto/product-on-sheet.dto';
import { UpdateProductOnSheetDto } from './dto/update-product-on-sheet.dto';
import { ValidateCreateDtoPipe } from './pipes/validateCreateDto.pipe';

@Controller('products-on-sheet')
export class ProductsOnSheetController {
  constructor(private readonly productOnSheetService: ProductsOnSheetService) {}

  @Post('/create')
  @UsePipes(new ValidateCreateDtoPipe())
  create(@Body() createProductOnSheetDto: ProductOnSheetDto) {
    console.log(createProductOnSheetDto);
    return this.productOnSheetService.create(createProductOnSheetDto);
  }

  @Post('/createOrIncreaseCount')
  createOrIncreaseCount(@Body() dto: ProductOnSheetDto) {
    return this.productOnSheetService.createOrIncreaseCount(dto);
  }

  @Get()
  findAll() {
    return this.productOnSheetService.findAll();
  }

  @Patch()
  update(
    @Query('id') id: string,
    @Body() updateProductOnSheetDto: UpdateProductOnSheetDto,
  ) {
    return this.productOnSheetService.update(+id, updateProductOnSheetDto);
  }

  @Post('increase')
  increaseCount(
    @Query('id') id?: string,
    @Query('code') code?: string,
    @Body('count') count?: number,
  ) {
    return this.productOnSheetService.increaseCount(code, +id || null, count);
  }

  @Delete()
  async remove(@Query('id') id: string) {
    await this.productOnSheetService.remove(+id);
  }
}
