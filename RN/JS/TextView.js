

import React, {Component} from 'react';
import {Text, View, TextInput} from 'react-native';



export default class TextView extends Component {


  constructor(props) {
    super(props);
    this.state = {text: '1', testText: '1'};
  }



  render() {


    return (

      <View style={{padding: 80}}>

        <TextInput 
          style={{height:40}}
          placeholder="please input"
          onChangeText={(text) => {

              this.setState({text});

          }}
          onFocus={() => {
            
            console.log('onFocus');

          }}

        /> 
        <Text style={{padding:80, fontSize:42}}>
          
            {this.state.text} {this.state.testText}  

        </Text>

      </View>
    );


  }


}