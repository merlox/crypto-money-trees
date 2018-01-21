import React from 'react'
import ReactDOM from 'react-dom'
import Web3 from 'web3'
import { abi as contractAbi } from './../build/contracts/Trees.json'

const contractAddress = '0xb4f10530e531c32490c68062662eb5684057afb4'

class App extends React.Component {
	constructor () {
		super()
		this.state = {
			output: 'This will be the output'
		}

		window.web3 = new Web3(new Web3.providers.HttpProvider('https://rinkeby.infura.io/6GO3REaLghR6wPhNJQcc'));
		window.contract = new web3.eth.contract(contractAbi, contractAddress);
	}

	// function generateTree() {
	// 	contract.methods.generateTree().sendTransaction({
	// 		from: web3.eth.accounts[0]
	// 	})
	// }

	render () {
		return (
			<div>
				<button>getTreeById</button>
				<button>getTreesByAddress</button>
				<button>getTreeIDs</button>
				<button onClick={() => this.generateTree()}>generateTree</button>
				<button>putTreeOnSale</button>
				<button>buyTree</button>
				<div>{this.state.output}</div>
			</div>
		)
	}
}

ReactDOM.render(
	<App />,
	document.querySelector('#root')
)
