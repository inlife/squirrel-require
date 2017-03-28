/**
 * Path library for sq
 * similar to node.js path lib
 * @type {Object}
 */
local path = {
    sep     = "/",
    join    = null,
    ajoin   = null,
    exists  = null,
    dirname = null,
    resolve = null,
    normalize  = null,
}

/**
 * Return path joined from elements via "/"
 * @param  {Array} elements
 * @return {String}
 */
path.ajoin = function(arr) {
    return arr.reduce(function(a, b) { return (endswith(a, path.sep)) ? a + b : a + path.sep + b; });
};

/**
 * Return path joined from elements via "/"
 * @param  {...} elements
 * @return {String}
 */
path.join = function(...) {
    return path.ajoin(vargv);
};

/**
 * Check whether or not file exists
 * @param  {String} filename
 * @return {Boolean}
 */
path.exists = function(filename) {
    try { return (file(filename, "r").close()) || true; } catch (e) { return false; }
};

/**
 * TODO fix
 * @param  {String} filename
 * @return {String}
 */
path.dirname = function(filename) {
    if (endswith(filename, "/")) {
        return filename;
    }

    local parts = split(filename, path.sep);

    if (parts.len() > 0 && parts[parts.len() - 1].find(".") != null) {
        parts.pop();
    }

    local npath = path.ajoin(parts);

    return npath;
};

/**
 * Normalize current path
 * (./a../././b/c/file.txt -> ./b/c/file.txt)
 *
 * @param  {String} filepath
 * @return {String}
 */
path.normalize = function(filepath) {
    local parts = split(filepath, path.sep);

    for (local i = 0; i < parts.len(); i++) {
        if (parts[i] == ".." && i > 0) {
            parts.remove(i - 1);
            parts.remove(i - 1);
            i = (i - 2 < 0) ? i - 1 : i - 2;
        }

        if (parts[i] == ".") {
            parts.remove(i);
            i = (i - 1 < 0) ? i : i - 1;
        }
    }

    return path.ajoin(parts);
};

/**
 * Resolve parts of paths accordingly to each other
 * @param  {...} N - paths
 * @return {String}
 */
path.resolve = function(...) {
    local args = [];

    foreach (idx, value in vargv) {
        if (startswith(value, "/")) {
            args.clear();
        }

        args.push(value);
    }

    return path.normalize(path.ajoin(args));
};



/**
 * Require library for squirrel
 * should be included via dofile, and called only once
 *
 * @param  {String}  root       root folder for require (for source code)
 * @param  {String}  module_dir module dir for require (for 3rd party modules)
 * @param  {Boolean} debug      setup debug mode
 * @return {Function}           require method
 */
return function(root = "./", module_dir = "./squirrel_modules", debug = false) {

    local require = {
        cache = {},
        resolve     = null,
        create_env  = null,
        load        = null,
        generate    = null,
        core_lib    = null,
        bind_env    = null,
    };

    /**
     * Resolve current module name to unique one
     * @param  {String} name
     * @param  {Mixed} from
     * @return {String}
     */
    require.resolve = function(name, from = null) {
        local dirname = from ? from.dirname : root;

        if (name in require.cache) {
            return name;
        }

        local places  = [
            path.resolve(dirname, name + ".nut"),
            path.resolve(dirname, name, "index.nut"),
            path.resolve(dirname, name),
            // path.resolve(module_dir, name, "package.json"),
        ];

        foreach (idx, filepath in places) {
            if (debug) {
                print(format("looking for module '%s' at: %s - %d\n", name, filepath, path.exists(filepath)));
            }

            if (path.exists(filepath)) {
                return filepath;
            }
        }

        return null;
    };

    /**
     * Register core library
     * @param  {String} name
     * @param  {Table} closure
     */
    require.core_lib = function(name, closure) {
        require.cache[name] <- {
            loaded  = true,
            exports = closure,
            dirname = "corelib",
            filename = "corelib",
            parent = null,
            children = [],
        };
    };

    /**
     * Bind native module env to main env
     * @param  {Table} env
     */
    require.bind_env = function(env) {
        local tbl = getroottable();

        foreach (idx, value in env) {
            tbl[idx] <- value;
        }
    };

    /**
     * Create environment for new required module
     * @param  {String} filepath
     * @param  {Table} module_parent
     * @return {Table}
     */
    require.create_env = function(filepath, module_parent = null) {
        local environment = {
            module = {
                loaded  = false,
                exports = {},
                dirname = path.dirname(filepath),
                filename = filepath,
                parent = module_parent,
                children = [],
            },
            __dirname = path.dirname(filepath),
            __filename = filepath,
            require = null,
            exports = null,
            console = {
                log = function(...) {
                    ::print(vargv.reduce(function(a, b) {
                        return a + " " + b;
                    }) + "\n");
                },
            },
            process = {
                stdin   = stdin,
                stderr  = stderr,
                stdout  = stdout,
                version = _version_,
            },
        };

        if (filepath == "native_require") {
            environment.module.dirname = "./";
            environment.__dirname = "./";
        }

        if (module_parent) {
            module_parent.children.push(environment.module);
        }

        environment.exports = environment.module.exports;
        environment.require = require.generate(environment.module);

        return environment;
    };

    /**
     * Try to load module or and handle loading error
     * (sytax errors mostly)
     * @param  {String} filepath
     * @param  {Table} env created environment
     */
    require.load = function(filepath, env) {
        try {
            loadfile(filepath, true).call(env);
        }
        catch (e) {
            ::print(e);
        }
    };

    /**
     * Generate require method for module
     * @param  {Mixed} module_parent
     * @return {Function}
     */
    require.generate = function(module_parent = null) {
        return function(module_path) {
            local filepath = require.resolve(module_path, module_parent)

            if (!filepath) {
                throw "require: Cannot find module: " + module_path;
            }

            if (!(filepath in require.cache)) {
                local module_env = require.create_env(filepath, module_parent);
                require.cache[filepath] <- module_env.module;

                require.load(filepath, module_env);
                module_env.module.loaded = true;
            }

            local module = require.cache[filepath];

            return module.exports;
        }
    };

    /**
     * Registering native core libs
     */
    require.core_lib("path", path);

    /**
     * Registering native env for main lib
     */
    require.bind_env(require.create_env("native_require", null));

    /**
     * Exporting single public method
     * that starts require
     */
    return require.generate(null);
};
