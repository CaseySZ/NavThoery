import React, {Component} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
} from 'react-native'
import Constant from "../../../platform/common/Constant";

export default class IntroTextCell extends Component {

    render() {
        let data = this.props.rowData;
        return (
            <View style={styles.container}>
                <Text style={styles.text}>
                    <Text style={styles.title}>{data.title}</Text>
                    {data.content}
                </Text>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        marginLeft:16,
        marginRight:16,
    },
    text:{
        marginLeft:8,
        paddingRight:16,
        color: 'rgb(136,136,136)',
        fontSize:12,
        lineHeight:21,
    },
    title:{
        color: 'black',
        fontSize:12,
    },
})





