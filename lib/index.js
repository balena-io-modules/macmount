/*
 * Copyright 2016 Resin.io
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

var child_process = require('child_process');
var path = require('path');
var utils = require('./utils');

/**
 * @module macmount
 */

var MACMOUNT_PATH = path.join(__dirname, '..', 'bin', 'macmount');

/**
 * @summary Mount an OS X disk to the default location
 * @function
 * @public
 *
 * @description
 * This function handles raw disk (in the form of `/dev/rdiskN`) automatically.
 *
 * @param {String} disk - disk
 * @param {Function} callback - callback (error)
 *
 * @example
 * var macmount = require('macmount');
 *
 * macmount.mount('/dev/disk2', function(error) {
 *   if (error) {
 *     throw error;
 *   }
 * });
 */
exports.mount = function(disk, callback) {
  child_process.execFile(MACMOUNT_PATH, [
    utils.getDeviceBSDName(disk)
  ], function(error, stdout, stderr) {
    if (error) {
      return callback(error);
    }

    if (stderr && stderr.trim().length > 0) {
      return callback(new Error('Macmount: ' + stderr));
    }

    return callback(null);
  });
};
