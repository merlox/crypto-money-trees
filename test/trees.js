const Trees = artifacts.require('./Trees.sol')
let trees

contract('Trees', accounts => {
	console.log('Started')
	before(async () => {
		trees = await Trees.deployed()
	})
	it('Should show the contract address deployed on the ropsten', async () => {
		console.log(trees.address)
	})
	// No need to try catch since it will fail if there's a catch
	it('should generate 5 trees by the owner', async () => {
		const treesGenerated = await trees.generateTrees(5)
	})
	it('should only allow the execution of the functions generateTrees, emergencyExtract, addAdmin, removeAdmin by the owner only')
	it('should be able to buy a tree for the specified price of 1 ETH')
	it('should be able to sell a tree for any price')
	it('should give 50% of the first generation trees to the CEO')
	it('should give 50% of the first generation trees to the treasury')
	it('should give 10% of the second hand tress to the treasury')
	it('should increase the tree power by watering it by the owner of it')
	it('should only allow the water of trees once per day')
	it('should generate a daily reward for all the trees of the total 10% of the treasury')
	it('should be able to extract the balance of the contract to the owner in an emergency with emergencyExtract')
})
