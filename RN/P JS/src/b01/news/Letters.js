import React,{ Component } from "react";
import {
    BackHandler,
    RefreshControl,
    Clipboard,
    StyleSheet,
    View,
    Text,
    Image,
    ToastAndroid,
    FlatList,
    ImageBackground,
    TouchableOpacity,
    DeviceEventEmitter,
    AsyncStorage, StatusBar, Platform, NativeModules
} from 'react-native';
import NewsEmpty from './NewsEmpty'
import NewsDeleteDialogModal from '../widget/NewsDeleteDialogModal'
import SureDeleteDialogModal from '../widget/SureDeleteDialogModal'
import {httpPost} from "../../platform/network/NPHttpManager";
import { ActivityIndicator,Toast } from '@ant-design/react-native';
import {ifIphoneX} from "../../platform/common/Constant";
import BaseComponent from "../../platform/page/BaseComponent";
export default class Letters extends BaseComponent {

    static navigationOptions = ({navigation}) =>{

        return {
            title: '站内信',
            headerRight:
                <TouchableOpacity
                    onPress={() =>{
                        DeviceEventEmitter.emit('closeDialog')
                    }}>
                    <Image
                        style={{ height:35,width:35,marginRight:10,marginTop:ifIphoneX(10,10,20)}}
                        source={ require('../../../res/image/icon_more.png')}/>
                </TouchableOpacity>,
            headerLeft:
                <TouchableOpacity
                    style={{width:40,marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)}}
                    onPress={() =>{
                        if(global.to == 'letter') {
                            NativeModules.BridgeModel.closeRn("news");
                        }else{
                            navigation.goBack()
                        }
                    }}>
                    <Image
                        style={{marginLeft:10}}
                        source={ require('../../../res/image/Backarrow.png')}
                    />
                </TouchableOpacity>,
        }
    };

    constructor(props) {
        super(props)
        // this._showDialog = this._showDialog.bind(this)
        // this.onItemLongPressNew = this.onItemLongPressNew.bind(this)
        // this.onIteLongPress = this.onIteLongPress.bind(this)
        //非常关键，不加的话，条目里面的点击事件里获取不到this
        this._renderDeleteItem = this._renderDeleteItem.bind(this);
        this.state={
            data:null,
            modalVisible:false,
            refreshing: false,
            animating:true,
        }
        this.page = 1
        //保存所有的数据id
        this.idAllArray = []

    }

    _getNews() {

        let subUrl = 'letter/query'
        // let pageNew = this.state.page
        console.log('发起的请求前loginName为::'+this.loginName)
        console.log('发起的请求前123为::'+this.page)
        // let params = {loginName:this.loginName,pageNo:this.page,productId:"B01",pageSize:20}
        let params = {loginName:this.loginName,pageNo:this.page,pageSize:20,type:[1,3]}
        console.log('发起的请求为::'+JSON.stringify(params))
        //第二个参数是个对象
        httpPost(subUrl,params,(json)=>{
            console.log('打印消息详情成功结果2为::'+JSON.stringify(json))
            this.setState({
                animating:false,
            })

            if(json.data) {
                //代表返回了数据
                if(json.data.length != 0) {
                    //最近的数据在最上面，界面要求最近的数据在最下面，所以要做个倒序排列
                    let sucData = json.data.reverse()
                    let newData = []
                    //当state里面的数据不为空的时候，代表里面要么有数据，要么为空数组，为空代表当前正在loading
                    if(this.state.data) {
                        newData = sucData.concat(this.state.data)
                    }else{
                        newData = sucData
                    }
                    console.log('打印消息详情成功结果3为::'+JSON.stringify(newData))

                    this.setState({
                        data:newData,
                        animating:false,
                    })
                    this.moreData = true


                    let idArray = this._getIdArray(sucData)
                    this._getAllId(sucData)
                    if(idArray.length != 0) {
                        //获取到数据后，还要发请求通知将这些数据设为已读
                        this._setRead(idArray)
                    }else{
                        console.log('这几条消息都已读了')
                    }

                    if(this.page == 1) {
                        setTimeout(()=>{
                            //Android有时滚动不到底部，要考虑下getItemLayout设置的高度
                            this._flatList.scrollToEnd()
                        },200)
                    }

                }
                //代表返回的data是空数组
                else{
                    //当是第一次拉取数据时，如果没有数据，则赋值为空数组
                    if(this.page == 1) {
                        this.setState({
                            data:[],
                            animating:false,
                        })
                        this.moreData = false
                    }
                    //当已经不是第一次拉数据了，证明之前有数据，此时新的请求如果没数据的话，则data不做任何操作
                    else{
                        this.setState({
                            animating:false,
                        })
                        Toast.info('没有更多数据了', 2);
                        this.moreData = false
                    }
                }
            }
        });
    }

    _getIdArray(array) {
        let idArray = []
        for(item of array) {
            console.log(item.id)
            //当此条消息未读时，才将其加入准备已读数组
            if(item.flag == 0) {
                idArray.push(item.id)
            }
        }
        return idArray
    }

    //得到所有的id,每有新数据就将其id加入
    _getAllId(array) {
        for(item of array) {
            //当此条消息未读时，才将其加入准备已读数组
            this.idAllArray.push(item.id)
        }
    }


    //发请求将数据设为已读
    _setRead(idArray) {
        let subUrl = 'letter/batchViewLetter'
        // let params = {loginName:this.loginName,ids:idArray,"productId": "B01"}
        let params = {loginName:this.loginName,ids:idArray}
        // let subUrl = 'letter/query'
        // let params = {loginName:"kb013test",pageNo:1,productId:"B01",pageSize:3}

        console.log('发起的设为3已读请求:'+JSON.stringify(params))
        //第二个参数是个对象
        httpPost(subUrl,params,(json)=>{
            console.log('设为已读成功后::'+JSON.stringify(json))
        });
    }

    _setDelete(idArray) {
        let subUrl = 'letter/delete'
        // let params = {loginName:this.loginName,ids:idArray,"productId": "B01"}
        let params = {loginName:this.loginName,ids:idArray}
        console.log('发起的删除站内信:'+JSON.stringify(params))
        this.setState({ animating: true });
        //第二个参数是个对象
        httpPost(subUrl,params,(json)=>{
            this.setState({ animating: false });
            console.log('删除站内信成功后::'+JSON.stringify(json))
            Toast.info('已成功删除', 2)
            //删除成功后，应该重新获取上一页的数据，如果有就展示，没用展示空view
            this.page = 1
            this._getNews()
        });
    }

    onIteLongPress(selectedItem) {
        let arry3=[];
        this.state.data.map(((item, index)=> {
            console.log('索引数据1为:'+item)
            console.log('索引数据2为:'+JSON.stringify(item))
            console.log('索引数据为:'+index)
            if(item.id == selectedItem.id){
                //临时改为，以后可能改回
                // arry3.push(Object.assign({},item,{select:true}))
                arry3.push(Object.assign({},item,{select:false}))
            }else{
                arry3.push(Object.assign({},item,{select:false}))
            }
        }))
        console.log('新数据为:'+JSON.stringify(arry3))
        this.setState({
            data:arry3
        })

        this.selectedItem = selectedItem
        console.log('选中的数据为:'+this.selectedItem.content)
    }


    _renderDeleteItem({item}) {
        return(<View
            style={styles.item_container}>
             <Text style={styles.date}>{item.createDate}</Text>

            { item.select ? <ImageBackground
                style={styles.bubbleStyle}
                source={require('../../../res/image/icon_copy_delete.png')}>
                <Text onPress={()=>{
                    this._copyContent()
                }
                }>复制</Text>
                <Text onPress={()=>{
                    this._deleteItem()
                    }
                }>删除</Text>
            </ImageBackground> : null}

            <View
                style={styles.content_container}>
                    <View
                        style={{flexDirection:'column',justifyContent: 'flex-end'}}>
                        <Image
                            style={styles.img}
                            source={item.imgUrl ? {uri: item.imgUrl} : require('../../../res/image/logo.png')}/>
                    </View>

                    <Text
                        selectable={true}
                        style={styles.content_text}
                    >
                        {item.content}
                    </Text>
            </View>


        </View>)
    }

    componentDidMount() {
        super.componentDidMount()
        //用箭头函数可以改变this的作用域
        this.listener =DeviceEventEmitter.addListener('closeDialog',()=>{

            console.log('站内信dfefe1'+this.state.data)
            if(this.dialog) {
                this.dialog.show();
            }
        });

        this.loginName = global.loginName
        this._getNews(1)
        // this._setRead()
    }

    //点击外部还原数据(就会将气泡消失掉)
    _restoreData() {
        let arry4=[];
        this.state.data.map(((item, index)=> {
            arry4.push(Object.assign({},item,{select:false}))

        }))
        console.log('点击外部还原数据为:'+JSON.stringify(arry4))
        this.setState({
            data:arry4
        })
    }

    onBackButtonPressAndroid = () => {
        if(global.to == 'letter') {
            NativeModules.BridgeModel.closeRn("news");
        }else{
            if(this.state.animating) {
                this.setState({ animating: false });
                return true
            }else {
                return false;
            }
        }
    };

    //复制
    _copyContent() {
        Clipboard.setString(this.selectedItem.content);
    }
    //删除该项
    _deleteItem() {
        let arry5=[];
        this.state.data.map(((item, index)=> {
            if(item.id == this.selectedItem.id) {
                arry5.splice(index,1);
            }else{
                arry5.push(Object.assign({},item,{select:false}))
            }
        }))
        console.log('删除某项数据后:'+JSON.stringify(arry5))
        this.setState({
            data:arry5
        })
    }


    _cancel() {
        console.log('取消对话框')
    }

    _confirmDelete() {
        console.log('确认对话框')
        this.setState({
            data:null
        })
        this._setDelete(this.idAllArray)
    }

    _deleteAll() {
        console.log('展示删除对话1111111111框')
        if(this.dialog) {
            this.dialog.dismiss()
        }
        if(this.state.data) {
            if(this.state.data.length != 0){
                if(this.sureDialog) {
                    console.log('展示删除对话框')
                    this.sureDialog.show()
                }else{
                    console.log('不展示删除对话框')
                }
            }else{
                Toast.info('没有可删除的站内信', 2)
            }
        }
    }

    _onRefresh() {
        //如果有更多数据，则page可以加1，继续请求新的数据
        if(this.moreData) {
            this.page++
        }
        console.log('下拉后的页面为:'+this.page)
        this._getNews()
    }

    render(){

        //当数据是null的时候，代表已发起了请求，但数据还没返回，此时显示loading
        if(!this.state.data) {
           /* return (<View>
                <NewsDeleteDialogModal
                    selectItem={()=> {console.log("选择了1:")}}
                    ref={ref=>this.dialog=ref}
                />

                <NewsEmpty/>
                <SureDeleteDialogModal
                    selectItem={()=> {console.log("选择了23删除对话框:")}}
                    ref={ref=>this.sureDialog=ref}
                />
                <Toast ref="toast" position={'center'} />
            </View>)*/
           return(
                    <ActivityIndicator
                        ref={(ref) => this.activityIndicator = ref}
                        animating={this.state.animating}
                        toast
                        size="large"
                        text="Loading..."
                    />
                )

        }else{
            //当数据不为null，代表请求已经返回，只是数据为空，此时loading消失，展示空盒子
            if(this.state.data && this.state.data.length == 0) {
                return <View style={{flex: 1}}>
                        <NewsEmpty
                            title = '消息'/>
                        <NewsDeleteDialogModal
                            selectItem={()=> {this._deleteAll()}}
                            ref={ref=>this.dialog=ref}
                        />
                    </View>

            }

            return(
                /*<TouchableOpacity
                    onPress={()=>{
                        this._restoreData()
                    }}
                >*/
                    <View
                        style={styles.container}>
                        <View
                            style={{position:'absolute'}}>
                            <NewsDeleteDialogModal
                                selectItem={()=> {this._deleteAll()}}
                                ref={ref=>this.dialog=ref}
                            />
                            <SureDeleteDialogModal
                                sure={()=> {
                                    console.log("选择了删除234345对话框:")
                                    //确认删除全部
                                    this._confirmDelete()
                                }}
                                ref={ref=>this.sureDialog=ref}
                            />
                        </View>
                        <FlatList
                            ref={(flatList)=>this._flatList = flatList}
                            data={this.state.data}
                            renderItem={this._renderDeleteItem}
                            keyExtractor={(item) => item.id}
                            extraData={this.state}
                            getItemLayout={(data, index) =>
                                // 90 是被渲染 item 的高度 ITEM_HEIGHT。
                                ({ length: 120, offset: 120 * index, index })
                            }
                            refreshControl={
                                <RefreshControl
                                    refreshing={this.state.refreshing}
                                    onRefresh={this._onRefresh.bind(this)}
                                />}
                        />
                    </View>
                /*</TouchableOpacity>*/

            )
        }


    }

}

const styles = StyleSheet.create({

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
    img:{
        width:40,
        height:40,
        marginLeft: 6,
        alignSelf:'baseline',
    },
    content_container:{
        flexDirection: 'row',
        justifyContent: 'flex-start',
        marginLeft: 8,
        marginTop: 15
    },
    //这个 是图片背景的style
    content:{
        marginLeft: 10,
        paddingHorizontal:5,
        paddingVertical:8,
        marginRight: 80,
        borderRadius:4,
    },
    content_text:{
        color:'rgb(51,52,51)',
        marginLeft: 10,
        padding:8,
        marginRight: 80,
        backgroundColor:'rgb(255,255,255)'
    },
    copy_dialog:{
        backgroundColor:'#ffeebb'
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