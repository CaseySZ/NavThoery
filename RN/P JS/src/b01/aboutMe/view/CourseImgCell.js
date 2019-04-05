import React, {Component} from 'react';
import {
    View,
    StyleSheet,
    Image,
} from 'react-native'

import imgs from '../CourseImgDic'

export default class CourseImgCell extends Component {

    render() {
        let data = this.props.rowData;
        let img = imgs[data.content];
        return (
            <View style={styles.container}>
                <Image style={styles.img} source={img}/>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        // flex: 1,
        flexDirection: 'row',
        justifyContent:'center'
    },
    img:{
        marginTop:16,
        alignSelf:'center',
    }
})





