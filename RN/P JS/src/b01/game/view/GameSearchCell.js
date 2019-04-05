import React, {Component} from 'react';
import {
    View,
    Image,
    Text,
    TouchableOpacity, StyleSheet
} from 'react-native'
import PropTypes from "prop-types";
import Constant from "../../../platform/common/Constant";


export default class GameSearchCell extends Component {

    static propTypes = {
        onPress: PropTypes.func.isRequired,
    }

    render() {
        let data = this.props.rowData;

        let maskH = 0;
        if (this.props.loginName==''){
            if (data.tryFlag==0) {
                maskH = styles.imgBox.height;
            }
        }
        return (
            <TouchableOpacity style={styles.container} onPress={this.props.onPress.bind(this)} disabled={maskH!=0} >

                <View style={styles.imgBox}>
                    <Image style={styles.img} source={{uri: data.gameImage}}/>
                    <View style={[styles.mask, {height: maskH}]}>
                        <Text style={[styles.maskItemText, {height: maskH}]}>不支持试玩</Text>
                    </View>
                </View>

                <View style={styles.rightBox}>
                    <Text style={styles.text}>{data.gameName}</Text>
                    <Text style={[styles.platformName,{color:'rgb(256,132,0)'}]}>{data.platformName}</Text>
                </View>

            </TouchableOpacity>
        );
    }
}

const styles = StyleSheet.create({
        container: {
            flex:1,
            flexDirection:'row',
            justifyContent:'flex-start',
            marginTop: 8,
            marginLeft: 40,
        },
        imgBox:{
            // flex:1,
            height:74,
            width: 130,
        },
        img: {
            height:74,
            width: 130,
            borderRadius: 8,
        },
        rightBox: {
            flex:1,
            flexDirection:'column',
        },
        platformName: {
            padding:4,
            height:21,
            width:40,
            marginLeft:16,
            marginTop:5,
            fontSize: 14,
            borderWidth:1,
            borderColor:'rgb(256,132,0)',
            lineHeight:13,
            textAlign: 'center'
        },
        text: {
            marginTop:8,
            marginLeft:16,
            fontSize: 14,
            color: 'black',
        },
        mask:{
            height:74,
            width: 130,
            borderRadius: 8,
            position:'absolute',
            backgroundColor:'rgba(0,0,0,0.5)',
        },
        maskItemText:{
            color: '#fff',
            fontSize: 14,
            height:74,
            lineHeight:74,
            textAlign:'center',
            backgroundColor:'#00000000'
        },
    })





