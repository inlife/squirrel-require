// run this file with:
// $ sq examples/index.nut
// $ sq.exe examples/index.nut

/**
 * You can change root folder for the modules setting up first argument in call
 * In this case we will set our root folder as ./examples
 * (without providing value it defaults to "./")
 *
 * Also you can set up squirrel_modules directory (or whatever name you can choose)
 * this folder should be used same way node_modules are used
 */
local require = dofile("./src/require.nut")("./examples", "./examples/squirrel_modules");

// we can load file under different name
local adder = require("./add");
local other = require("./other");
local sqfoo = require("sqfoo");

// // oh, also we have console.log now, yay
console.log("the result of add:", adder(5, 10));

// // and submodules
console.log(other.foo());
console.log(other.bar());

/**
 * Some special global vairables accessible in each file
 */
console.log(__filename);
console.log(__dirname);
// console.log(process.);

console.log("result:", sqfoo.foo);
