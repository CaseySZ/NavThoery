/**
 * @format
 * @lint-ignore-every XPLATJSCOPYRIGHT1
 */

import {
    AppRegistry
} from 'react-native';
import {
    name as appName
} from './app.json';

// if (__DEV__) {
//     GLOBAL.XMLHttpRequest = GLOBAL.originalXMLHttpRequest || GLOBAL.XMLHttpRequest
// }

// import App from './src/b01/news/App'
// AppRegistry.registerComponent(appName, () => App);


import App from './App';
AppRegistry.registerComponent(appName, () => App);

// import aboutMe from './src/b01/aboutMe';
// AppRegistry.registerComponent(appName, () => aboutMe);

// import SuperPartner from './';
// AppRegistry.registerComponent('rn_B01',()=>SuperPartner);
