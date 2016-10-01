module.exports = {
    entry: "./js/why82.js",
    output: {
        path: __dirname + '/dist',
        filename: "bundle.js"
    },
    module: {
        loaders: [
            { test: /\.css$/, loader: "style!css" },
            {
              test: /\.js$/,
              exclude: /node_modules/,
              loader: 'babel',
              query: { presets: ['es2015'] }
            }
        ]
    }
};
