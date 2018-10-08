import { Component, Input } from '@angular/core';
import * as moment from 'moment-timezone';

import { Game } from '../game.model';

@Component({
  selector: 'app-game-table',
  styles: [
    ':host ::ng-deep figure.mat-figure {align-items: stretch;}'
  ],
  template: `
    <div *ngIf="gameColumns?.length > 0">
      <div class="row">
        <div *ngFor="let game of gameColumns" class="col-sm-6">
          <div class="row">
            <div class="col my-auto text-center">
              {{formatTime(game.time)}}
            </div>
            <app-team class="col" [team]="game.away"></app-team>
            <app-team class="col" [team]="game.home"></app-team>
          </div>
        </div>
      </div>
    </div>
  `
})
export class GameTableComponent {
  @Input()
  public gameColumns: Game[];

  constructor() {
  }

  protected formatTime(time: string): string {
    return moment(time).tz('America/New_York').format('h:mm a z');
  }

}
