import React, {Component} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity,
} from 'react-native'
import PropTypes from "prop-types";
import imgs from "../CourseImgDic";


export default class CourseBoxCell extends Component {

    static propTypes = {
        onPress: PropTypes.func.isRequired,
    }

    render() {

        let data = this.props.rowData;
        let img = imgs[data.img];
        if (img){
            return (
                <View style={styles.container}>
                    <Text style={styles.title}>{data.title}</Text>
                    <Text style={styles.text}>{data.content}</Text>
                    <Image style={styles.img} source={img}/>
                </View>
            );
        } else {
            return (
                <View style={styles.container}>
                    <Text style={styles.title}>{data.title}</Text>
                    <Text style={styles.text}>{data.content}</Text>
                </View>
            );
        }
    }
}


const styles = StyleSheet.create({
    container: {
        // flex: 1,
        flexDirection: 'column',
        marginLeft:16,
        marginRight:16,
        padding:10,
        backgroundColor:'rgb(250,245,245)'
    },
    title:{
        color: 'black',
        fontSize:14,
    },
    text:{
        marginTop:8,
        color: 'rgb(136,136,136)',
        fontSize:12,
        lineHeight:21,
    },
    img:{
        marginTop:8,
        alignSelf:'center',
    }
})





