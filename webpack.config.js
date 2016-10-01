module.exports = {
    entry: "./js/why82.jsx",
    output: {
        path: __dirname + '/dist',
        filename: "bundle.js"
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
