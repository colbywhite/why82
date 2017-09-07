import React from 'react'
import ReactDOM from 'react-dom'
import App from './App'
import 'bootstrap/dist/css/bootstrap.min.css'
import registerServiceWorker from './registerServiceWorker'

const domain = process.env.REACT_APP_BACKEND_DOMAIN
const season = process.env.REACT_APP_SEASON
const stage = process.env.REACT_APP_STAGE || 'dev'
ReactDOM.render(
  <App domain={domain} stage={stage} season={season}/>,
  document.getElementById('root')
)
registerServiceWorker()
