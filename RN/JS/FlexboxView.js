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
;


const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});




export default class FlexboxView extends Component {


    render() {
      
      console.log('renderlog');

      return(

          <View style={styles.flexAlignEnd} >

            <View  style={{backgroundColor: "blue", width: 50, height: 50}} />
            <View  style={{backgroundColor: "red", width: 50, height: 50}} />
            <View  style={{backgroundColor: "yellow", width: 50, height: 50}} />
            
          </View>

      );


    }


}



const styles = {


  size : {

    width: 50,
    height : 50,

  },

  flexRow: {
    flex: 1,
    flexDirection: 'row',
  },

  flowColomn: {
    flex: 1,
    flexDirection: 'column',

  },

  flexSpaceBetween: {

      flex: 1,
      flexDirection: 'column',
      justifyContent: 'space-between',
  
  },

  flexSpaceAround: {

    flex: 1,
    flexDirection: 'column',
    justifyContent: 'space-around',

  },

  flexEnd: {

    flex: 1,
    flexDirection: 'column',
    justifyContent: 'flex-end',

  },

  flexStart: {

    flex: 1,
    flexDirection: 'column',
    justifyContent: 'flex-start',

  },

  flexCenter: {

    flex: 1,
    flexDirection: 'column',
    justifyContent: 'center',

  },
  
  flexAlignCenter: {

    flex: 1,
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',

  },
  
  flexAlignEnd: {

    flex: 1,
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'flex-end',

  },

}





