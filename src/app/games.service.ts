import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import { Schedule } from './game.model';

@Injectable({
  providedIn: 'root'
})
export class GamesService {

  constructor(private http: HttpClient) {
  }

  public get host(): string {
    return 'https://si8dtzx75f.execute-api.us-east-1.amazonaws.com';
  }

  public get stage(): string {
    return 'prod';
  }

  public get season(): string {
    return '2018';
  }

  public get schedule(): Observable<Schedule> {
    return this.http.get<Schedule>(`${this.host}/${this.stage}/${this.season}/schedule`);
  }
}
