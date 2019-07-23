//@ts-check

'use strict';

const path = require('path');

/**@type {import('webpack').Configuration}*/
const config = {
  target: 'node',

  entry: './src/edit-in-new-tab.coffee',
  output: {
    path: path.resolve(__dirname, 'lib'),
    filename: 'edit-in-new-tab.js',
    libraryTarget: 'commonjs2',
    devtoolModuleFilenameTemplate: '../[resource-path]'
  },
  devtool: 'source-map',
  externals: {
    atom: 'atom',
    electron: 'electron'
  },
  resolve: {
    extensions: ['.coffee', '.js']
  },
  module: {
    rules: [
      {
        test: /\.coffee$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'coffee-loader'
          }
        ]
      }
    ]
  }
};
module.exports = config;
