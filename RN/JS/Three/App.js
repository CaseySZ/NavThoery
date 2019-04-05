/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, Image, Alert, Button} from 'react-native';
import StyleLearn from './First'
import SecondView from './SecondView'
import { Navigation } from 'react-native-navigation';
//import { StackNavigator } from 'react-navigation';
//import {Navigation} from 'react-native-navigation'



const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

//type Props = {};



export default class App extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Greeting />
        <Bananas />
        <Greeting nameT='end' />

        <Blink text='123456' />
        <Blink text='09876' />
        <StyleLearn />
        <Button
           onPress={ () => {

            Alert.alert("你点击了我")
            
            
          }}
        
          title="点我"
        />

      </View>
    );
  }

  
}



class Bananas extends Component {

  render() {
  
    let pic = {

      url : 'https://upload.wikimedia.org/wikipedia/commons/d/de/Bananavarieties.jpg'
    }

    return (

        <Image source={pic} style={{width: 193, height: 110}} />
      )


  }
}

class Greeting extends Component {


  render () {

    return(

        <View style={{alignItems: 'center'}}>
        <Text>hello {this.props.nameT} </Text>
        </View>

    );

  }

}

class Blink extends Component {

   constructor(props) {
    super(props)
    this.state = { isShowingText: true}
    this.test = 'tetete'



    setInterval( () => {
        //debugger
        this.setState(previousState => {

            return {isShowingText: !previousState.isShowingText}
        });

    }, 1000);

   }

   render() {

      if (!this.state.isShowingText){

        return null
      }

      return (
        <Text> {this.props.text} </Text>
      );

   }


}


class Specext extends Component {

  render () {
    return <div>{this.props.value}</div>
  }
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
