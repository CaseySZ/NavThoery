import React,{ Component } from "react";
import {
    StyleSheet,
    View,
    Text,
    TouchableWithoutFeedback,
    Image,
    NativeModules,
    AsyncStorage,
    StatusBar, BackHandler,
    Platform, TouchableOpacity, DeviceEventEmitter
} from 'react-native';
import {httpPost} from '../../platform/network/NPHttpManager'
import { Button, Modal, Toast,ActivityIndicator } from '@ant-design/react-native';
import {ifIphoneX} from "../../platform/common/Constant";
import SuggestBusiness from "./SuggestBusiness";
import BaseComponent from "../../platform/page/BaseComponent";
import Constant from "../../platform/common/Constant";

export default class MyNews extends BaseComponent {

    static navigationOptions = ({navigation}) =>{

        return {
            headerLeft:
                <TouchableOpacity
                    style={{width:40,marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)}}
                    onPress={() =>{
                        console.log('点击了首页返回')
                        DeviceEventEmitter.emit('closeRn')
                    }}>
                    <Image
                        style={{marginLeft:10}}
                        source={ require('../../../res/image/Backarrow.png')}
                    />
                </TouchableOpacity>,
            title: navigation.getParam('otherParam', '我的消息'),

        }
    };


    constructor(props) {
        super(props)
        console.log('我的消息constructor')
        this.state = {
            annonceData:null,
            lettersData:null,
            animating:true,
            //公告未读消息标识,默认没有未读标识
            announceUnread:false,
            //站内信未读消息标识,默认没有未读标识
            letterUnread:false,
            vipFeedbackData:''
        }

        this._willFocusSubscription = props.navigation.addListener('willFocus', payload => {
            console.log('我的消息willFocus')
            this.setState({ animating: true })
             //先将原生获取的名字存入本地
             this._getInitDataFromNative(()=>{
                 console.log("我的消息设置原生数据成功:"+this.loginName);
                 //初始值是没有待处理的进度
                 this.setState({vipFeedbackData:'当前没有待处理的进度'})
                 this._getAnnounce()
                 this._getNews()
                 this._getUnreadLetters()
                 this._getVipFeedback()
             })}
        );
    }

    componentDidMount() {
        console.log('我的消息componentDidMount')
        super.componentDidMount()
        this.listener =DeviceEventEmitter.addListener('closeRn',()=>{
            console.log("RN关闭原生界面");
            //关闭RN界面
            this.closeRn()
        });
    }

    componentWillMount() {
        console.log('我的消息componentWillMount')
        if(global.to == 'letter') {
            this.props.navigation.setParams({otherParam: '站内信'})
            this.view = 'gone'
            console.log('直接跳转站内信详情界面')
            this._getInitDataFromNative(()=>{
                this.props.navigation.navigate('letters')
            })
        }else{
            this.props.navigation.setParams({otherParam: '我的消息'})
            this.view = 'visible'
        }
    }

    componentWillUnmount() {
        console.log('我的消息componentWillUnmount')
        super.componentWillUnmount();
        this._willFocusSubscription && this._willFocusSubscription.remove();
    }

    closeRn() {
        NativeModules.BridgeModel.closeRn("news");
    }

    _getInitDataFromNative(putSuccess) {
        NativeModules.BridgeModel.getInitDataFromNative((result) => {
            console.log("我的消息加载后从原生收到2的:" + result);
            AsyncStorage.setItem('native_data',result,()=>{
                global.loginName = JSON.parse(result).loginName
                this.loginName = JSON.parse(result).loginName
                this.starLevel = JSON.parse(result).starLevel
                //如果不是要直接去站内信，则正常发起请求
                putSuccess()

            })
        });
    }

    _getAnnounce() {

        let subUrl = 'message/queryAnnounces'
        let params = {loginName:this.loginName}

        //第二个参数是个对象
        httpPost(subUrl,params,(json)=>{
            console.log('打印公告成功结果为::'+JSON.stringify(json))
            if(json) {
                this.announceSuccess = true
                if(this.letterSuccess && this.announceSuccess) {
                    this.setState({ animating: false });
                }
                if(json.length == 0) {
                    console.log('不使用模拟公告数据')
                    /*let flag = this._findUnreadFlag(fakeAnnounceData)
                    this.setState({
                        announceUnread:flag
                    })*/
                }else{
                    this.setState({
                        annonceData:json[0]
                    })
                }
            }
        });
    }

    _getNews() {
        let subUrl = 'letter/query'
        let params = {loginName:this.loginName,flag:0,pageSize:1}
        //第二个参数是个对象
        httpPost(subUrl,params,(json)=>{
            console.log('打印消息成功结果为::'+JSON.stringify(json))
            this.setState({ animating: false });
            if(json.data) {
                console.log('打印消息成功结果1为::'+JSON.stringify(json))
                this.letterSuccess = true
                if(this.letterSuccess && this.announceSuccess) {
                    this.setState({ animating: false });
                }
                if(json.data.length == 0) {
                    /*console.log('使用模拟消息数据')
                    let flag = this._findUnreadFlag(fakeLetterData)
                    this.setState({
                        letterUnread:flag
                    })*/
                    this.setState({
                        lettersData:null
                    })
                }else{
                    console.log('使用真实消息数据:'+(json.data)[0])
                    console.log('使用真实消息数据1:'+JSON.stringify((json.data)[0]))
                    this.setState({
                        lettersData:(json.data)[0]
                    })

                    /*let flag = this._findUnreadFlag(json.data)
                    this.setState({
                        lettersData:(json.data)[0],
                        letterUnread:flag
                    },()=>{

                    })*/
                }

            }else{
                console.log('打印消息成功结果2为::')
            }
        });
    }

    //获取vip反馈数据
    _getVipFeedback() {
        let params = {loginName:this.loginName}
        SuggestBusiness.querySuggests(params).then((json)=>{
            console.log('打印vip反馈建议结果为3::'+json)
            console.log('打印vip反馈建议结果为4::'+json.length)
            let index
            for(index in json) {
                if(json[index].flag == '0') {
                    this.setState({
                        vipFeedbackData:'当前有待处理的进度'
                    })
                    break;
                }
            }
        },error =>{
            console.log('打印vip反馈建议结果为5::'+error)
        }).catch( (status) => {
            console.log('打印vip反馈建议结果为6::'+status)
        })
    }

    //获取未读站内信个数
    _getUnreadLetters() {
        let subUrl = 'letter/countUnread'
        let params = {loginName:this.loginName}

        console.log('获取未读消息个数请求:'+JSON.stringify(params))
        //第二个参数是个对象
        httpPost(subUrl,params,(json)=>{
            console.log('获取未读消息个数成功后::'+JSON.stringify(json))
            if(JSON.stringify(json) == 0) {
                console.log('获取未读消息个数成功1后::')
                //代表都已读
                this.setState({
                    letterUnread:false
                })
            }else{
                console.log('获取未读消息个数成功2后::')
                //代表有未读
                this.setState({
                    letterUnread:true
                })
            }
        });
    }

    _goDetail(data){
        if(data.flag == 0) {
            this.props.navigation.navigate('announce',data)
        }else if(data.flag == 1){
            this.props.navigation.navigate('letters',data)
        }else if(data.flag == 2){
            this.props.navigation.navigate('VipFeedback',data)
        }
    }

    render_vip_feedback() {
        if( parseInt(this.starLevel) >= 3 ) {
            return (
                <TouchableWithoutFeedback
                    onPress={()=>this._goDetail({'flag':'2','itemId':789})}
                >
                    <View
                        style={styles.announce_container}>
                        <Image
                            style={styles.announce_img}
                            source={require('../../../res/image/icon_vip.png')}/>
                        <View
                            style={styles.annonce_txt}>
                            <View>
                                <Text style={{color:'black'}}>vip反馈通道</Text>
                                <Text numberOfLines={2} style={{color:'rgb(162,162,162)',marginRight:10,marginTop:5}}>{this.state.vipFeedbackData}</Text>
                            </View>
                            <View/>
                        </View>
                    </View>
                </TouchableWithoutFeedback>
            )
        }else{
            return null
        }

    }

    renderView() {
        if(this.view == 'gone') {
            return(
                <View style={styles.container}>
                    {
                        Platform.OS === 'ios' ? null :
                            <StatusBar
                                animated={true} //指定状态栏的变化是否应以动画形式呈现。目前支持这几种样式：backgroundColor, barStyle和hidden
                                hidden={false}  //是否隐藏状态栏。
                                backgroundColor={'transparent'} //状态栏的背景色
                                translucent={true}//指定状态栏是否透明。设置为true时，应用会在状态栏之下绘制（即所谓“沉浸式”——被状态栏遮住一部分）。常和带有半透明背景色的状态栏搭配使用。
                                barStyle={'light-content'} // enum('default', 'light-content', 'dark-content')
                            />
                    }
                </View>
            )
        }else{
            return(
                <View
                    style={styles.container}>
                    {
                        Platform.OS === 'ios' ? null :
                            <StatusBar
                                animated={true} //指定状态栏的变化是否应以动画形式呈现。目前支持这几种样式：backgroundColor, barStyle和hidden
                                hidden={false}  //是否隐藏状态栏。
                                backgroundColor={'transparent'} //状态栏的背景色
                                translucent={true}//指定状态栏是否透明。设置为true时，应用会在状态栏之下绘制（即所谓“沉浸式”——被状态栏遮住一部分）。常和带有半透明背景色的状态栏搭配使用。
                                barStyle={'light-content'} // enum('default', 'light-content', 'dark-content')
                            />
                    }

                    <ActivityIndicator
                        ref={(ref) => this.activityIndicator = ref}
                        animating={this.state.animating}
                        toast
                        size="large"
                        text="Loading..."
                    />

                    <TouchableWithoutFeedback
                        onPress={()=>this._goDetail({'flag':'0','itemId':123})}
                    >
                        <View
                            style={styles.announce_container}>
                            <Image
                                style={styles.announce_img}
                                source={require('../../../res/image/icon_annource.png')}/>
                            <View
                                style={styles.annonce_txt}>
                                <View style={{height:70}}>
                                    <Text style={{color:'black'}}>系统公告</Text>
                                    <Text numberOfLines={2} style={{color:'rgb(162,162,162)',marginRight:10,marginTop:5}}>{this.state.annonceData ? this.state.annonceData.content : '没有新公告哦'}</Text>
                                    <Text style={{color:'rgb(162,162,162)',marginRight:10}}>{this.state.annonceData ? this.state.annonceData.createDate : ''}</Text>
                                </View>
                                <View
                                    style={styles.h_line}
                                />
                            </View>

                        </View>
                    </TouchableWithoutFeedback>

                    <TouchableWithoutFeedback
                        onPress={()=>this._goDetail({'flag':'1','itemId':789})}
                    >
                        <View
                            style={styles.announce_container}>
                            <Image
                                style={styles.announce_img}
                                source={require('../../../res/image/icon_msg.png')}/>
                            <View
                                style={styles.annonce_txt}>
                                <View style={{height:70}}>
                                    <View style={{flexDirection:'row'}}>
                                        <Text style={{color:'black'}}>站内信</Text>
                                        {this.state.letterUnread ? <Image style={{marginLeft: 10,alignSelf:'center'}} source={require('../../../res/image/icon_red_dot.png')}/> : null}
                                    </View>
                                    <Text numberOfLines={2} style={{color:'rgb(162,162,162)',marginRight:10,marginTop:5}}>{this.state.lettersData ? this.state.lettersData.content : '没有新消息哦'}</Text>
                                    <Text style={{color:'rgb(162,162,162)',marginRight:10}}>{this.state.lettersData ? this.state.lettersData.createDate : ''}</Text>
                                </View>
                                <View style={styles.h_line}/>
                            </View>
                        </View>
                    </TouchableWithoutFeedback>

                    { this.render_vip_feedback() }

                </View>
            )
        }
    }


    render(){
        return(
            this.renderView()
        )
    }

}

const styles = StyleSheet.create({

    container:{
        flex:1,
        flexDirection: 'column'
    },
    announce_container:{
        flexDirection: 'row',
        height: 110,
        paddingLeft: 20,
        paddingTop:15,
    },
    msg_container:{

    },
    announce_img:{
        width:45,
        height:45
    },
    annonce_txt:{
        marginLeft:10,
        justifyContent:'space-between',
        height:90,
        flex:1,
        flexDirection:'column',

    },
    h_line:{
        height:1,
        backgroundColor:'rgb(235,235,235)',
    },
    darkBg: {
        alignItems: 'center',
        justifyContent: 'center',
        width: 89,
        height: 89,
        backgroundColor: '#2B2F42',
    },

})