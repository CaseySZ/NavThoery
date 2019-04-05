import React, {Component} from 'react';
import {
    View,
    Text,
    StyleSheet,
} from 'react-native'

import LinearGradient from "react-native-linear-gradient";

export default class CourseBtnCell extends Component {

    render() {

        let data = this.props.rowData;
        let colors = ['rgb(255,170,1)','rgb(255,170,1)'];
        if (this.props.colors){
            colors = this.props.colors
        }
        return (

                <View style={styles.container}>

                        <LinearGradient style={[styles.tryPlayBtnBox, {width: data.width}]} colors={colors} start={{x: 0.0, y: 0.0}} end={{x: 1.0, y: 1.0}}>

                        <Text style={styles.tryPlayBtnText}>{data.content}</Text>

                        </LinearGradient>
                </View>

        );
    }
}

const styles = StyleSheet.create({
    container: {
        // flex: 1,
        flexDirection: 'column',
    },
    tryPlayBtnBox: {
        backgroundColor: 'rgb(255,170,1)',
        width: 80,
        height: 30,
        borderRadius: 12,
        marginTop:16,
        marginLeft:16,
    },
    tryPlayBtnText: {
        color: 'white',
        lineHeight: 30,
        textAlign: 'center',
    },
})





