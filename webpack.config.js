module.exports = {
    entry: {
      schedule: "./js/schedule.jsx",
      tiers: './js/tiers.jsx'
    },
    output: {
        path: __dirname + '/dist',
        filename: "[name].js"
    },
    module: {
        loaders: [
            {
              test: /\.js(x)?$/,
              loader: 'babel'
            }
        ]
    }
};
