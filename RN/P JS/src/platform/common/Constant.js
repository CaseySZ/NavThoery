import { Dimensions, Platform, PixelRatio } from 'react-native'


let screenWidth = Dimensions.get('window').width;
let screenHeight = Dimensions.get('window').height;

// iPhoneX Xs
const X_WIDTH = 375;
const X_HEIGHT = 812;

// iPhoneXR XsMax
const XR_WIDTH = 414;
const XR_HEIGHT = 896;

export function isIphoneX() {
    return (
        Platform.OS === 'ios' &&
        ((screenHeight === X_HEIGHT && screenWidth === X_WIDTH) ||
            (screenHeight === X_WIDTH && screenWidth === X_HEIGHT))
    )
}

//判断是否为iphoneXR或XsMAX
function isIphoneXR() {
    return (
        Platform.OS === 'ios' &&
        ((screenHeight === XR_HEIGHT && screenWidth === XR_WIDTH) ||
            (screenHeight === XR_WIDTH && screenWidth === XR_HEIGHT))
    )
}


export function ifIphoneX(iphoneXStyle, iosStyle, androidStyle) {
    if (isIphoneX()||isIphoneXR()) {
        return iphoneXStyle;
    } else if (Platform.OS === 'ios') {
        return iosStyle
    } else {
        if (androidStyle) return androidStyle;
        return iosStyle
    }
}

export default {
    kScreenWidth: screenWidth,
    kScreenHeight: screenHeight,
    onePixel: 1 / PixelRatio.get(),
    statusBarHeight: (Platform.OS === 'ios' ? 20 : 0),
    loginName: ''
}