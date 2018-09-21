export interface Team {
  abbreviated_name: string;
  full_name: string;
  short_name: string;
  score: number;
  metrics?: any;
}

export interface Game {
  home: Team;
  away: Team;
  time: string;
  score: string;
}

export interface Schedule {
  [key: string]: Game[];
}
