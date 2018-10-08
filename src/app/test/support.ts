import { Team } from '../game.model';

export const randomTeam = (): Team => {
  return {
    abbreviated_name: 'SAS',
    full_name: 'blah',
    short_name: 'blah',
    score: 0,
    metrics: {
      last_season: {score: 8},
      offense: {score: 0, PtsPerGame: 0},
      pt_diff: {score: 0, PtsPerGame: 0, PtsAgainstPerGame: 0, PtsDiffPerGame: 0},
      win_loss: {score: 0, WinPct: 0, Wins: 0, Losses: 0}
    }
  } as Team;
};
