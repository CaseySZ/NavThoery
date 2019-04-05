

import React, {Component} from 'react';
import {Text, View, Image, ScrollView} from 'react-native';




export default class UIScrollView extends Component {

    render() {

        let pic = {

            url : 'https://upload.wikimedia.org/wikipedia/commons/d/de/Bananavarieties.jpg'
        }

        return(

            <ScrollView>

                <Text style={{fontSize: 24}}> scroll me </Text>
                <Image source={{url: 'https://upload.wikimedia.org/wikipedia/commons/d/de/Bananavarieties.jpg'}}  style={{width:200, height:200}} />
                <Text style={{fontSize: 24}}> finish load picture </Text>
                <Text style={{fontSize: 24}}> finish load pictureTwo </Text>

            </ScrollView>
        );  


    }



}