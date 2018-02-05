const Trees = artifacts.require('./Trees.sol')

module.exports = async function (deployer) {
  	await deployer.deploy([
    	[Trees],
  	])
}
