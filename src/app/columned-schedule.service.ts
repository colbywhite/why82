import { Injectable } from '@angular/core';
import { ScheduleService } from './schedule.service';
import { MediaChange, ObservableMedia } from '@angular/flex-layout';
import { ColumnedSchedule, Columner, Game, Schedule } from './game.model';
import { distinctUntilChanged, map } from 'rxjs/operators';
import { combineLatest, Observable } from 'rxjs';

const GRID: Map<string, number> = new Map([
  ['xs', 1],
  ['sm', 2],
  ['md', 2],
  ['lg', 2],
  ['xl', 2]
]);

@Injectable({
  providedIn: 'root'
})
export class ColumnedScheduleService {

  constructor(private scheduleSvc: ScheduleService, private mediaSvc: ObservableMedia) {
  }

  public get columnedSchedule(): Observable<ColumnedSchedule> {
    const columns: Observable<number> = this.mediaSvc.asObservable()
      .pipe(
        distinctUntilChanged(),
        map(this.getColumns),
        distinctUntilChanged(),
      );
    const schedule: Observable<Schedule> = this.scheduleSvc.schedule;
    // TODO: don't use the deprecated version
    return combineLatest(schedule, columns, Columner.splitIntoColumns);
  }

  public getColumns = (change: MediaChange): number => GRID.get(change.mqAlias);
}
