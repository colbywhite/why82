import { Component, Input, OnInit } from '@angular/core';
import { Game } from '../game.model';
import { TEAM_COMPONENT_HEIGHT_PX, TEAM_COMPONENT_MARGIN_PX } from '../team/team.component';
import { MediaChange, ObservableMedia } from '@angular/flex-layout';
import { map, startWith } from 'rxjs/operators';
import { Observable } from 'rxjs/index';

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
    <mat-grid-list [cols]="(splitGames | async).length" [rowHeight]="largestColumnHeight | async">
      <mat-grid-tile *ngFor="let column of (splitGames | async)">
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
  private grid = new Map([
    ['xs', 1],
    ['sm', 2],
    ['md', 2],
    ['lg', 2],
    ['xl', 2]
  ]);

  @Input()
  public games: Game[];

  protected splitGames: Observable<Game[][]>;
  protected largestColumnHeight: Observable<string>;

  constructor(private mediaSvc: ObservableMedia) {
  }

  public ngOnInit(): void {
    this.splitGames = this.mediaSvc.asObservable()
      .pipe(
        map(this.getColumns),
        map(this.splitIntoColumns.bind(undefined, this.games))
      );
    this.largestColumnHeight = this.splitGames.pipe(map(this.calcLargestColumnHeight));
  }

  public getColumns = (change: MediaChange): number => this.grid.get(change.mqAlias);

  public splitIntoColumns = (allGames: Game[], numColumns: number): Game[][] => {
    if (numColumns <= 1) {
      return [allGames];
    } else {
      const evenGames = allGames.filter((val: Game, index: number) => index % 2 === 0);
      const oddGames = allGames.filter((val: Game, index: number) => index % 2 === 1);
      return [evenGames, oddGames];
    }
  };

  public calcLargestColumnHeight = (gameColumns: Game[][]): string => {
    const lengths: number[] = gameColumns.map((column: Game[]) => column.length);
    const largestLength: number = Math.max(...lengths);
    const headerRowHeight: number = HEADER_HEIGHT_PX + BORDER_HEIGHT_PX;
    const teamRowMargin: number = 2 * TEAM_COMPONENT_MARGIN_PX;
    const teamRowHeight: number = TEAM_COMPONENT_HEIGHT_PX + teamRowMargin + BORDER_HEIGHT_PX;
    const tableHeight: number = headerRowHeight + (largestLength * teamRowHeight);
    return `${tableHeight}px`
  };

}
