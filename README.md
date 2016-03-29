macmount
========

> Mount an OS X disk to the default location.

[![npm version](https://badge.fury.io/js/macmount.svg)](http://badge.fury.io/js/macmount)
[![dependencies](https://david-dm.org/resin-io-modules/macmount.svg)](https://david-dm.org/resin-io-modules/macmount.svg)
[![Build Status](https://travis-ci.org/resin-io-modules/macmount.svg?branch=master)](https://travis-ci.org/resin-io-modules/macmount)

Installation
------------

Install `macmount` by running:

```sh
$ npm install --save macmount
```

You can also install a `macmount` CLI tool with:

```sh
$ npm install --global macmount
```

Documentation
-------------

<a name="module_macmount.mount"></a>

### macmount.mount(disk, callback)
This function handles raw disk (in the form of `/dev/rdiskN`) automatically.

**Kind**: static method of <code>[macmount](#module_macmount)</code>  
**Summary**: Mount an OS X disk to the default location  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| disk | <code>String</code> | disk |
| callback | <code>function</code> | callback (error) |

**Example**  
```js
var macmount = require('macmount');

macmount.mount('/dev/disk2', function(error) {
  if (error) {
    throw error;
  }
});
```

Tests
-----

Run the test suite by doing:

```sh
$ npm test
```

Development
-----------

`macmount` wraps a native command line utility that must be built with Xcode.

If you make edits to the executable source make sure to build it afterwards with:

```sh
$ npm run build
```

The command line utility can be used directly as follows:

```sh
$ ./bin/macmount disk
```

Contribute
----------

- Issue Tracker: [github.com/resin-io-modules/macmount/issues](https://github.com/resin-io-modules/macmount/issues)
- Source Code: [github.com/resin-io-modules/macmount](https://github.com/resin-io-modules/macmount)

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io-modules/macmount/issues/new)
on GitHub and the Resin.io team will be happy to help.

License
-------

*macmount* is free software, and may be redistributed under the terms specified
in the [license](https://github.com/resin-io-modules/macmount/blob/master/LICENSE).
