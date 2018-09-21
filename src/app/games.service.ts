import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import { Schedule } from './game.model';
import { Constants } from './constants';

@Injectable({
  providedIn: 'root'
})
export class GamesService {
  constructor(private http: HttpClient) {
  }

  public get schedule(): Observable<Schedule> {
    return this.http.get<Schedule>(this.scheduleUrl);
  }

  private get scheduleUrl(): string {
    return `${Constants.API_HOST}/${Constants.API_STAGE}/${Constants.SEASON}/schedule`;
  }
}
