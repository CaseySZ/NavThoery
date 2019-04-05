import React, {Component} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
} from 'react-native'

import imgs from '../CourseImgDic'

export default class CourseBjlCell extends Component {

    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.text}>百家乐中将发两份牌{"<<"}<Text style={styles.title}>庄家</Text>{">>"} 和{"<<"}<Text style={styles.title}>闲家</Text>{">>"}，总数得9点或最接近9点的一家胜出。</Text>
                <View style={styles.imgBox}>
                    <Image style={styles.img} source={imgs["bjl_1"]}/>
                    <Image style={styles.img} source={imgs["bjl_2"]}/>
                </View>
                <View style={styles.imgBox}>
                    <Text style={[styles.title,{textAlign: 'center',flex:1,marginTop:4}]}>
                        庄家<Text style={styles.redText}>(9点赢)</Text>
                    </Text>
                    <Text style={[styles.title,{textAlign: 'center',flex:1,marginTop:4}]}>
                        闲家<Text style={styles.redText}>(8点赢)</Text>
                    </Text>
                </View>
            </View>
        );
    }
}


const styles = StyleSheet.create({
    container: {
        // flex: 1,
        flexDirection: 'column',
        marginLeft:16,
        marginRight:16,
        marginTop:16,
    },
    imgBox:{
        flexDirection: 'row',
        justifyContent:'center',
    },
    title:{
        color: 'black',
        fontSize:12,
    },
    text:{
        marginTop:8,
        color: 'rgb(136,136,136)',
        fontSize:12,
        lineHeight:21,
    },
    img:{
        marginLeft:5,
        marginRight:5,
        marginTop:8,
        backgroundColor:'rgb(250,245,245)'
    },
    redText:{
        color:'rgb(255,170,1)',
    }
})





