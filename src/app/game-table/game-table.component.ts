import { Component, Input } from '@angular/core';
import * as moment from 'moment-timezone';

import { Game } from '../game.model';
import { TEAM_COMPONENT_HEIGHT_PX, TEAM_COMPONENT_MARGIN_PX } from '../team/team.component';

const HEADER_HEIGHT_PX = 56;
const BORDER_HEIGHT_PX = 1;

@Component({
  selector: 'app-game-table',
  styles: [
    'mat-table {width: 100%;}',
    'mat-header-cell, mat-cell {justify-content: center}',
    ':host ::ng-deep figure.mat-figure {align-items: stretch;}'
  ],
  template: `
    <mat-grid-list
      *ngIf="gameColumns?.length > 0"
      [cols]="gameColumns.length"
      [rowHeight]="calcLargestColumnHeight(gameColumns)">
      <mat-grid-tile *ngFor="let column of gameColumns">
        <mat-table [dataSource]="column">

          <ng-container matColumnDef="time">
            <mat-header-cell *matHeaderCellDef>
              <div>Time</div>
            </mat-header-cell>
            <mat-cell *matCellDef="let g"> {{formatTime(g.time)}}</mat-cell>
          </ng-container>

          <ng-container matColumnDef="away">
            <mat-header-cell *matHeaderCellDef>Away</mat-header-cell>
            <mat-cell *matCellDef="let g">
              <app-team [team]="g.away"></app-team>
            </mat-cell>
          </ng-container>

          <ng-container matColumnDef="home">
            <mat-header-cell *matHeaderCellDef>Home</mat-header-cell>
            <mat-cell *matCellDef="let g">
              <app-team [team]="g.home"></app-team>
            </mat-cell>
          </ng-container>

          <mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
          <mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
        </mat-table>
      </mat-grid-tile>
    </mat-grid-list>
  `
})
export class GameTableComponent {
  public displayedColumns = ['time', 'away', 'home'];

  @Input()
  public gameColumns: Game[][];

  constructor() {
  }

  public calcLargestColumnHeight = (gameColumns: Game[][]): string => {
    const lengths: number[] = gameColumns.map((column: Game[]) => column.length);
    const largestLength: number = Math.max(...lengths);
    const headerRowHeight: number = HEADER_HEIGHT_PX + BORDER_HEIGHT_PX;
    const teamRowMargin: number = 2 * TEAM_COMPONENT_MARGIN_PX;
    const teamRowHeight: number = TEAM_COMPONENT_HEIGHT_PX + teamRowMargin + BORDER_HEIGHT_PX;
    const tableHeight: number = headerRowHeight + (largestLength * teamRowHeight);
    return `${tableHeight}px`;
  }

  protected formatTime(time: string): string {
    return moment(time).tz('America/New_York').format('h:mm a z');
  }

}
