import React,{ Component } from "react";
import {StatusBar, StyleSheet, View, Text, AsyncStorage, ToastAndroid, FlatList, BackHandler} from 'react-native';
import NewsEmpty from './NewsEmpty'
import {httpPost} from "../../platform/network/NPHttpManager";
import { ActivityIndicator } from '@ant-design/react-native';
import BaseComponent from "../../platform/page/BaseComponent";

export default class Announce extends BaseComponent {

    constructor(props) {
        super(props)
        this.state={
            data:null,
            animating:true,
        }
        this._renderItem = this._renderItem.bind(this)
    }

    static navigationOptions = {
        title: '公告',
        headerRight:<View/>,

    };

    componentDidMount() {
        super.componentDidMount()
        this.loginName = global.loginName
        this._getAnnounce()
        // this._getLoginName()
    }

    _getAnnounce() {
        let subUrl = 'message/queryAnnounces'
        // let params = {loginName:this.loginName,productId:"B01"}
        let params = {loginName:this.loginName}

        //第二个参数是个对象
        httpPost(subUrl,params,(json)=>{
            console.log('打印公告详情界面成功结果为::'+JSON.stringify(json))
            if(json) {
                //最近的数据在最上面，界面要求最近的数据在最下面，所以要做个倒序排列
                let sucData = json.reverse()
                this.setState({
                    data:sucData,
                    animating:false,
                })
            }else {
                this.setState({
                    data:null,
                    animating:false,
                })
            }
        });
    }

    // "1-网站公告;2-每日黄金评论;3-每周黄金评论;4-每日外汇评论;5-每周外汇评论;6-新闻;7-会员公告;8-备用域名公告;9-手机公告",
    _getAnnounceType(type) {
        if(type == 1){
            return '网站公告'
        }
        if(type == 2){
            return '每日黄金评论'
        }
        if(type == 3){
            return '每周黄金评论'
        }
        if(type == 4){
            return '每日外汇评论'
        }
        if(type == 5){
            return '每周外汇评论'
        }
        if(type == 6){
            return '新闻'
        }
        if(type == 7){
            return '会员公告'
        }
        if(type == 8){
            return '备用域名公告'
        }
        if(type == 9){
            return '手机公告'
        }
    }

    _renderItem({item,index}) {
        console.log('每项条目的索引1:'+index)
        let aa = this._getAnnounceType(item.commentType);
        return (<View
            style={ index == 0 ? styles.item0Container:styles.itemContainer}>

            <View style={styles.typeContainer}>
                <Text style={styles.titleFont}>{aa}</Text>
                <Text style={styles.titleFont}>{item.createDate}</Text>
            </View>
            <Text selectable={true} style={styles.content}>{item.content}</Text>
        </View>)
    }

    render(){

        if(!this.state.data) {
            // return <NewsEmpty/>
            console.log('刚开始data为null')
            return <ActivityIndicator
                ref={(ref) => this.activityIndicator = ref}
                animating={this.state.animating}
                toast
                size="large"
                text="Loading..."
            />
        }else{
            if(this.state.data && this.state.data.length == 0) {
                return <NewsEmpty
                        title='公告'/>
            }

            return(
                <View
                    style={styles.container}>



                    <FlatList
                        data={this.state.data}
                        renderItem={this._renderItem}
                        keyExtractor={(item) => item.id}
                    />
                </View>
            )
        }

    }

}

const styles = StyleSheet.create({

    container:{
        flex:1,
        backgroundColor:'#f3f3f2',
    },
    item0Container:{
        flexDirection: 'column',
        marginTop:20,
        marginBottom:20,
        marginLeft:10,
        marginRight:10,
        backgroundColor: '#fff',
        padding: 13,
        borderWidth:0.2,
        borderColor:'#d2d2d2',
    },
    itemContainer:{
        flexDirection: 'column',
        marginBottom:20,
        marginLeft:10,
        marginRight:10,
        backgroundColor: '#fff',
        padding: 13,
        borderWidth:0.2,
        borderColor:'#d2d2d2',
    },

    typeContainer:{
        flexDirection: 'row',
        justifyContent: 'space-between',

    },

    titleFont:{
        color:'#9d9d9d'
    },
    content:{
        color:'#333333',
        marginTop:8,
    },

})