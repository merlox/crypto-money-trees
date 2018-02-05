const HdProvider = require('truffle-hdwallet-provider')
const mnemonic = 'stamp arch collect second comic carbon custom snake kit between reject category'

module.exports = {
	networks: {
		development: {
			host: '127.0.0.1',
			network_id: '*',
			port: 8545
		},
		ropsten: {
			provider: function () {
				return new HdProvider(mnemonic, 'https://ropsten.infura.io/6GO3REaLghR6wPhNJQcc', 0) // The last parameter is the account to use from that mnemonic
			},
			network_id: 3,
			gas: 4e6
		}
	}
}

// Steps to deploy using infura to any network:
// 1. Install and import 'truffle-hdwallet-provider'
// 2. Get a mnemonic from 'testrpc' and save it here as a variable
// 3. Create the configuration with networks: {ropsten: {}}
// 4. Make sude to provide the HdProvider with the mnemonic, the infura network and the account to use from that mnemonic
// 5. Deploy with 'truffle migrate --network=ropsten'
// 6. Make sure to specify the gas to avoid errors
