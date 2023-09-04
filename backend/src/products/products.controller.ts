import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Delete,
  Query,
} from '@nestjs/common';
import { ProductsService } from './products.service';
import { ProductDto } from './dto/product.dto';

@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Post()
  create(@Body() dto: ProductDto) {
    return this.productsService.create(dto);
  }

  @Get()
  findAll() {
    return this.productsService.findAll();
  }

  @Patch()
  update(@Query('id') id: string, @Body() dto: ProductDto) {
    return this.productsService.update(+id, dto);
  }

  @Delete()
  remove(@Query('id') id: string) {
    return this.productsService.remove(+id);
  }
}
