import {
  IsBoolean,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';

export class ProductOnSheetDto {
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

  @IsNotEmpty()
  @IsString()
  product_code: string;

  @IsNotEmpty()
  @IsNumber()
  @IsInt()
  sheetId: number;
}
