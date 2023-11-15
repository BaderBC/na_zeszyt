import { IsEnum, IsNotEmpty, IsString } from 'class-validator';

export class ProductDto {
  @IsNotEmpty()
  @IsString()
  code: string;

  @IsNotEmpty()
  @IsEnum(['kg', 'unit'])
  type_of_measure: 'kg' | 'unit';

  @IsNotEmpty()
  @IsString()
  name: string;
}
