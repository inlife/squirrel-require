# squirrel-require
Require module for squirrel-lang

Handling multiple files via squirrel might be problem.
Even if you are using dofile/loadfile at some point you will probably find yourself experiencing some inconviniences related to global namespacing and visibility.

## Purpose

Create simple, and working alternative to Node.js realization of CommonJS for squirrel lang.
This library allows you to use all beatuty of modular concepts that you \*might probably\* used to while writing on Node.js.

## Installation

1. Download or clone repository. Or just copy file src/require.nut, its up to you.
2. Load that file at the beginning of your main squirrel script:

```js
local require = dofile("./squirrel-require/src/require.nut", true)();
```

3. Use it!

```js
// mymodule.nut

module.exports = {
    hello = function(text) {
        print("Hello" + text + "\n");
    },
};

```

```js
// main.nut

// load require js
local require = dofile("./squirrel-require/src/require.nut", true)();

// load modules
local mymodule = require("./mymodule");

// do stuff
print( mymodule.hello() );
```

## Usage



## License

Look [LICENSE.md]()
