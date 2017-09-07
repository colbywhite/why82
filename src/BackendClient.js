import axios from 'axios'

class BackendClient {
  constructor(host, stage, season) {
    this.host = host
    this.stage = stage
    this.season = season
  }

  getSchedule() {
    return axios
      .get(`${this.host}/${this.stage}/${this.season}/schedule`)
      .then((r) => r.data)
  }
}

export default BackendClient
