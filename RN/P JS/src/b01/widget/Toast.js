/**
 * Toast 提示
 */
import React, { Component } from 'react';
import {
    View,
    Text,
    Animated,
    Dimensions,
    StyleSheet,
    ViewPropTypes
} from 'react-native';
import PropTypes from 'prop-types';

// 设备屏幕宽高
const { width, height } = Dimensions.get('window');
// Toast提示框透明度
const OPACITY = 0.8;
// 显示时长
export const DURATION = { LONG: 1500, SHORT: 500 };

export default class Toast extends Component {

    // 定义props
    static propTypes = {
        textStyle: ViewPropTypes.style,
        contentStyle: ViewPropTypes.style,
        containerStyle: ViewPropTypes.style,
        position: PropTypes.oneOf([
            'top',
            'center',
            'bottom'
        ])
    }

    //初始化 默认 props
    static defaultProps = {
        position: 'center'
    }

    constructor(props) {
        super(props);
        this.state = {
            text: '',
            isShow: false,
            opacityAnimate: new Animated.Value(OPACITY) // 动画 值初始化
        };

        // 当前显示状态
        this.isShow = false;
        // 初始化默认显示时长为LONG
        this.duration = DURATION.LONG;
    }

    componentWillUnmount() {
        // 在页面生命周期结束时，解除定时器，避免内存泄漏
        this.animateTimer && clearTimeout(this.animateTimer);
    }

    /**
     * 显示
     */
    show(text, duration) {

        if(duration >= DURATION.LONG) {
            this.duration = DURATION.LONG;
        } else {
            this.duration = DURATION.SHORT;
        }

        // 显示
        this.setState({
            text: text,
            isShow: true
        });
        this.isShow = true;
        this.state.opacityAnimate.setValue(OPACITY);

        // 执行隐藏操作
        this.hide();
    }

    /**
     * 隐藏
     */
    hide() {
        // 隐藏状态下不执行操作
        if(!this.isShow) {
            return;
        }

        this.animateTimer && clearTimeout(this.animateTimer);
        this.animateTimer = setTimeout(()=>{
            // 开启动画
            Animated.timing(
                this.state.opacityAnimate,
                {
                    toValue: 0.0,
                    duration: 600
                }
            ).start(()=>{
                // 动画结束后，初始化状态
                this.setState({
                    isShow: false
                })
                this.isShow = false;
            })
        }, this.duration);

    }

    render() {
        let top;
        switch(this.props.position){
            case 'top':
                top = 30;
                break;
            case 'center':
                console.log('高度为:'+height)
                console.log('宽度为:'+width)
                top = height / 2;
                break;
            case 'bottom':
                top = height - 100;
                break;
            default:
                break;
        }
        return this.state.isShow ?
            <View
                pointerEvents={ 'none' }
                style={[ styles.container, { top: top } ]}>
                <Animated.View
                    style={[ styles.content, this.props.contentStyle, { opacity: this.state.opacityAnimate } ]}
                >
                    <Text style={[ styles.text, this.props.textStyle ]}>
                        { this.state.text }
                    </Text>
                </Animated.View>
            </View> : null;
    }
}

const styles = StyleSheet.create({

    container: {
        position: 'absolute',
        left: 0,
        right: 0,
        alignItems: 'center'
    },

    content: {
        height:50,
        backgroundColor: '#000000',
        opacity: OPACITY,
        borderRadius: 5,
        padding: 10,
        alignItems: 'center',
        justifyContent:'center',
    },

    text: {
        color: '#FFFFFF',
        fontSize: 15,
        fontFamily: 'PingFang-SC-Regular'
    }
})
