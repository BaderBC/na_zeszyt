import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UsePipes, Query
} from "@nestjs/common";
import { ProductsOnSheetService } from './products-on-sheet.service';
import { ProductOnSheetDto } from './dto/product-on-sheet.dto';
import { UpdateProductOnSheetDto } from './dto/update-product-on-sheet.dto';
import { ValidateCreateDtoPipe } from './pipes/validateCreateDto.pipe';

@Controller('products-on-sheet')
export class ProductsOnSheetController {
  constructor(private readonly productOnSheetService: ProductsOnSheetService) {}

  @Post()
  @UsePipes(new ValidateCreateDtoPipe())
  create(@Body() createProductOnSheetDto: ProductOnSheetDto) {
    console.log(createProductOnSheetDto);
    return this.productOnSheetService.create(createProductOnSheetDto);
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

  @Delete()
  async remove(@Query('id') id: string) {
    await this.productOnSheetService.remove(+id);
  }
}
