import React,{ Component } from "react";
import {StyleSheet, View, Text, TouchableWithoutFeedback, Image, NativeModules} from 'react-native';
import Constant from "../../platform/common/Constant";
import PropTypes from "prop-types";

export default class VipFeedbackSuccess extends Component {

    constructor(props) {
        super(props)
        this.title = this.props.title
    }

    static propTypes = {
        queryProgress: PropTypes.func.isRequired,  //一键删除
    }

    render(){
        return(
            <View
                style={styles.container}>
                <Image
                    style={{width:Constant.kScreenWidth*1/3,height:Constant.kScreenWidth*1/3}}
                    source={require('../../../res/image/icon_vip_feedback_ok.png')}
                    />
                <Text  style={styles.first_text}>提交成功</Text>
                <View
                    style={styles.service_view}
                    >
                    <Text style={styles.second_text}>VIP客服稍后将为您提供反馈</Text>
                    <TouchableWithoutFeedback
                        onPress={this.props.queryProgress.bind(this)}
                        style={styles.btn_style}
                        >
                        <Text style={styles.service_text}>查看处理进度 ></Text>
                    </TouchableWithoutFeedback>
                </View>

            </View>

        )
    }

}

const styles = StyleSheet.create({

    container:{
        flex:1,
        flexDirection: 'column',
        alignItems: 'center',
        marginTop: 100
    },
    service_view:{
      flexDirection: 'column',
      marginTop: 10,
      justifyContent: 'center',
      alignItems: 'center',
    },
    btn_style:{
        backgroundColor:'#fe6723',
        padding:5
    },
    first_text:{
        fontSize:17,
        marginTop:20,
        color:'#4c4747',
    },
    second_text:{
        fontSize:17,
        color:'#4c4747',
    },
    service_text:{
        color:'#007aff',
        marginTop:15
    }

})