import { HttpException, PipeTransform } from '@nestjs/common';
import { ProductOnSheetDto } from '../dto/product-on-sheet.dto';

export class ValidateCreateDtoPipe implements PipeTransform {
  transform(createProductOnSheetDto: ProductOnSheetDto) {
    if (
      !createProductOnSheetDto.product_code &&
      !createProductOnSheetDto.productId
    )
      throw new HttpException(
        'Product code or product id must be provided',
        400,
      );

    return createProductOnSheetDto;
  }
}
