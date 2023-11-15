import { IsBoolean, IsInt, IsNumber, IsOptional } from 'class-validator';

export class UpdateProductOnSheetDto {
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
