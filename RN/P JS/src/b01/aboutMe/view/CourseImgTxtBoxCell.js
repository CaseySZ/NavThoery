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
import Constant from "../../../platform/common/Constant";


export default class CourseImgTxtBoxCell extends Component {

    static propTypes = {
        onPress: PropTypes.func.isRequired,
    }

    render() {

        let data = this.props.rowData;
        let img = imgs[data.img];
        return (
            <View style={styles.container}>
                <Image style={styles.img} source={img}/>
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
        flexDirection: 'row',
        marginTop:8,
        marginLeft:16,
        marginRight:16,
        padding:6,
        backgroundColor:'rgb(250,245,245)'
    },
    text:{
        marginLeft:8,
        paddingRight:16,
        color: 'rgb(136,136,136)',
        fontSize:12,
        lineHeight:21,
        width: Constant.kScreenWidth-101-32-6,
    },
    img:{
        alignSelf:'center',
        width:101,
    },
    title:{
        color: 'black',
        fontSize:12,
    },
})





