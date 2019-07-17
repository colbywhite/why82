import { NgModule } from '@angular/core';
import { MomentModule } from 'ngx-moment';
import { MatCardModule } from '@angular/material/card';

import { DayComponent } from './day.component';
import { GameTableModule } from '../game-table/game-table.module';
import { CommonModule } from '@angular/common';

@NgModule({
  declarations: [DayComponent],
  exports: [DayComponent],
  imports: [GameTableModule, CommonModule, MatCardModule, MomentModule]
})
export class DayModule {
}
