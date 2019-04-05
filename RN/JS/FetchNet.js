

import React, {Component} from 'react';
import {Text, View, TextInput, Image} from 'react-native';


export default class FetchNet extends Component {

  // 父组件属性改变 （本组件有属性从父组件传过来的）
  componentWillReceiveProps() {


  }

  // 组件安装
  componentDidMount() {

    this.getServiceData()
  }
  // 组件卸载
  componentWillUnmount() {


  }

  constructor(props){
    super(props)

  }

  render() {

      //this.getServiceData();
      

      return(

          <View style={{flex : 1 , backgroundColor: 'blue' }}>

          </View>

      );

    }

     getRequest(url) {
      var opts = {
          method:"GET"
      }
  
      fetch(url, opts)
          .then((response) =>{
              return response.text();  //返回一个带有文本对象
          })
          .then((responseText) => {
              alter(responseText);
          })
          .catch((error) => {
              alter(error);
          })
  }



  
  getServiceData() {
     
      fetch('http://svr.tuliu.com/center/front/app/util/updateVersions', {

        method: 'POST',
        headers: {

          'Content-Type': 'application/x-www-form-urlencoded',

        },
        body: 'versions_id=1&system_type=1',


    }).then((response) => response.json())
      .then((responseJson) => {

          console.log('netData:',  responseJson);

      })
      .catch((error) => {

          console.log('netError:' , error);
      });

    }


    getXMLHttpRequest() {

      var request = new XMLHttpRequest();
      request.onreadystatechange= (e) => {

        if(request.readyState !== 4) {

          return;
        }
        if (request.status === 200) {
            console.log('success', request.responseText);
        }else {
          console.warn('error');
        }
      }

      request.open('GET', 'http://');
      request.send();

    }



}

