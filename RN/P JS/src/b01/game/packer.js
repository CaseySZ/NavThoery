/**
 * @format
 * @lint-ignore-every XPLATJSCOPYRIGHT1
 */

import {
	AppRegistry
} from 'react-native';
import Game from './';

import {
	name as appName
} from '../../../app.json';


AppRegistry.registerComponent("game", () => Game);