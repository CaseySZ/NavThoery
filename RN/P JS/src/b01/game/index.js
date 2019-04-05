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
import Constant, {ifIphoneX} from "../../../src/platform/common/Constant"
import GameHall from "./GameHall"
import GameSearch from "./GameSearch"

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


    // return {headerBackground,headerRight,headerTitleStyle,headerLeft}
};



// 配置路由
const GameStack = createStackNavigator({
        GameHall: {
            screen:GameHall,
        },
        GameSearch:{
            screen:GameSearch,
        },
    },
    {
        initialRouteName: "GameHall",
        defaultNavigationOptions:({navigation}) => StackOptions({navigation}),
    });

export default createAppContainer(GameStack);


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