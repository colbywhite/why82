import { NgModule } from '@angular/core';
import { MatTableModule } from '@angular/material';
import { MatGridListModule } from '@angular/material/grid-list';
import { MomentModule } from 'ngx-moment';

import { GameTableComponent } from './game-table.component';
import { TeamModule } from '../team/team.module';
import { CommonModule } from '@angular/common';

@NgModule({
  declarations: [GameTableComponent],
  exports: [GameTableComponent],
  imports: [
    TeamModule,
    CommonModule,
    MatGridListModule,
    MatTableModule,
    MomentModule
  ]
})
export class GameTableModule {
}
