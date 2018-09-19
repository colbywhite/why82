import { Component, Input } from '@angular/core';
import { Game } from '../game.model';

@Component({
  selector: 'app-game-table',
  styles: [
    'table {width: inherit}',
    'mat-header-cell, mat-cell {justify-content: center}'
  ],
  template: `
    <mat-table [dataSource]="games">

      <ng-container matColumnDef="time">
        <mat-header-cell *matHeaderCellDef><div>Time</div></mat-header-cell>
        <mat-cell *matCellDef="let g"> {{g.time | amDateFormat:'h:mm az'}}</mat-cell>
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
  `
})
export class GameTableComponent {
  public displayedColumns = ['time', 'away', 'home'];

  @Input()
  public games: Game[];

  constructor() {
  }

}
