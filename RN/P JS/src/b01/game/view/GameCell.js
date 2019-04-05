import React, {Component} from 'react';
import {
    View,
    Image,
    Text,
    TouchableOpacity, StyleSheet
} from 'react-native'
import Constant from "../../../platform/common/Constant";
import PropTypes from "prop-types";


export default class GameCell extends Component {

    static propTypes = {
        onPress: PropTypes.func.isRequired,
    }

    render() {
        let data = this.props.rowData

        let bzText = '';

        if (data.preferenceFlag==1){
            bzText = '特惠';
        } else if (data.exCode.toLowerCase()=='hd'){
            bzText = '活动';
        }else if (data.recommendFlag==1){
            bzText = '推荐';
        }else if (data.hotFlag==1){
            bzText = '最热';
        }

        let maskH = 0;
        if (this.props.loginName==''){
            if (data.tryFlag==0) {
                maskH = ((Constant.kScreenWidth-24)/2)*0.6;
            }
        }

        return (
            <TouchableOpacity style={styles.container} onPress={this.props.onPress.bind(this)}  disabled={maskH!=0} >
                <View style={styles.imgBox}>
                    <Image style={styles.img} source={{uri: data.gameImage}}/>
                    <View style={[styles.rtItem,{height:bzText==''?0:21,backgroundColor:bzText=='特惠'?'#fb333c':'rgb(236,116,67)'}]}>
                        <Text style={styles.rtItemText}>{bzText}</Text>
                    </View>

                    <View style={[styles.rbItem]}>
                        <Text style={styles.rbItemText}>{data.payLine}线</Text>
                    </View>

                    <View style={[styles.lbItem]}>
                        <Text style={styles.lbItemText}>{data.platformName}</Text>
                    </View>

                    <View style={[styles.mask,{height:maskH}]}>
                        <Text style={[styles.maskItemText,{height:maskH}]}>不支持试玩</Text>
                    </View>

                </View>

                <Text style={styles.text}>{data.gameName}</Text>
            </TouchableOpacity>
        );
    }
}

const styles = StyleSheet.create({
        container: {
            flex:1,
            flexDirection:'column',
            justifyContent:'center',
            alignItems:'center',
            borderRadius: 8,
        },
        imgBox:{
            flex:1,
            height:((Constant.kScreenWidth-24)/2)*0.6,
            width: (Constant.kScreenWidth-24)/2,
            borderRadius: 8,
        },
        img: {
            height:((Constant.kScreenWidth-24)/2)*0.6,
            width: (Constant.kScreenWidth-24)/2,
            borderRadius: 8,
        },
        rtItem:{
            top: 0,
            right:0,
            position:'absolute',
            backgroundColor:'rgb(236,116,67)',
            borderRadius: 8,
        },
        rbItem:{
            bottom: 0,
            right:0,
            position:'absolute',
            backgroundColor:'rgba(0,0,0,0.4)',
            borderRadius: 4,
        },
        rbItemText:{
            color: '#fff',
            fontSize: 12,
            paddingLeft:5,
            paddingRight:5,
            paddingTop:2,
            paddingBottom:2,
            backgroundColor:'#00000000'
        },
        lbItem:{
            bottom: 0,
            left:0,
            position:'absolute',
            backgroundColor:'rgba(0,0,0,0.4)',
            borderRadius: 4,
        },
        lbItemText:{
            color: '#fff',
            fontSize: 12,
            paddingLeft:5,
            paddingRight:5,
            paddingTop:2,
            paddingBottom:2,
            backgroundColor:'#00000000'
        },
        rtItemText:{
            color: '#fff',
            fontSize: 12,
            padding: 5,
            backgroundColor:'#00000000'
        },
        text: {
            marginTop:8,
            fontSize: 14,
            color:'black',
        },
        mask:{
            height:((Constant.kScreenWidth-24)/2)*0.6,
            width: (Constant.kScreenWidth-24)/2,
            borderRadius: 8,
            position:'absolute',
            backgroundColor:'rgba(0,0,0,0.5)',
        },
        maskItemText:{
            color: '#fff',
            fontSize: 14,
            height:((Constant.kScreenWidth-24)/2)*0.6,
            lineHeight:((Constant.kScreenWidth-24)/2)*0.6,
            textAlign:'center',
            backgroundColor:'#00000000'
        },
    })





