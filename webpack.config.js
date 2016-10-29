require('dotenv-safe').load();
var webpack = require('webpack');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var ExtractTextPlugin = require("extract-text-webpack-plugin");

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
              loader: ExtractTextPlugin.extract("style-loader", "css-loader")
            }, {
              test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
              loader: "file"
            }, {
              test: /\.json$/,
              loader: "file"
            }, {
              test: /\.(woff|woff2)$/,
              loader:"url?prefix=font/&limit=5000"
            }, {
              test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
              loader: "url?limit=10000&mimetype=application/octet-stream"
            }, {
              test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
              loader: "url?limit=10000&mimetype=image/svg+xml"
            }, {
              test: /\.jade$/,
              loader: "jade",
              query: {pretty: false, globals:'test'}
            }
        ]
    },
    plugins: [
      new HtmlWebpackPlugin({
        chunks: ['schedule'],
        template: 'schedule.jade',
        filename: 'index.html'
      }),
      new HtmlWebpackPlugin({
        chunks: ['tiers'],
        template: 'tiers.jade',
        filename: 'tiers.html'
      }),
      new ExtractTextPlugin("[name].css"),
      new webpack.DefinePlugin({
        'process.env': {
          'BUCKET_URL': JSON.stringify(process.env.BUCKET_URL),
          'SEASON': JSON.stringify(process.env.SEASON)
        }
      })
    ]
};
