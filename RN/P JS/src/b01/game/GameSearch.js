import React, {Component} from 'react';
import {
    Platform,
    StyleSheet,
    Text,
    View,
    TextInput,
    SectionList,
    Image,
    TouchableWithoutFeedback,
    DeviceEventEmitter,
    NativeModules, ActivityIndicator, StatusBar, ImageBackground
} from 'react-native';
import {httpPost} from '../../platform/network/NPHttpManager'
import Constant, {ifIphoneX} from "../../../src/platform/common/Constant"
import GameSearchCell from "./view/GameSearchCell"
import store from "react-native-simple-store";

let pageNo = 1;//当前第几页
let totalPage=1;//总的页数

export default class GameSearch extends Component{

    constructor(props) {
        super(props);
        // this.search = this.search.bind(this)
        this.state={
            resultJson:[],
            historyList:[],
            searchKey:'',
            loginName:'',
            showFoot:0, // 控制foot， 0：隐藏footer  1：已加载完成,没有更多数据   2 ：显示加载中
        };
    }

    static navigationOptions = ({navigation}) => {
        let {goBack} = navigation;
        const headerBackground = (<View style={styles.navContainer}></View>)

        const headerTitle = (
            <View  style={styles.searchBox}>
                <Image
                    style={styles.seachIcon}
                    source={ require('../../../res/image/icon_seach_min.png')}
                />
                <TextInput
                    style={styles.searchInput}
                    clearButtonMode='always'
                    ref={ref=>this.txRef=ref}
                    onChangeText={(text) => navigation.setParams({searchKey: text})}
                    value={navigation.state.params.searchKey}
                />
            </View>

        )
        const headerLeft = (
            <TouchableWithoutFeedback
                onPress={() =>{
                    goBack()
                }}>
                <Image
                    style={styles.leftItem}
                    source={ require('../../../res/image/Backarrow.png')}
                />
            </TouchableWithoutFeedback>
        )
        const headerRight =(
            <TouchableWithoutFeedback
                onPress={() =>{
                    if (navigation.state.params.searchKey.length==0) return;
                    DeviceEventEmitter.emit('gameSearch',navigation.state.params.searchKey);
                }}>
                <Text style={styles.rightItem} >搜索</Text>
            </TouchableWithoutFeedback>
        )

        const headerTitleStyle = styles.navHeader;
        return {headerBackground,headerTitle,headerRight,headerTitleStyle,headerLeft}
    };


    componentDidMount(){

        NativeModules.BridgeModel.getInitDataFromNative((result) => {
            this.state.loginName = JSON.parse(result).loginName;
        });

        //加载历史记录
        this.loadHistory();

        DeviceEventEmitter.addListener('gameSearch',(key)=>{
            pageNo = 1;
            this.setState({resultJson:[]});
            this.requestGuery(key);
        });

    }

    requestGuery(key){
        this.setState({searchKey:key});
        this.addHistory(key);
        httpPost('game/queryGameList',{gameName:key,pageNo:pageNo},(json)=>{
            console.log(json);
            totalPage = json.totalPage;
            let foot = 0;
            if(pageNo>=totalPage){
                foot = 1;//listView底部显示没有更多数据了
            }

            let dataArr = this.state.resultJson.concat(json.data);
            // alert(JSON.stringify(dataArr));
            this.setState({resultJson:dataArr,showFoot:foot,});

        });
    }

    loadHistory(){
        store.get('searchHistoryList')
            .then((res) => {
                if (res!=null){
                    this.setState({historyList:res});
                }
            })
    }

    addHistory(key){
        if (key.length==0) return;

        let tmpArr = [key];
        if (this.state.historyList !=null){
            let j=0;
            for(let i=0;i<this.state.historyList.length;i++){
                if (i<6 && key!=this.state.historyList[i]){
                    tmpArr[j+1] = this.state.historyList[i];
                    j++;
                }
            }
        }
        this.state.historyList = tmpArr;
        store.save("searchHistoryList",this.state.historyList);
    }

    clickHistoryItem(obj){
        this.props.navigation.navigate('GameSearch', {searchKey: obj.item});
        pageNo = 1;
        this.setState({resultJson:[]});
        this.requestGuery(obj.item);
    }

