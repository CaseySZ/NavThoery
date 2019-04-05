import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    TouchableOpacity,
    DeviceEventEmitter,
    Image,
    StatusBar,
    FlatList,
    NativeModules, Platform,
    View
} from 'react-native';
import {ifIphoneX} from "../../platform/common/Constant";


export default class TypeList extends Component{

    static navigationOptions = {
        title: '关于乐橙',
        headerLeft:
            <TouchableOpacity
                onPress={() =>{
                    console.log('点击了首页返回')
                    DeviceEventEmitter.emit('closeRn')
                }}>
                <Image
                    style={{marginLeft:10,marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)}}
                    source={ require('../../../res/image/Backarrow.png')}
                />
            </TouchableOpacity>,
    };

    constructor(props) {
        super(props)
        this.renderRow = this.renderRow.bind(this);
    }

    componentDidMount(){
        DeviceEventEmitter.addListener('closeRn',()=>{
            //关闭RN界面
            this.closeRn()
        });

    }

    closeRn() {
        NativeModules.BridgeModel.closeRn("aboutMe");
    }

    renderRow(rowData) {
        return (
            <TouchableOpacity style={styles.row} onPress={()=> {
                if (rowData.index==1){
                    this.props.navigation.navigate('Introduce');
                }else if (rowData.index==2){
                    this.props.navigation.navigate('FAQ');
                } else if (rowData.index==3){
                    this.props.navigation.navigate('CourseList');
                }
            }}>
                <Image style={styles.icon} source={rowData.icon} />
                <Text style={styles.text}>{rowData.text}</Text>
                <Image style={styles.rightIcon} source={require('../../../res/image/icon_arrow_right.png')} />
            </TouchableOpacity>
        )
    }

    render() {

        let dataSource = [
            {index:1,icon:require('../../../res/image/aboutMe/typelist_icon_1.png'),text:'关于乐橙'},
            {index:2,icon:require('../../../res/image/aboutMe/typelist_icon_2.png'),text:'常见问题'},
            {index:3,icon:require('../../../res/image/aboutMe/typelist_icon_3.png'),text:'游戏教程'},
        ];

        return (
            <View>
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
            <FlatList
                data={dataSource}
                renderItem={({item,index}) =>this.renderRow(item)}
            />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    row: {
        flex: 1,
        flexDirection:'row',
        paddingTop: 16,
        paddingBottom:16,
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    icon:{
      marginLeft:16,
    },
    rightIcon:{
        marginRight:16,
    },
    text:{
        flex:1,
        color:'black',
        fontSize:18,
        marginLeft:16,
    }
})