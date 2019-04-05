import React,{ Component } from "react";
import {
    StyleSheet,
    FlatList,
    View,
    Text,
    TextInput,
    ScrollView,
    TouchableWithoutFeedback,
    TouchableOpacity,
    Image,
    NativeModules,
    Dimensions, AsyncStorage,
    StatusBar, BackHandler,
    Platform, DeviceEventEmitter, RefreshControl, ImageBackground
} from 'react-native';

import CheckboxForm from '../widget/CheckboxForm'
import Constant from "../../platform/common/Constant";
import {ActivityIndicator, Toast} from '@ant-design/react-native';
import SuggestBusiness from "../news/SuggestBusiness";
import VipFeedbackSuccess from "../feedback/VipFeedbackSuccess";
import BaseComponent from "../../platform/page/BaseComponent";


export default class VipFeedbackProgress extends BaseComponent {

    static navigationOptions = {
        title: '我的问题处理进度',
    };

    constructor(props) {
        super(props)
        this.state = {
            //问题描述
            text:'',
            data:[],
            animating:false,
        }
        this.loginName = global.loginName
    }

    componentDidMount() {
        super.componentDidMount()
        this.setState({ animating: true });
        this._getVipFeedback()
    }

    //获取vip反馈数据
    _getVipFeedback() {
        let params = {loginName:this.loginName}
        SuggestBusiness.querySuggests(params).then(json=>{
            this.setState({ animating: false });
            console.log('获取vip反馈建议结果为3::'+json)
            console.log('获取vip反馈建议结果为4::'+json.length)
            this.setState({
                data:json
            })
            let index
            for(index in json) {
                if(json[index].flag == '0') {
                    this.setState({
                        vipFeedbackData:'当前有待处理的进度'
                    })
                    break;
                }
            }
        },error=>{
            this.setState({ animating: false });
            console.log('获取vip反馈建议结果为5::'+error)
        }).catch( (status) => {
            console.log('获取vip反馈建议结果为6::'+status)
        })
    }

    _renderStatusText(item) {
        if(item.flag == '0') {
            return(
                <Text style={{color:'#fb3d3d'}}>待处理</Text>
            )
        }else{
            return(
                <Text style={{color:'#61c900'}}>已回复</Text>
            )
        }
    }

    onItemPress(item) {
        let data = {'item':item}
        this.props.navigation.navigate('VipFeedbackProgressDetail',data)
    }

    _renderItem({item}) {
        return(
            <TouchableWithoutFeedback
                onPress={()=>{this.onItemPress(item)}}>
                <View
                    style={styles.item_container}>
                    <View style={styles.item_time_view}>
                        {item.createdDate.split(' ')[0] ? <Text style={styles.item_tv_time}>{item.createdDate.split(' ')[0]}</Text> : null}
                        {item.createdDate.split(' ')[1] ? <Text style={styles.item_tv_time}>{item.createdDate.split(' ')[1]}</Text> : null}
                    </View>
                    <View style={styles.item_content_view}>
                        <Text numberOfLines={1} style={styles.item_tv_content}>{item.content}</Text>
                    </View>
                    <View style={styles.item_status_view}>
                        {this._renderStatusText(item)}
                    </View>
                </View>
            </TouchableWithoutFeedback>)
    }

    //渲染头部
    _renderHeander() {
        return(<View
            style={styles.header_container}>
            <View style={styles.head_time}>
                <Text style={styles.header_tv}>提交时间</Text>
            </View>
            <View style={styles.head_content}>
                <Text style={styles.header_tv}>内容</Text>
            </View>
            <View style={styles.head_status}>
                <Text style={styles.header_tv}>操作状况</Text>
            </View>
        </View>)
    }


    render(){
        return(

            <View  style={styles.container}>

                <ActivityIndicator
                    ref={(ref) => this.activityIndicator = ref}
                    animating={this.state.animating}
                    toast
                    size="large"
                    text="Loading..."
                />
                <FlatList
                    style={styles.container}
                    ref={(flatList)=>this._flatList = flatList}
                    data={this.state.data}
                    renderItem={this._renderItem.bind(this)}
                    ListHeaderComponent={this._renderHeander}
                    keyExtractor={(item) => item.createdDate}
                    extraData={this.state}
                    getItemLayout={(data, index) =>
                        // 90 是被渲染 item 的高度 ITEM_HEIGHT。
                        ({ length: 90, offset: 90 * index, index })
                    }
                />
            </View>

        )
    }
}

const styles = StyleSheet.create({
    container:{
        flex:1,
        backgroundColor:'#f2f2f2'
    },
    header_container:{
        flex:1,
        flexDirection: 'row',
        backgroundColor:'#fff6f6',
    },
    head_time:{
        width:Constant.kScreenWidth*0.2645,
        height:50,
        justifyContent:'center',
        alignItems:'center',
        borderBottomWidth:Constant.onePixel,
        borderRightWidth:Constant.onePixel,
        borderColor:'#d4d4d4',
    },
    head_content:{
        flex:1,
        height:50,
        justifyContent:'center',
        alignItems:'center',
        borderBottomWidth:Constant.onePixel,
        borderRightWidth:Constant.onePixel,
        borderColor:'#d4d4d4',
    },
    head_status:{
        width:Constant.kScreenWidth*0.2078,
        height:50,
        justifyContent:'center',
        alignItems:'center',
        borderBottomWidth:Constant.onePixel,
        borderRightWidth:Constant.onePixel,
        borderColor:'#d4d4d4',
    },
    item_container:{
        flex:1,
        flexDirection: 'row',
        backgroundColor:'white',
    },
    item_time_view:{
        flexDirection:'column',
        width:Constant.kScreenWidth*0.2645,
        height:50,
        justifyContent:'center',
        alignItems:'center',
        borderBottomWidth:Constant.onePixel,
        borderRightWidth:Constant.onePixel,
        borderColor:'#d4d4d4',
    },
    item_tv_time:{
        color:'black',

    },
    header_tv:{
        color:'#888888',
    },
    item_content_view:{
        flex:1,
        height:50,
        justifyContent:'center',
        paddingLeft:15,
        paddingRight:15,
        borderBottomWidth:Constant.onePixel,
        borderRightWidth:Constant.onePixel,
        borderColor:'#d4d4d4',
    },
    item_tv_content:{
        color:'black',
    },
    item_status_view:{
        width:Constant.kScreenWidth*0.2078,
        height:50,
        justifyContent:'center',
        alignItems:'center',
        borderBottomWidth:Constant.onePixel,
        borderRightWidth:Constant.onePixel,
        borderColor:'#d4d4d4',
    },
    item_tv_status:{
        color:'black',
    },
})