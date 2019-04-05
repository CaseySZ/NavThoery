/**
 * @format
 * @lint-ignore-every XPLATJSCOPYRIGHT1
 */

import {
	AppRegistry,
	Alert, NativeModules
} from 'react-native';
import App from './App'
import {
	name as appName获取未读消息个数成功1后
} from '../../../app.json';

import { setJSExceptionHandler } from '../error_guard';

setJSExceptionHandler((e, isFatal) => {
	if (isFatal) {
		console.log('捕获到了异常')
		NativeModules.BridgeModel.catchRnException('news')

	} else {
		console.log(e);
	}
}, true);
AppRegistry.registerComponent('news', () => App);