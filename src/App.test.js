import React from 'react'
import ReactDOM from 'react-dom'
import App from './App'
import sinon from 'sinon'
import axios from 'axios'
import schedule from './resources/2017.schedule.json'

describe('App', () => {
  beforeEach(() => {
    const response = {data: schedule}
    sinon.stub(axios, 'get').returns(Promise.resolve(JSON.stringify(response)))
  })

  afterEach(() => {
    axios.get.restore()
  })

  it('renders without crashing', () => {
    const div = document.createElement('div');
    ReactDOM.render(<App domain="localhost" />, div);
  })
})
