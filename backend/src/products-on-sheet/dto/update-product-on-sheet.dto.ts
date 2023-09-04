import { IsBoolean, IsEnum, IsInt, IsNotEmpty, IsNumber, IsOptional, IsString } from "class-validator";

export class UpdateProductOnSheetDto {
  @IsOptional()
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
  @IsNumber()
  @IsInt()
  sheetId: number;
}
