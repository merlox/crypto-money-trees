# CryptoTrees dApp

This decentralized application allows you to purchase virtual trees. Each tree generates ETH rewards daily (every 24 hours) depending on the tree power which increases each time you water the tree. The more tree power, the bigger the reward you get.

The rewards come from the smart contract which distributes a percentage of the funds obtained daily after selling trees.

## Commands
There are 3 main commands that you'll need:
1. `npm run start`: Starts the node.js server while compiling the ES6 javascript server code. This means that the node.js code is using the latest javascript version allowing you to import more easily, that's why you need to compile it. The compiled server code is named `server.compiled.js`.
2. `npm run compile`: Compiles the react.js application using the version of webpack specified in the package.json. You don't need to worry about updating your webpack since it will always use the version in the `/node_modules`.
3. `npm run compile-watch`: Compiles and updates the webpack every time a react.js file changes.

## Files
You only need to worry about the `App.js` file which contains all the javascript code including the initial page components, the market page components and the My Trees page components. That's why it's so big, 600 lines.

To change the CSS you have to update the `index.styl` file since it contains all the CSS using the pre-processor stylus which is the same as normal CSS but with variables, lighter optional syntax and selector nesting to keep the styles organized.
