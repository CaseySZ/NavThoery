import React, {Component} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
} from 'react-native'

import imgs from '../CourseImgDic'

export default class CourseTxtCell extends Component {

    render() {

        let data = this.props.rowData;
        return (
            <View style={styles.container}>
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
    text:{
        color: 'rgb(136,136,136)',
        fontSize:12,
        marginLeft:16,
        marginRight:16,
        lineHeight: 21,
        marginTop:16,
    },

})





