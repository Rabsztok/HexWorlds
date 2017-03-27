var path = require("path");
var webpack = require("webpack");
var precss = require("precss");
var autoprefixer = require("autoprefixer");
var HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = {
  entry: [
    "react-hot-loader/patch",
    "babel-polyfill",
    "whatwg-fetch",
    "webpack-dev-server/client?http://localhost:3000",
    "webpack/hot/only-dev-server",
    "./src/index"
  ],
  output: {
    path: path.join(__dirname, "dist"),
    publicPath: "/",
    filename: "app.[hash].js"
  },
  devtool: "eval",
  module: {
    rules: [
      { test: /\.jsx?$/, exclude: /node_modules/, use: [ "babel-loader" ], },
      { test: /\.scss|css$/,
        use: [
          'style-loader',
          'css-loader',
          'postcss-loader',
          'resolve-url-loader',
          {
            loader: 'sass-loader',
            query: {
              sourceMap: true,
              includePaths: [ path.resolve(__dirname, "./node_modules") ]
            }
          }
        ]
      },
      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        use: [
          {
            loader: "file-loader",
            query: { hash: "sha512", digest: "hex", name: "assets/[hash].[ext]" }
          },
          {
            loader: "image-webpack-loader",
            query: {
              bypassOnDebug: true,
              mozjpeg: { progressive: true, },
              gifsicle: { interlaced: false, },
              optipng: { optimizationLevel: 4, },
              pngquant: { quality: '75-90', speed: 3, },
            }
          },
        ],
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: [{
          loader: "url-loader",
          query: {
            limit: 10000,
            mimetype: 'application/font-woff'
          }
        }]
      },
      { test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "file-loader" },
    ]
  },
  plugins: [
    new webpack.NamedModulesPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new HtmlWebpackPlugin({ hash: false, template: "./index.hbs" }),
  ],
  
  resolve: {
    modules: [ path.resolve('./src'), 'node_modules' ]
  }
};
