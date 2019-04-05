/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View} from 'react-native';
import { blue, red, green } from 'ansi-colors';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});




export default class LayoutView extends Component {

  render() {
    return (

      <View>
        <View style={{width: 50, height: 50, backgroundColor: 'blue'}} />
        <View style={{width: 100, height:100, backgroundColor: 'red'}} />
        <View style={{width: 150, height:150, backgroundColor: 'green'}} />
      </View>
    );

  }
}

export class FlexLayoutView extends Component {


  render() {

    return(
    //display:'flex',flexDirection: 'column'
      <View style={styles.size} >

        <View style={{flex: 1,   backgroundColor: 'black'}} />
        <View style={{flex: 2,  backgroundColor: 'red'}} />
        <View style={{flex: 3,  backgroundColor: 'green'}} />
      </View>
    
    );

  }


}


const styles = {

  flex : {
    flex : 1
  },
  size : {
    width: 200,
    height: 200
  }

}



