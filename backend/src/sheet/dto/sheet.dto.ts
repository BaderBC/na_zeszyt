import { IsString } from 'class-validator';

export class SheetDto {
  @IsString()
  name: string;
}
