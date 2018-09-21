import { Component, OnInit } from '@angular/core';
import * as moment from 'moment';
import { Moment } from 'moment';
import { Observable } from 'rxjs';
import { startWith } from 'rxjs/operators';

import { GamesService } from './games.service';
import { Schedule } from './game.model';

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
        *ngFor="let entries of objectEntries(schedule | async)"
        [date]="getMoment(entries[0])"
        [games]="entries[1]">
      </app-day>
    </div>
  `
})
export class AppComponent implements OnInit {
  public schedule: Observable<Schedule>;
  public loading = true;
  protected objectEntries = Object.entries;

  constructor(private gameSvc: GamesService) {
  }

  public ngOnInit() {
    this.loading = true;
    this.schedule = this.gameSvc.schedule.pipe(startWith({} as Schedule));
    const noop = () => {
    };
    const onerror = (err) => {
      console.error('error getting sked', err);
    };
    this.schedule.subscribe(noop, onerror, () => this.loading = false);
  }

  protected getMoment(date: string): Moment {
    return moment(date);
  }

}
