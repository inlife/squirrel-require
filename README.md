# squirrel-require
Require module for squirrel-lang

Handling multiple files via squirrel might be problem.
Even if you are using dofile/loadfile at some point you will probably find yourself experiencing some inconviniences related to global namespacing and visibility.

## Purpose

Create simple, and working alternative to Node.js realization of **CommonJS** for squirrel lang.
This library allows you to use all beauty of modular concepts that you \*might probably\* used to while writing on Node.js.

## Features

* It can load modules in **multiple ways**: filename w/o extension, filename w/ extension, directory name with index.nut file, and even via module name from squirrel_modules directory.
* It is **isolated**! (you can easily define some global functions or variables inside module, but they wont be visible to any other module).
* It comes with builtin `"path"` core library, which is kinda similar to one, used in Node.js.
* It **caches** modules and resolves *cyclic requires*, so no worries about that.
* It suppors **multiple exports** from same module, via `module.exports`

As you see most of the features, are similar to Node.js's require.

Separate modules, in lets say `squirrel_modules` dir with package.json or package.nut inside a folder named after module title.
This package.* file should contain almost same information as npm's package.json does.
You can look example for this in `examples/` folder.

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
        print("Hello " + text + "\n");
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
print( mymodule.hello("world") );
```

You can look at more examples at examples/ dir.


## License

Look [LICENSE.md](LICENSE.md)
