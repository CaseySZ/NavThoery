import React, {Component} from 'react';
import {
    View,
    Text,
     StyleSheet
} from 'react-native'


export default class IntroduceCell extends Component {

    render() {

        let data = this.props.rowData;

        return (
            <View style={styles.container}>

                <View style={[styles.tryPlayBtnBox,{width:data.width}]}>
                    <Text style={styles.tryPlayBtnText}>{data.title}</Text>
                </View>

                <Text style={styles.text}>{data.content}</Text>
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
        marginBottom: 16,
        marginTop:16,
        marginLeft:16,
    },
    tryPlayBtnText: {
        color: 'white',
        marginLeft:8,
        lineHeight: 30,
    },
    text:{
        color: 'rgb(136,136,136)',
        fontSize:12,
        marginLeft:16,
        marginRight:16,
        lineHeight: 21,
    }
})





