import {
  IsBoolean,
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';

export class ProductOnSheetDto {
  @IsNotEmpty()
  @IsEnum(['kg', 'unit'])
  type_of_measure: 'kg' | 'unit';

  @IsOptional()
  @IsNumber()
  count?: number;

  @IsOptional()
  @IsBoolean()
  is_active: boolean;

  @IsOptional()
  @IsNumber()
  @IsInt()
  productId?: number;

  @IsOptional()
  @IsString()
  product_code?: string;

  @IsNotEmpty()
  @IsNumber()
  @IsInt()
  sheetId: number;
}
