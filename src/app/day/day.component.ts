import { Component, Input } from '@angular/core';
import { Game } from '../game.model';
import { Moment } from 'moment';

@Component({
  selector: 'app-day',
  styles: [
    'mat-card {margin: 24px 0}'
  ],
  template: `
    <mat-card>
      <mat-card-header *ngIf="date">
        <mat-card-title>
          <h3>{{date | amDateFormat:'ddd MMM Do, YYYY'}}</h3>
        </mat-card-title>
      </mat-card-header>
      <mat-card-content *ngIf="games?.length">
        <app-game-table [games]="games"></app-game-table>
      </mat-card-content>
    </mat-card>
  `
})
export class DayComponent {
  @Input()
  public games: Game[];
  @Input()
  public date: Moment;

  constructor() {
  }

}
