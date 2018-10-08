import { Component, OnInit } from '@angular/core';
import * as moment from 'moment';
import { Moment } from 'moment';
import { Observable } from 'rxjs';
import { map, tap } from 'rxjs/operators';

import { Game } from './game.model';
import { ScheduleService } from './schedule.service';

@Component({
  selector: 'app-root',
  styles: [
    `mat-spinner {margin: 24px auto;}`
  ],
  template: `
    <div>
      <app-nav></app-nav>
      <mat-spinner *ngIf="loading"></mat-spinner>
      <app-day
        *ngFor="let entry of (scheduleEntries | async)"
        [date]="getMoment(entry[0])"
        [games]="entry[1]">
      </app-day>
    </div>
  `
})
export class AppComponent implements OnInit {
  public scheduleEntries: Observable<[string, Game[]][]>;
  public loading = true;

  constructor(private scheduleService: ScheduleService) {
  }

  public ngOnInit() {
    this.loading = true;
    this.scheduleEntries = this.scheduleService.schedule
      .pipe(
        map(Object.entries),
        tap(() => this.loading = false)
      );
  }

  protected getMoment(date: string): Moment {
    return moment(date);
  }
}
