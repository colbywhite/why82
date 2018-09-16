import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatCardModule } from '@angular/material/card';
import { MomentModule } from 'ngx-moment';
import { MatGridListModule } from '@angular/material/grid-list';
import { MatTableModule } from '@angular/material/table';

import { AppComponent } from './app.component';
import { NavComponent } from './nav/nav.component';
import { DayComponent } from './day/day.component';
import { GameTableComponent } from './game-table/game-table.component';

@NgModule({
  declarations: [
    AppComponent,
    NavComponent,
    DayComponent,
    GameTableComponent
  ],
  imports: [
    BrowserAnimationsModule,
    BrowserModule,
    MatToolbarModule,
    MatCardModule,
    MatGridListModule,
    MatTableModule,
    MomentModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {
}
