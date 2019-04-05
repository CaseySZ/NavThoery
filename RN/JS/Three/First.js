


import React, { Component } from 'react';
import { Platform, StyleSheet, Text, View, Image } from 'react-native';


export default class StyleLearn extends Component {

    render() {


        return (

            <LotsOfStyles />

        );


    }

}


class LotsOfStyles extends Component {

    constructor(props) {
        super(props)

        this.state = {

            styles: {

                red: {

                    color: 'red',
                },

                blue: {

                    color: 'blue',
                    fontSize: 40,

                },


            }
        }
    }

    render() {

        return (

            <View>
                <Text style={{ color: 'blue', fontSize: 30, fontWeight: 'bold' }}> big blue </Text>
                <Text style={styles.red}> just red</Text>
                <Text style={this.state.styles.blue}> just blue</Text>
                <Text style={sepcStyles.red}> specStyle  </Text>
            </View>
        );

    }

}


const sepcStyles = {

    red: {

        color: 'red',
    },

    bigBlue: {

        color: 'blue',
        fontSize: 40,

    },

}

const styles = StyleSheet.create({

    red: {

        color: 'red',
    },

    bigBlue: {

        color: 'blue',
        fontSize: 40,

    },

});



