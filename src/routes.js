import { App, MyTrees, Market } from './App'

const routes = [
	{
		component: App,
		routes: [{
			path: '/',
			exact: true,
			component: MyTrees
		}, {
			path: '/market',
			component: Market
		}]
	}
]

export default routes