    //分页加载
    _renderFooter(){
        if (this.state.showFoot === 1) {
            let nomoreText = this.state.resultJson.length>20?'没有更多数据了':''
            return (
                <View style={{height:30,alignItems:'center',justifyContent:'flex-start',marginTop:5}}>
                    <Text style={{color:'#999999',fontSize:14,marginTop:5,marginBottom:5,}}>
                        {nomoreText}
                    </Text>
                </View>
            );
        } else if(this.state.showFoot === 2) {
            return (
                <View style={styles.footer}>
                    <ActivityIndicator />
                    <Text style={{color:'black'}}>正在加载更多...</Text>
                </View>
            );
        } else if(this.state.showFoot === 0){
            return (
                <View style={styles.footer}>
                    <Text></Text>
                </View>
            );
        }
    }

    _onEndReached(){
        if (this.state.searchKey!=''){

            //如果是正在加载中或没有更多数据了，则返回
            if(this.state.showFoot != 0 ){
                return ;
            }
            //如果当前页大于或等于总页数，那就是到最后一页了，返回
            if((pageNo!=1) && (pageNo>=totalPage)){
                return;
            } else {
                pageNo++;
            }
            //底部显示正在加载更多数据
            this.setState({showFoot:2});
            //获取数据
            this.requestGuery( this.state.searchKey );

        }
    }

    render() {
        let dataArr = [];
        if (this.state.searchKey==''){
            dataArr = [{ title: "", data:this.state.historyList },]
        } else {
            dataArr = [{ title: "", data:this.state.resultJson },]
        }

        return (
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


                <SectionList
                    renderItem={({item, index, section }) => {
                        if (this.state.searchKey==''){
                            return <Text style={styles.historyItem} onPress={()=>this.clickHistoryItem({item})}>{item}</Text>
                        } else {
                           return <GameSearchCell key={index} rowData={item} loginName={this.state.loginName} onPress={()=> {
                               if (Platform.OS === 'ios') {
                                   NativeModules.BridgeModel.openGameVC(item);
                               } else {
                                   NativeModules.BridgeModel.openGameVC(JSON.stringify(item));
                               }
                           }
                           } />
                        }
                    }}
                    renderSectionHeader={() => {

                        if (this.state.searchKey==''){
                            return <Text style={styles.sectionHeader}>历史记录</Text>
                        } else {
                            if (this.state.resultJson.length>0){
                                return <Text style={styles.sectionHeader}>{this.state.resultJson.length}个结果</Text>
                            }else {
                                if (this.state.searchKey.length>0){
                                    return  <Text style={[styles.sectionHeader,{paddingTop: 30,textAlign: 'center',marginLeft: 0}]}>该游戏不存在，请尝试其他关键词</Text>
                                }else {
                                    return  <Text></Text>
                                }
                            }
                        }
                    }}

                    sections={dataArr}
                    ListFooterComponent={this._renderFooter.bind(this)}
                    onEndReached={this._onEndReached.bind(this)}
                    onEndReachedThreshold={1}

                    keyExtractor={(item, index) => item + index}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        // paddingTop: 22
    },
    sectionHeader: {
        paddingTop: 10,
        paddingBottom:5,
        marginLeft: 40,
        fontSize: 14,
        color:'gray',
        width: Constant.kScreenWidth,
        backgroundColor: 'white',
    },

    //navbar
    navContainer: {
        flex: 1,
        height:ifIphoneX(88,64,70),

    },
    navHeader:{
        flex:1,
        textAlign: 'center',
        color:'#fff',
        fontSize: 20,
        fontWeight:'normal',
    },
    rightItem: {
        marginRight:16,
        color: '#ff8400',
        fontSize:15,
        marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)

    },
    leftItem: {
        marginLeft:16,
        tintColor: '#ff8400',
        marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)
    },
    searchBox: {
        height: 30,
        width: Constant.kScreenWidth - 60,
        backgroundColor:'#f2f2f2',
        borderRadius: 20,
        flex:1,
        flexDirection:'row',
        alignItems:'center',
        paddingLeft: 8,
        marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)
    },
    searchInput: {
        height: 40,
        width: Constant.kScreenWidth - 170,
        color:'black',
        marginLeft: 4,

    },
    seachIcon: {
        // justifyContent:'center',
        // alignItems:'center',

    },
    historyItem: {
        marginLeft: 40,
        height:40,
        width:Constant.kScreenWidth,
        fontSize: 18,
        lineHeight: 40,
        color:'rgb(256,132,0)',
    },
    footer:{
        flexDirection:'row',
        height:24,
        justifyContent:'center',
        alignItems:'center',
        marginBottom:10,
        marginTop:5,
    },
})