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

// TODO replace with games from the backend
export const default_games: Game[] = [
  {
    home: {
      metrics: {
        win_loss: {
          score: 3,
          WinPct: 0.58,
          Wins: 47,
          Losses: 34
        },
        offense: {
          score: 8,
          PtsPerGame: 111.6
        },
        pt_diff: {
          score: 1,
          PtsPerGame: 111.6,
          PtsAgainstPerGame: 110.6,
          PtsDiffPerGame: 1
        },
        last_season: {
          score: 0
        }
      },
      score: 12,
      abbreviated_name: 'NOP',
      short_name: 'Pelicans',
      full_name: 'New Orleans Pelicans'
    },
    away: {
      metrics: {
        win_loss: {
          score: 3,
          WinPct: 0.58,
          Wins: 47,
          Losses: 34
        },
        offense: {
          score: 1,
          PtsPerGame: 102.8
        },
        pt_diff: {
          score: 2,
          PtsPerGame: 102.8,
          PtsAgainstPerGame: 99.6,
          PtsDiffPerGame: 3.200000000000003
        },
        last_season: {
          score: 0
        }
      },
      score: 6,
      abbreviated_name: 'SAS',
      short_name: 'Spurs',
      full_name: 'San Antonio Spurs'
    },
    time: '2018-04-11T20:00:00-04:00',
    score: 'B'
  },
  {
    home: {
      metrics: {
        win_loss: {
          score: 3,
          WinPct: 0.63,
          Wins: 51,
          Losses: 30
        },
        offense: {
          score: 5,
          PtsPerGame: 109.6
        },
        pt_diff: {
          score: 3,
          PtsPerGame: 109.6,
          PtsAgainstPerGame: 105.4,
          PtsDiffPerGame: 4.199999999999989
        },
        last_season: {
          score: 0
        }
      },
      score: 11,
      abbreviated_name: 'PHI',
      short_name: '76ers',
      full_name: 'Philadelphia 76ers'
    },
    away: {
      metrics: {
        win_loss: {
          score: 2,
          WinPct: 0.543,
          Wins: 44,
          Losses: 37
        },
        offense: {
          score: 3,
          PtsPerGame: 106.6
        },
        pt_diff: {
          score: 1,
          PtsPerGame: 106.6,
          PtsAgainstPerGame: 106.5,
          PtsDiffPerGame: 0.09999999999999432
        },
        last_season: {
          score: 0
        }
      },
      score: 6,
      abbreviated_name: 'MIL',
      short_name: 'Bucks',
      full_name: 'Milwaukee Bucks'
    },
    time: '2018-04-11T20:00:00-04:00',
    score: 'B'
  },
  {
    home: {
      metrics: {
        win_loss: {
          score: 2,
          WinPct: 0.531,
          Wins: 43,
          Losses: 38
        },
        offense: {
          score: 1,
          PtsPerGame: 103.3
        },
        pt_diff: {
          score: 1,
          PtsPerGame: 103.3,
          PtsAgainstPerGame: 102.9,
          PtsDiffPerGame: 0.3999999999999915
        },
        last_season: {
          score: 0
        }
      },
      score: 4,
      abbreviated_name: 'MIA',
      short_name: 'Heat',
      full_name: 'Miami Heat'
    },
    away: {
      metrics: {
        win_loss: {
          score: 5,
          WinPct: 0.728,
          Wins: 59,
          Losses: 22
        },
        offense: {
          score: 8,
          PtsPerGame: 111.7
        },
        pt_diff: {
          score: 8,
          PtsPerGame: 111.7,
          PtsAgainstPerGame: 103.7,
          PtsDiffPerGame: 8
        },
        last_season: {
          score: 0
        }
      },
      score: 21,
      abbreviated_name: 'TOR',
      short_name: 'Raptors',
      full_name: 'Toronto Raptors'
    },
    time: '2018-04-11T20:00:00-04:00',
    score: 'D'
  },
  {
    home: {
      metrics: {
        win_loss: {
          score: 0,
          WinPct: 0.296,
          Wins: 24,
          Losses: 57
        },
        offense: {
          score: 1,
          PtsPerGame: 103.4
        },
        pt_diff: {
          score: -2,
          PtsPerGame: 103.4,
          PtsAgainstPerGame: 108.4,
          PtsDiffPerGame: -5
        },
        last_season: {
          score: 0
        }
      },
      score: -1,
      abbreviated_name: 'ORL',
      short_name: 'Magic',
      full_name: 'Orlando Magic'
    },
    away: {
      metrics: {
        win_loss: {
          score: 2,
          WinPct: 0.531,
          Wins: 43,
          Losses: 38
        },
        offense: {
          score: 3,
          PtsPerGame: 106.8
        },
        pt_diff: {
          score: 1,
          PtsPerGame: 106.8,
          PtsAgainstPerGame: 106.1,
          PtsDiffPerGame: 0.7000000000000028
        },
        last_season: {
          score: 0
        }
      },
      score: 6,
      abbreviated_name: 'WAS',
      short_name: 'Wizards',
      full_name: 'Washington Wizards'
    },
    time: '2018-04-11T20:00:00-04:00',
    score: 'D'
  },
  {
    home: {
      metrics: {
        win_loss: {
          score: 0,
          WinPct: 0.333,
          Wins: 27,
          Losses: 54
        },
        offense: {
          score: 1,
          PtsPerGame: 103.1
        },
        pt_diff: {
          score: -3,
          PtsPerGame: 103.1,
          PtsAgainstPerGame: 109.9,
          PtsDiffPerGame: -6.800000000000011
        },
        last_season: {
          score: 0
        }
      },
      score: -2,
      abbreviated_name: 'CHI',
      short_name: 'Bulls',
      full_name: 'Chicago Bulls'
    },
    away: {
      metrics: {
        win_loss: {
          score: 2,
          WinPct: 0.469,
          Wins: 38,
          Losses: 43
        },
        offense: {
          score: 1,
          PtsPerGame: 103.6
        },
        pt_diff: {
          score: 0,
          PtsPerGame: 103.6,
          PtsAgainstPerGame: 104.1,
          PtsDiffPerGame: -0.5
        },
        last_season: {
          score: 0
        }
      },
      score: 3,
      abbreviated_name: 'DET',
      short_name: 'Pistons',
      full_name: 'Detroit Pistons'
    },
    time: '2018-04-11T20:00:00-04:00',
    score: 'D'
  },
  {
    home: {
      metrics: {
        win_loss: {
          score: 3,
          WinPct: 0.58,
          Wins: 47,
          Losses: 34
        },
        offense: {
          score: 3,
          PtsPerGame: 107.5
        },
        pt_diff: {
          score: 2,
          PtsPerGame: 107.5,
          PtsAgainstPerGame: 104.2,
          PtsDiffPerGame: 3.299999999999997
        },
        last_season: {
          score: 0
        }
      },
      score: 8,
      abbreviated_name: 'OKL',
      short_name: 'Thunder',
      full_name: 'Oklahoma City Thunder'
    },
    away: {
      metrics: {
        win_loss: {
          score: 0,
          WinPct: 0.272,
          Wins: 22,
          Losses: 59
        },
        offense: {
          score: -1,
          PtsPerGame: 99
        },
        pt_diff: {
          score: -3,
          PtsPerGame: 99,
          PtsAgainstPerGame: 105.1,
          PtsDiffPerGame: -6.099999999999994
        },
        last_season: {
          score: 0
        }
      },
      score: -4,
      abbreviated_name: 'MEM',
      short_name: 'Grizzlies',
      full_name: 'Memphis Grizzlies'
    },
    time: '2018-04-11T20:00:00-04:00',
    score: 'D'
  },
  {
    home: {
      metrics: {
        win_loss: {
          score: 5,
          WinPct: 0.667,
          Wins: 54,
          Losses: 27
        },
        offense: {
          score: 1,
          PtsPerGame: 103.9
        },
        pt_diff: {
          score: 2,
          PtsPerGame: 103.9,
          PtsAgainstPerGame: 100.5,
          PtsDiffPerGame: 3.4000000000000057
        },
        last_season: {
          score: 0
        }
      },
      score: 8,
      abbreviated_name: 'BOS',
      short_name: 'Celtics',
      full_name: 'Boston Celtics'
    },
    away: {
      metrics: {
        win_loss: {
          score: 0,
          WinPct: 0.346,
          Wins: 28,
          Losses: 53
        },
        offense: {
          score: 3,
          PtsPerGame: 106.7
        },
        pt_diff: {
          score: -1,
          PtsPerGame: 106.7,
          PtsAgainstPerGame: 110.3,
          PtsDiffPerGame: -3.5999999999999943
        },
        last_season: {
          score: 0
        }
      },
      score: 2,
      abbreviated_name: 'BRO',
      short_name: 'Nets',
      full_name: 'Brooklyn Nets'
    },
    time: '2018-04-11T20:00:00-04:00',
    score: 'D'
  },
  {
    home: {
      metrics: {
        win_loss: {
          score: 3,
          WinPct: 0.568,
          Wins: 46,
          Losses: 35
        },
        offense: {
          score: 5,
          PtsPerGame: 109.5
        },
        pt_diff: {
          score: 2,
          PtsPerGame: 109.5,
          PtsAgainstPerGame: 107.3,
          PtsDiffPerGame: 2.200000000000003
        },
        last_season: {
          score: 0
        }
      },
      score: 10,
      abbreviated_name: 'MIN',
      short_name: 'Timberwolves',
      full_name: 'Minnesota Timberwolves'
    },
    away: {
      metrics: {
        win_loss: {
          score: 3,
          WinPct: 0.568,
          Wins: 46,
          Losses: 35
        },
        offense: {
          score: 8,
          PtsPerGame: 110
        },
        pt_diff: {
          score: 1,
          PtsPerGame: 110,
          PtsAgainstPerGame: 108.5,
          PtsDiffPerGame: 1.5
        },
        last_season: {
          score: 0
        }
      },
      score: 12,
      abbreviated_name: 'DEN',
      short_name: 'Nuggets',
      full_name: 'Denver Nuggets'
    },
    time: '2018-04-11T20:00:00-04:00',
    score: 'B'
  },
  {
    home: {
      metrics: {
        win_loss: {
          score: 3,
          WinPct: 0.617,
          Wins: 50,
          Losses: 31
        },
        offense: {
          score: 8,
          PtsPerGame: 111
        },
        pt_diff: {
          score: 1,
          PtsPerGame: 111,
          PtsAgainstPerGame: 109.9,
          PtsDiffPerGame: 1.0999999999999943
        },
        last_season: {
          score: 0
        }
      },
      score: 12,
      abbreviated_name: 'CLE',
      short_name: 'Cavaliers',
      full_name: 'Cleveland Cavaliers'
    },
    away: {
      metrics: {
        win_loss: {
          score: 0,
          WinPct: 0.346,
          Wins: 28,
          Losses: 53
        },
        offense: {
          score: 2,
          PtsPerGame: 104.4
        },
        pt_diff: {
          score: -1,
          PtsPerGame: 104.4,
          PtsAgainstPerGame: 108.1,
          PtsDiffPerGame: -3.6999999999999886
        },
        last_season: {
          score: 0
        }
      },
      score: 1,
      abbreviated_name: 'NYK',
      short_name: 'Knicks',
      full_name: 'New York Knicks'
    },
    time: '2018-04-11T20:00:00-04:00',
    score: 'D'
  },
  {
    home: {
      metrics: {
        win_loss: {
          score: 2,
          WinPct: 0.519,
          Wins: 42,
          Losses: 39
        },
        offense: {
          score: 5,
          PtsPerGame: 109.1
        },
        pt_diff: {
          score: 1,
          PtsPerGame: 109.1,
          PtsAgainstPerGame: 108.9,
          PtsDiffPerGame: 0.19999999999998863
        },
        last_season: {
          score: 0
        }
      },
      score: 8,
      abbreviated_name: 'LAC',
      short_name: 'Clippers',
      full_name: 'Los Angeles Clippers'
    },
    away: {
      metrics: {
        win_loss: {
          score: 1,
          WinPct: 0.42,
          Wins: 34,
          Losses: 47
        },
        offense: {
          score: 5,
          PtsPerGame: 108
        },
        pt_diff: {
          score: 0,
          PtsPerGame: 108,
          PtsAgainstPerGame: 109.7,
          PtsDiffPerGame: -1.7000000000000028
        },
        last_season: {
          score: 0
        }
      },
      score: 6,
      abbreviated_name: 'LAL',
      short_name: 'Lakers',
      full_name: 'Los Angeles Lakers'
    },
    time: '2018-04-11T22:30:00-04:00',
    score: 'C'
  },
  {
    home: {
      metrics: {
        win_loss: {
          score: 0,
          WinPct: 0.321,
          Wins: 26,
          Losses: 55
        },
        offense: {
          score: -1,
          PtsPerGame: 98.9
        },
        pt_diff: {
          score: -3,
          PtsPerGame: 98.9,
          PtsAgainstPerGame: 106.1,
          PtsDiffPerGame: -7.199999999999989
        },
        last_season: {
          score: 0
        }
      },
      score: -4,
      abbreviated_name: 'SAC',
      short_name: 'Kings',
      full_name: 'Sacramento Kings'
    },
    away: {
      metrics: {
        win_loss: {
          score: 8,
          WinPct: 0.802,
          Wins: 65,
          Losses: 16
        },
        offense: {
          score: 13,
          PtsPerGame: 112.7
        },
        pt_diff: {
          score: 8,
          PtsPerGame: 112.7,
          PtsAgainstPerGame: 104,
          PtsDiffPerGame: 8.700000000000003
        },
        last_season: {
          score: 0
        }
      },
      score: 29,
      abbreviated_name: 'HOU',
      short_name: 'Rockets',
      full_name: 'Houston Rockets'
    },
    time: '2018-04-11T22:30:00-04:00',
    score: 'D'
  },
  {
    home: {
      metrics: {
        win_loss: {
          score: 3,
          WinPct: 0.593,
          Wins: 48,
          Losses: 33
        },
        offense: {
          score: 2,
          PtsPerGame: 105.7
        },
        pt_diff: {
          score: 2,
          PtsPerGame: 105.7,
          PtsAgainstPerGame: 103.1,
          PtsDiffPerGame: 2.6000000000000085
        },
        last_season: {
          score: 0
        }
      },
      score: 7,
      abbreviated_name: 'POR',
      short_name: 'Trail Blazers',
      full_name: 'Portland Trail Blazers'
    },
    away: {
      metrics: {
        win_loss: {
          score: 3,
          WinPct: 0.593,
          Wins: 48,
          Losses: 33
        },
        offense: {
          score: 2,
          PtsPerGame: 104.3
        },
        pt_diff: {
          score: 3,
          PtsPerGame: 104.3,
          PtsAgainstPerGame: 99.8,
          PtsDiffPerGame: 4.5
        },
        last_season: {
          score: 0
        }
      },
      score: 8,
      abbreviated_name: 'UTA',
      short_name: 'Jazz',
      full_name: 'Utah Jazz'
    },
    time: '2018-04-11T22:30:00-04:00',
    score: 'C'
  }
];
