import React from 'react'
import ReactDOM from 'react-dom'
import App from './App'
import 'bootstrap/dist/css/bootstrap.min.css'
import registerServiceWorker from './registerServiceWorker'

const domain = process.env.REACT_APP_BACKEND_DOMAIN
ReactDOM.render(<App domain={domain} />, document.getElementById('root'))
registerServiceWorker()
