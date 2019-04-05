import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    ActivityIndicator,
    TouchableOpacity,
    DeviceEventEmitter,
    Image,
    NativeModules,
    Platform,
    StatusBar,
} from 'react-native';
import {httpPost} from '../../platform/network/NPHttpManager'
import Constant, {ifIphoneX} from "../../../src/platform/common/Constant"
import carousel from "./view/Carousel"
import FilterHeader from "./view/FilterHeader"
import GameCell from "./view/GameCell"
import GameSearch from "./GameSearch"
import {SectionGrid } from 'react-native-super-grid';
import {Provider,Modal} from '@ant-design/react-native';
import Picker from 'react-native-wheel-picker'


var PickerItem = Picker.Item;

let pageNo = 1;//当前第几页
let totalPage=1;//总的页数
var globeParam = {};

export default class GameHall extends Component{

    static navigationOptions = ({navigation}) =>{
        return {
            title: '电游大厅',
            headerLeft:
                <TouchableOpacity
                    onPress={() =>{
                        console.log('点击了首页返回2')
                        let from = navigation.getParam("from");
                        //如果是从电子游戏教程界面过来，则返回到电子游戏教程界面
                        if(from == 'course') {
                            navigation.navigate('CourseDetail')
                        }else{
                            DeviceEventEmitter.emit('closeRn')
                        }
                    }}>
                    <Image
                        style={{marginLeft:10,marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)}}
                        source={ require('../../../res/image/Backarrow.png')}
                    />
                </TouchableOpacity>,
        }
    };


    constructor(props){
        super(props);
        this.state={
            resultJson:[],
            popvisible: false,
            sel1:0,
            sel2:0,
            sel3:0,
            curTab:0,
            showItem : 0,
            selectedItem : 0,
            itemList: [],
            showFoot:0, // 控制foot， 0：隐藏footer  1：已加载完成,没有更多数据   2 ：显示加载中
        };

        this.onCloseModel = () => {
            this.setState({
                popvisible: false,
            });
        }

        this.onPickerSel = () => {

            this.state.selectedItem = this.state.showItem;
            this.setState({resultJson:[]});
            pageNo = 1;

            let params = {};
            if (this.state.curTab==1){

                if (globeParam['hotFlag']){
                    delete globeParam['hotFlag'];
                }
                if (globeParam['newFlag']){
                    delete globeParam['newFlag'];
                }
                if (globeParam['poolFlag']){
                    delete globeParam['poolFlag'];
                }
                if (globeParam['preferenceFlag']){
                    delete globeParam['preferenceFlag'];
                }

                if (this.state.selectedItem==1){
                    params = {hotFlag:1}
                }else if (this.state.selectedItem==2){
                    params = {newFlag:1}
                }else if (this.state.selectedItem==3){
                    params = {poolFlag:1}
                }else if (this.state.selectedItem==4){
                    params = {preferenceFlag:1}
                }

                this.state.sel1 = this.state.selectedItem;

            }else if (this.state.curTab==2){

                if (this.state.selectedItem==0){
                    if (globeParam['platformNames']){
                        delete globeParam['platformNames'];
                    }
                }else {
                    let selItem = this.state.itemList[this.state.selectedItem];
                    selItem = selItem.replace('厅','');
                    params = {platformNames: [selItem]}
                }
                this.state.sel2 = this.state.selectedItem;

            } else if (this.state.curTab==3){
                if (this.state.selectedItem==0){
                    if (globeParam['payLines']){
                        delete globeParam['payLines'];
                    }
                }
                if (this.state.selectedItem==1){
                    params = {payLines:[{low:1,high:4}]}
                }else if (this.state.selectedItem==2){
                    params = {payLines:[{low:5,high:9}]}
                }else if (this.state.selectedItem==3){
                    params = {payLines:[{low:15,high:25}]}
                }else if (this.state.selectedItem==4){
                    params = {payLines:[{low:30,high:50}]}
                }else if (this.state.selectedItem==5){
                    params = {payLines:[{low:51,high:146}]}
                }else if (this.state.selectedItem==6){
                    params = {payLines:[{low:243,high:243}]}
                }else if (this.state.selectedItem==7){
                    params = {payLines:[{low:1024,high:1024}]}
                }

                this.state.sel3 = this.state.selectedItem;

            }

            this.fhRef.setFilterTitle(this.state.curTab,this.state.itemList[this.state.selectedItem]);

            this.requestList(params);

            this.setState({
                popvisible: false,
            });
        };
    }

    closeRn() {
        NativeModules.BridgeModel.closeRn("game");
    }

    componentDidMount(){
        DeviceEventEmitter.addListener('closeRn',()=>{
            //关闭RN界面
            this.closeRn("game")
        });

        globeParam = {};
        NativeModules.BridgeModel.getInitDataFromNative((result) => {
            let loginName = JSON.parse(result).loginName;
            globeParam['loginName']= loginName;
        });

        this.requestList({});
    }

    requestList(param){

        param['pageNo'] = pageNo;

        let reqParams = {};
        Object.assign(globeParam,param);
        Object.assign(reqParams,globeParam,param);
        httpPost('game/queryGameList',reqParams,(json)=>{
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

    dataPickerAction(index) {

        let data = [];
        if (index==1){
            data = ['所有类型','热门游戏','最新游戏','彩金池游戏','特惠游戏'];
            this.showPicker(1,data,this.state.sel1);
        }else if (index==2){
            httpPost('_extra_/b01/queryByKeyList',{keys:['gamePlatforms']},(responseJson)=>{
                data = responseJson.gamePlatforms.split(',').map((val,i)=>{
                    return val+'厅';
                });
                let headerArr =['全部平台'];
                data = headerArr.concat(data);
                this.showPicker(2,data,this.state.sel2);
            });
        } else if (index==3){
            data = ['所有赔付线','1-4线','5-9线','15-25线','30-50线','51-146线','243线','1024线'];
            this.showPicker(3,data,this.state.sel3);
        }

    }

    onPickerSelect (index) {
        this.setState({
            showItem: index,
        })
    }

    showPicker(index,data,selIdx){
        this.setState({
            curTab:index,
            itemList:data,
            showItem: selIdx,
            popvisible: true
        })

    }

    //分页加载
    _renderFooter(){
        if (this.state.showFoot === 1) {
            return (
                <View style={{height:30,alignItems:'center',justifyContent:'flex-start',}}>
                    <Text style={{color:'#999999',fontSize:14,marginTop:5,marginBottom:5,}}>
                        没有更多数据了
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
        this.requestList( {pageNo:pageNo} );
    }

    render() {
        return (
            <Provider>
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
                    <SectionGrid
                        itemDimension={(Constant.kScreenWidth - 34) / 2}
                        // spacing={20}
                        ListHeaderComponent={carousel}
                        renderItem={({item, index, section}) => <GameCell key={index} rowData={item} loginName={globeParam['loginName']} onPress={()=>{
                            if (Platform.OS === 'ios') {
                                NativeModules.BridgeModel.openGameVC(item);
                            }else {
                                NativeModules.BridgeModel.openGameVC(JSON.stringify(item));
                            }
                        }}/>}
                        renderSectionHeader={() => {
                            return <FilterHeader
                                style={{height: 80}}
                                ref={ref=>this.fhRef=ref}
                                onPress={(index) => {
                                    if (index == 4) {
                                        this.props.navigation.navigate('GameSearch', {searchKey: ''})
                                    } else {
                                        this.dataPickerAction(index);
                                    }
                                }
                                }
                            />
                        }}
                        sections={[
                            {title: "Title1", data: this.state.resultJson},
                        ]}
                        ListFooterComponent={this._renderFooter.bind(this)}
                        onEndReached={this._onEndReached.bind(this)}
                        onEndReachedThreshold={1}
                        keyExtractor={(item, index) => item + index}
                    />

                </View>

                <Modal
                    popup
                    visible={this.state.popvisible}
                    animationType="slide-up"
                    maskClosable
                    onClose={this.onCloseModel}
                >
                    <Picker style={{backgroundColor:'rgb(242,242,242)',height:200}}
                            selectedValue={this.state.showItem}
                            itemStyle={{color:"gray", fontSize:24}}
                            onValueChange={(index) => this.onPickerSelect(index)}>
                        {this.state.itemList.map((value, i) => (
                            <PickerItem label={value} value={i} key={"np"+value}/>
                        ))}
                    </Picker>

                    <TouchableOpacity style={{backgroundColor:'rgb(242,172,61)',height: ifIphoneX(78, 44, 44),}} onPress={this.onPickerSel}>
                        <Text style={styles.btnText}>确定</Text>
                    </TouchableOpacity>

                </Modal>
            </Provider>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        // paddingTop: 22
    },
    sectionHeader: {
        width: Constant.kScreenWidth,
        height:Constant.kScreenWidth*45/375,
    },
    sectionHeader2: {
        width: Constant.kScreenWidth,
        height:Constant.kScreenWidth*30/375,
    },
    sectionHeader3: {
        width: Constant.kScreenWidth,
        height:Constant.kScreenWidth*15/375,
    },
    item: {
        padding: 10,
        fontSize: 18,
        height: 44,
    },
    footer:{
        flexDirection:'row',
        height:24,
        justifyContent:'center',
        alignItems:'center',
        marginBottom:10,
        marginTop:5,
    },
    btnText: {
        color: 'white',
        textAlign: 'center',
        lineHeight: ifIphoneX(78, 44, 44),
        height: ifIphoneX(78, 44, 44),
        fontSize: 20,
    }
})