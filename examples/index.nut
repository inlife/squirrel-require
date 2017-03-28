// run this file with:
// $ sq examples/index.nut
// $ sq.exe examples/index.nut

/**
 * You can change root folder for the modules setting up first argument in call
 * In this case we will set our root folder as ./examples
 * (without providing value it defaults to "./")
 */
local require = dofile("./src/require.nut")("./examples");

// we can load file under different name
local adder = require("./add");
local other = require("./other");

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
