import { Component, Input, OnInit } from '@angular/core';
import { Game } from '../game.model';
import { TEAM_COMPONENT_HEIGHT_PX, TEAM_COMPONENT_MARGIN_PX } from '../team/team.component';

@Component({
  selector: 'app-game-table',
  styles: [
    'table {width: inherit}',
    'mat-header-cell, mat-cell {justify-content: center}',
    ':host ::ng-deep figure.mat-figure {align-items: stretch;}'
  ],
  template: `
    <mat-grid-list cols="2" [rowHeight]="largestTableHeight(splitGames)">
      <mat-grid-tile *ngFor="let column of splitGames">
        <mat-table [dataSource]="column">

          <ng-container matColumnDef="time">
            <mat-header-cell *matHeaderCellDef>
              <div>Time</div>
            </mat-header-cell>
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
      </mat-grid-tile>
    </mat-grid-list>
  `
})
export class GameTableComponent implements OnInit {
  public displayedColumns = ['time', 'away', 'home'];
  private HEADER_HEIGHT_PX = 56;
  private BORDER_HEIGHT_PX = 1;

  @Input()
  public games: Game[];

  protected splitGames: Game[][];

  constructor() {
  }

  public ngOnInit(): void {
    const evenGames = this.games.filter((val: Game, index: number) => index % 2 === 0);
    const oddGames = this.games.filter((val: Game, index: number) => index % 2 === 1);
    this.splitGames = [evenGames, oddGames];
  }

  public largestTableHeight(gameColumns: Game[][]): string {
    const lengths: number[] = gameColumns.map((column: Game[]) => column.length);
    const largestLength: number = Math.max(...lengths);
    const headerRowHeight: number = this.HEADER_HEIGHT_PX + this.BORDER_HEIGHT_PX;
    const teamRowMargin: number = 2 * TEAM_COMPONENT_MARGIN_PX;
    const teamRowHeight: number = TEAM_COMPONENT_HEIGHT_PX + teamRowMargin + this.BORDER_HEIGHT_PX;
    const tableHeight: number = headerRowHeight + (largestLength * teamRowHeight);
    return `${tableHeight}px`
  }

}
