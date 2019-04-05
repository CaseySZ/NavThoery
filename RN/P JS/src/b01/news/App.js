/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 * @lint-ignore-every XPLATJSCOPYRIGHT1
 */

import React, {Component} from 'react';
import AppNavigator from './route';
import {Provider} from "@ant-design/react-native";

export default class App extends Component {

    constructor(props) {
        super(props);
        if(this.props) {
            console.log('App界面2原生0123加载bundle的初始值参数'+JSON.stringify(this.props.args))
            //原生加载bundle的初始值参数
            let initProps = this.props.args.to
            if(initProps) {
                global.to = initProps
            }
            console.log('App界面2原生1加载bundle的初始值参数'+initProps)
            // if(this.props.initialProps) {
            //     let to = this.props.initialProps.to
            //     console.log('App界面2原生1加载bundle的初始值参1数'+to)
            // }
        }
    }


  render() {

      let initProps = this.props.to
      console.log('App界面5原生0123加载bundle的初始值参数'+global.to)
      console.log('App界面4原生0123加载bundle的初始值参数'+initProps)

      return (
          <Provider>
              <AppNavigator />
          </Provider>

      );
      /*if(initProps && initProps == 'letter') {
          return (
              <LetterNavigator />
          );
      }else{
          return (
              <Provider>
                  <AppNavigator />
              </Provider>

          );
      }*/
  }
}

