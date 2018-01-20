import React from 'react'
import ReactDOM from 'react-dom'

class App extends React.Component {
	constructor () {
		super()
		this.state = {
			output: 'This will be the output'
		}
	}

	render () {
		return (
			<div>
				<button>getTreeById</button>
				<button>getTreesByAddress</button>
				<button>getTreeIDs</button>
				<button>generateTree</button>
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
