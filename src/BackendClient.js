import axios from 'axios'

class BackendClient {
  constructor(host) {
    this.host = host
  }

  getSchedule() {
    return axios
      .get(`${this.host}/prod/2017/schedule`)
      .then((r) => r.data)
  }
}

export default BackendClient
