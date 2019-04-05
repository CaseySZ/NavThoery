import React, {Component} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
} from 'react-native'

import imgs from '../CourseImgDic'

export default class CourseTitleCell extends Component {

    render() {

        let data = this.props.rowData;
        return (
            <View style={styles.container}>
                <Text style={styles.title}>{data.content}</Text>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'column',
    },
    title:{
        color: 'black',
        fontSize:12,
        marginTop:16,
        marginLeft:16,
    }
})





