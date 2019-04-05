import React from "react";
import { createStackNavigator,createAppContainer, } from "react-navigation";
import {
    Image,
    TouchableOpacity,
    ImageBackground,
    View,
    StatusBar, Platform, NativeModules
} from 'react-native';

// 引入页面组件
import MyNews from "./MyNews";
import Announce from "./Announce"
import Letters from "./Letters"
import VipFeedback from "../feedback/VipFeedback"
import { Toast } from '@ant-design/react-native';
import {ifIphoneX} from "../../platform/common/Constant";
import VipFeedbackProgress from "../feedback/VipFeedbackProgress";
import VipFeedbackProgressDetail from "../feedback/VipFeedbackProgressDetail";

const StackOptions = ({navigation}) => {
    console.log(navigation);
    let {goBack} = navigation;
    const headerBackground = (<ImageBackground style={{flex: 1, height:ifIphoneX(88,64,70)}} resizeMode={"stretch"}  source={require('../../../res/image/title_bar_bg2.png')}></ImageBackground>)
    const headerLeft = (
            <TouchableOpacity
                style={{width:40,marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)}}
                onPress={() =>{
                    goBack()
                }}
            >
                <Image
                    style={{marginLeft:10}}
                    source={ require('../../../res/image/Backarrow.png')}
                />
            </TouchableOpacity>
        )
    const headerRight =(
        <TouchableOpacity
            style={{width:40,marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)}}
            onPress={() =>{
                NativeModules.BridgeModel.showCustomerMenu();
            }}>
            <Image
                style={{ marginRight:10}}
                source={ require('../../../res/image/serviec.png')}
                />
        </TouchableOpacity>
    )

    const headerTitleStyle = {
        flex:1,
        textAlign: 'center',
        color:'#fff',
        fontSize: 20,
        fontWeight:'normal',
        marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)
    }
    const headerStyle= {
            height:70
        }

    if (Platform.OS === 'android'){
        return {headerBackground,headerRight,headerTitleStyle,headerLeft,headerStyle}
    }
    else{
        return {headerBackground,headerRight,headerTitleStyle,headerLeft}
    }
};



// 配置路由
const AppNavigator = createStackNavigator(
    {

        home: {
            screen: MyNews,
            navigationOptions: {
                title:'我的消息',
            }
        },

        announce: {
            screen: Announce
        },
        letters: {
            screen: Letters
        },
        VipFeedback: {
            screen: VipFeedback
        },
        VipFeedbackProgress: {
            screen: VipFeedbackProgress
        },
        VipFeedbackProgressDetail: {
            screen: VipFeedbackProgressDetail
        },

    }, {
        initialRouteName: 'home',
        defaultNavigationOptions:({navigation}) => StackOptions({navigation}),
    }
)

export default createAppContainer(AppNavigator);
