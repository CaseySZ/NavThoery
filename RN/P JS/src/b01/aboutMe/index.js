import React from "react";
import {
    ImageBackground,
    StyleSheet,
    Image,
    TouchableWithoutFeedback,
    StatusBar,
    Platform,
    NativeModules
} from "react-native";
import {createAppContainer, createStackNavigator} from "react-navigation";
import {ifIphoneX} from "../../platform/common/Constant";
import TypeList from "./TypeList"
import CourseList from "./CourseList"
import CourseDetail from "./CourseDetail"
import Introduce from "./Introduce"
import FAQ from "./FAQ"
import GameHallIndex from "../game/index";

const StackOptions = ({navigation}) => {
    let {goBack} = navigation;
    const headerBackground = (<ImageBackground style={{flex: 1, height:ifIphoneX(88,64,70)}} resizeMode={"stretch"}  source={require('../../../res/image/title_bar_bg2.png')}></ImageBackground>)
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
                NativeModules.BridgeModel.showCustomerMenu();
            }}>
        <Image
            style={styles.rightItem}
            source={ require('../../../res/image/serviec.png')}/>
        </TouchableWithoutFeedback>
    )
    const headerTitleStyle = styles.navHeader;
    const headerStyle= {
        flex:1,
        flexDirection:'row',
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
const MainStack = createStackNavigator({
        TypeList: {
            screen:TypeList,
        },
        CourseList: {
            screen:CourseList,
        },
        Introduce:{
            screen:Introduce,
        },
        FAQ:{
            screen:FAQ,
        }
    },
    {
        initialRouteName: "TypeList",
        defaultNavigationOptions:({navigation}) => StackOptions({navigation}),
    });

const AppStack = createStackNavigator(
    {
        Main: {
            screen: MainStack,
        },
        CourseDetail: {
            screen:CourseDetail,
        },
        GameHallIndex: {
            screen:GameHallIndex,
        },
    },
    {
        mode: 'modal',
        headerMode: 'none',
    }
);

export default createAppContainer(AppStack);


const styles = StyleSheet.create({
    container: {
        flex: 1,
        height:ifIphoneX(88,64,64),
        marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)
    },
    navHeader:{
        flex:1,
        textAlign: 'center',
        color:'#fff',
        fontSize: 20,
        fontWeight:'normal',
        marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)
    },
    rightItem: {
        marginRight:16,
        marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)
    },
    leftItem: {
        marginLeft:16,
        marginTop: ifIphoneX(0,0,(70-StatusBar.currentHeight)/2)
    },
})