import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Delete,
  Query,
  HttpException,
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
  async findOne(
    @Query('barcode') barcode?: string,
    @Query('take') take?: string,
    @Query('skip') skip?: string,
  ) {
    if (!barcode) return this.productsService.findAll(+take || 10, +skip || 0);
    let product = null;

    try {
      product = await this.productsService.findOne(barcode);
    } catch (e) {
      if (e.code != 'P2025') throw e;

      product = await this.productsService
        .createFromEAN(barcode)
        .catch((err) => {
          throw new HttpException(
            `Unrecognized barcode "${barcode}"\n${err}`,
            422,
          );
        });
    }

    return product;
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
