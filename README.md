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

## Documentation

As soon as you attach squirrel-require to your project, your file global namespace becomes populated with several tables/methods:

* `__dirname` - relative directory of the current file (calculated is based on option of the attaching: dofile(...)("THIS_ARGUMENT"))
* `__filename` - relative filepath of the current file, (calculated same way as above)
* `require` - method for including modules
* `globals` - table contaning all current global members (can be defined inside submodule, and be available at the top)
* `console` - table
* * `log` - method for logging various data of plain types
* `module` - table (current module)
* * `loaded` - boolean representing whether or not this module've been loaded
* * `exports` - table of exporting values, any given to export data should be put there
* * `parent` - reference to the parent module (the one who required this module first)
* * `children` - array of child modules (required by this module)
* * `dirname` - alias of `__dirname`
* * `filename` - alias of `__filename`
* `process` - table
* * `stdin` - stdin stream (alias of the default global `stdin`)
* * `stdout` - stdout stream (alias of the default global `stdout`)
* * `stderr` - stderr stream (alias of the default global `stderr`)
* * `version` - version string (alias of the default global `_version_`)

All these tables/methods will be automatically inserted(binded) into child modules on their require time.

## License

Look [LICENSE.md](LICENSE.md)
