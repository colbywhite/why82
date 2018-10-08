import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';
import { NavModule } from './nav/nav.module';
import { DayModule } from './day/day.module';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserAnimationsModule,
    BrowserModule,
    HttpClientModule,
    MatProgressSpinnerModule,
    NavModule,
    DayModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {
}
