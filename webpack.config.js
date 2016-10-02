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
            }, {
              test: /\.css$/,
              loader: 'style-loader!css-loader'
            }, {
              test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
              loader: "file"
            }, {
              test: /\.(woff|woff2)$/,
              loader:"url?prefix=font/&limit=5000"
            }, {
              test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
              loader: "url?limit=10000&mimetype=application/octet-stream"
            }, {
              test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
              loader: "url?limit=10000&mimetype=image/svg+xml" }
        ]
    }
};
