import { Component } from '@angular/core';
import * as moment from 'moment';
import { Moment } from 'moment';

import { GamesService } from './games.service';
import { Schedule } from './game.model';

@Component({
  selector: 'app-root',
  template: `
    <div>
      <app-nav></app-nav>
      <app-day *ngFor="let date of objectKeys(schedule)" [date]="getMoment(date)" [games]="schedule[date]"></app-day>
    </div>
  `
})
export class AppComponent {
  public schedule: Schedule;
  protected objectKeys = Object.keys;

  constructor(private gameSvc: GamesService) {
    this.schedule = this.gameSvc.schedule;
  }

  protected getMoment(date: string): Moment {
    return moment(date);
  }

}
