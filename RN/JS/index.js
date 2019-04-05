/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';
import TextView from './TextView'
import UIScrollView from './UIScrollView'
import TableView from './TableView'
import TableViewSection from './TableViewSection'
import FetchNet from './FetchNet'


AppRegistry.registerComponent(appName, () => FetchNet);
