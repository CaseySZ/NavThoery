import React,{ Component } from "react";
import {
    StyleSheet,
    View,
    Text,
    TextInput,
    ScrollView,
    TouchableWithoutFeedback,
    TouchableOpacity,
} from 'react-native';

import CheckboxForm from '../widget/CheckboxForm'
import Constant from "../../platform/common/Constant";
import {ActivityIndicator, Toast} from '@ant-design/react-native';
import SuggestBusiness from "../news/SuggestBusiness";
import VipFeedbackSuccess from "../feedback/VipFeedbackSuccess";
import BaseComponent from "../../platform/page/BaseComponent";


let mockData = [{label: 'VIP福利咨询',value: '0',RNchecked:false},{label: '存取款相关',value: '1',RNchecked:false},{label: '优惠活动咨询',value: '2',RNchecked:false},
    {label: '推荐朋友',value: '3',RNchecked:false}, {label: '代理咨询',value: '4',RNchecked:false},{label: '回电给我',value: '5',RNchecked:false},
    {label: '旅游咨询',value: '6',RNchecked:false},{label: '其他',value: '7',RNchecked:false},];

export default class VipFeedback extends BaseComponent {

    static navigationOptions = {
        title: 'VIP反馈通道',
    };

    _onSelect = ( item ) => {
        console.log('选中了:'+JSON.stringify(item));
        this.setState({selected:item})
    };

    constructor(props) {
        super(props)
        this.state = {
            //问题描述
            text:'',
            animating:false,
            //固定值
            suggestType:5,
            //除掉 其他 的选项选中与否
            selected:null,
            //提交成功(提交成功后显示提交成功图标)
            submitSuccess:false
        }

        this.renderQuestionDes = this.renderQuestionDes.bind(this)
        this.loginName = global.loginName
        this._initMockData()
    }

    _initMockData() {
        //重置每项未选中
        mockData.map((item) => {
            console.log('反馈界面221:'+item)
            item.RNchecked = false
        })
    }

    _queryProgress(){
        this.props.navigation.navigate('VipFeedbackProgress')
    }

    //点击了编辑框
    _click_text_input() {
        if(this.text_input.isFocused()) {
            this.text_input.blur()
        }
        setTimeout(()=>{
            this.text_input.focus()
        },200)
    }

    _submitSuggest() {
        let params = null
        console.log('要提交的参数为:'+JSON.stringify(params))
        //当其他被选中，则提交时必须有内容
        if(this.state.selected && this.state.selected.value == '7') {
            if(this.state.text.trim().length == 0) {
                Toast.info('请填写您的问题',2)
                return
            }
            params ={'suggestType':'5','content':this.state.text,'loginName':this.loginName}
        }else{
            if(this.state.selected) {
                params ={'suggestType':'5','content':this.state.selected.label,'loginName':this.loginName}
            }
        }
        this.setState({animating:true})
        SuggestBusiness.createSuggest(params).then(result=>{
            this.setState({animating:false})
            console.log('创建vip建议成功:'+result)
            if(result.errCode) {
                this.setState({
                    submitSuccess:false
                })
                if(result.errCode == 'GW_802406') {
                    Toast.info('您目前有待处理提案，无法提交新提案', 2);
                }else{
                    Toast.info(result.errMsg, 2);
                }
            }else{
                this.setState({
                    submitSuccess:true
                })
                Toast.info('反馈问题提交成功',2)
            }
        }).catch(error=>{
            this.setState({animating:false})
            console.log('创建vip建议错误:'+JSON.stringify(error))
            this.setState({
                submitSuccess:false
            })
            if(error.errCode) {
                Toast.info(error.errMsg, 2);
            }
        })
    }

    renderQuestionDes() {
        //选中其他
        if(this.state.selected && this.state.selected.value == '7') {
            return(
                <View>
                    <Text style={{  color:'#000000',marginBottom:15,fontSize:15 }}>问题描述</Text>
                    <TouchableWithoutFeedback
                        onPress={this._click_text_input.bind(this)}>
                        <View style={{height: Constant.kScreenHeight*1/4, marginRight:10,paddingTop: 0,backgroundColor:'white'}}>
                            <TextInput
                                ref={(ref)=>{
                                    this.text_input = ref
                                }}
                                style={{color:'black'}}
                                onChangeText={(text) => this.setState({text})}
                                multiline={true}
                                placeholderTextColor = {'#9d9d9d'}
                                placeholder="说说我的问题..."
                                editable = {true}
                                maxLength = {200}/>
                        </View>
                    </TouchableWithoutFeedback>
                </View>
            )
        }else{
            return null
        }
    }

    renderSubmitButton() {
         if(this.state.selected) {
             return(
                 <TouchableOpacity
                     onPress={this._submitSuggest.bind(this)}
                     style={{backgroundColor:'rgb(255,170,21)',height:48,alignItems:'center',justifyContent:'center',marginTop:15,borderRadius:8,marginLeft: 20,marginRight: 20}}
                 >
                     <Text style={{color:'white',fontSize:18}} >提交</Text>
                 </TouchableOpacity>
             )
         }else {
             return(
                 <View
                     style={{backgroundColor:'rgb(157,157,157)',height:48,alignItems:'center',justifyContent:'center',marginTop:15,borderRadius:8,marginLeft: 20,marginRight: 20}}
                 >
                     <Text style={{color:'white',fontSize:18}} >提交</Text>
                 </View>
             )
         }
    }

    renderFeedbackUi() {
        return (
                <ScrollView style = {{backgroundColor:'rgb(243,243,243)',flex:1}} ref={component => this._scrollView=component} scrollEnabled={false}
                            keyboardShouldPersistTaps='always'>
                    <View style={{  paddingTop: 20 ,paddingLeft: 20,flexDirection:'column' }} >
                        <Text style={{  color:'#000000',marginBottom:10,fontSize:15 }}>选择您要反馈的问题</Text>
                        <CheckboxForm
                            dataSource={mockData}
                            itemShowKey="label"
                            itemCheckedKey="RNchecked"
                            iconSize={16}
                            formHorizontal={true}
                            labelHorizontal={true}
                            onChecked={(item) => this._onSelect(item)}
                        />
                        {this.renderQuestionDes()}
                        <Text style={{  color:'#9d9d9d',marginTop:10 }}>* 提交后，VIP客服经理24小时内会尽快回复您</Text>

                    </View>
                    {this.renderSubmitButton()}

                    <TouchableWithoutFeedback
                        onPress={this._queryProgress.bind(this)}
                    >
                        <Text style={{ height:30, color:'#007aff',marginBottom:20,marginTop:10,alignSelf: 'center' }}>查看我的反馈 ></Text>
                    </TouchableWithoutFeedback>
                </ScrollView>
            )
    }

    renderFeedbackSuccess() {
        return (
            <VipFeedbackSuccess
                queryProgress={this._queryProgress.bind(this)}/>
        )
    }

    render(){
        if(this.state.submitSuccess) {
            return(
                this.renderFeedbackSuccess()
            )
        }else{
            return(
                <View style={styles.container}>
                    <ActivityIndicator
                        ref={(ref) => this.activityIndicator = ref}
                        animating={this.state.animating}
                        toast
                        size="large"
                        text="Loading..."
                    />
                    {this.renderFeedbackUi()}
                </View>

            )
        }
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
        paddingTop:25,
    },
    msg_container:{

    },
    vip_feedback_img:{
        width:15,
        height:15,
    },
    vip_feedback_txt:{
        marginLeft:10,
        flex:1,
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