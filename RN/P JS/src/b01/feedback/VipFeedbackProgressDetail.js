import React,{ Component } from "react";
import {
    StyleSheet,
    View,
    Text,
    Image,
} from 'react-native';
import BaseComponent from "../../platform/page/BaseComponent";
import {ActivityIndicator} from "@ant-design/react-native";
export default class VipFeedbackProgressDetail extends BaseComponent {

    static navigationOptions = {
        title: '我的问题处理进度',
    };

    constructor(props) {
        super(props)
        this.state={
            data:''
        }
        this.renderRightChat = this.renderRightChat.bind(this)
        this.renderLeftChat = this.renderLeftChat.bind(this)
    }

    componentDidMount() {
        super.componentDidMount()
        let item = this.props.navigation.getParam("item");
        console.log('获取的详情为:'+JSON.stringify(item))
        this.setState({
            data:item
        })
    }

    //客服回复的内容
    renderLeftChat() {
        if(this.state.data.remarks) {
            return(
                <View style={styles.item}>
                    <Text style={styles.item_date}>{this.state.data.lastUpdate}</Text>
                    <View
                        style={styles.content_left_container}>
                        <View
                            style={{flexDirection:'column',justifyContent: 'flex-end'}}>
                            <Image
                                style={styles.left_img}
                                source={require('../../../res/image/logo.png')}/>
                        </View>

                        <Text
                            selectable={true}
                            style={styles.content_left_text}
                        >
                            {this.state.data.remarks}
                        </Text>
                    </View>
                </View>
            )
        }else{
            return null
        }
    }

    //客户提的问题
    renderRightChat() {
        return(
            <View style={styles.item}>
                <Text style={styles.item_date}>{this.state.data.createdDate}</Text>
                <View
                    style={styles.content_right_container}>
                    <Text
                        selectable={true}
                        style={styles.content_right_text}
                    >
                        {this.state.data.content}
                    </Text>
                    <View
                        style={{flexDirection:'column',justifyContent: 'flex-end'}}>
                        <Image
                            style={styles.right_img}
                            source={require('../../../res/image/icon_user.png')}/>
                    </View>
                </View>
            </View>
        )
    }

    render(){
        return(
            <View style={{flexDirection:'column',backgroundColor:'#f2f2f2',flex:1}}>
                {this.renderRightChat()}
                {this.renderLeftChat()}
            </View>
        )
    }



}

const styles = StyleSheet.create({

    item:{
        flexDirection: 'column',
        marginTop:20,
    },
    item_date:{
        color:'#9d9d9d',
        alignSelf:'center',
    },
    touch_container:{
        flexDirection: 'row',
    },
    date_container:{
        alignSelf: 'center',
        marginTop: 15
    },
    date:{
        alignSelf: 'center',
        color:'rgb(162,162,162)',
        marginTop: 10
    },
    right_img:{
        width:40,
        height:40,
        marginLeft:8,
        alignSelf:'baseline',
    },
    left_img:{
        width:40,
        height:40,
        marginRight: 8,
        alignSelf:'baseline',
    },
    content_left_container:{
        flexDirection: 'row',
        justifyContent: 'flex-start',
        marginLeft: 8,
        marginTop: 15
    },
    content_right_container:{
        flexDirection: 'row',
        justifyContent: 'flex-end',
        marginTop: 15,
        marginRight: 8,
    },
    //这个 是图片背景的style
    content:{
        marginLeft: 10,
        paddingHorizontal:5,
        paddingVertical:8,
        marginRight: 80,
        borderRadius:4,
    },
    content_left_text:{
        color:'rgb(51,52,51)',
        padding:8,
        backgroundColor:'rgb(255,255,255)',
        marginRight: 80,
    },
    content_right_text:{
        color:'rgb(51,52,51)',
        padding:8,
        backgroundColor:'rgb(255,255,255)',
        marginLeft:80,

    },

    bubbleStyle:{
        width:100,
        flexDirection:'row',
        marginTop:-40,
        alignSelf: 'center',
        justifyContent:'center',
        alignItems:'center',
        paddingTop:10,
        paddingBottom:15,
    },

    item_container: {
        flexDirection: 'column',
        justifyContent: 'space-between',
    },

    container: {
        flex:1,
        flexDirection: 'column',
        backgroundColor: 'rgb(243, 243, 242)',
        paddingBottom: 15,
    },

    row: {
        flexDirection: 'row',
        justifyContent: 'space-between',
    },
    backdrop: {
    },
    menuOptions: {
        padding: 50,
    },
    menuTrigger: {
        padding: 5,
    },
    triggerText: {
        fontSize: 20,
    },
    contentText: {
        fontSize: 18,
    },

})