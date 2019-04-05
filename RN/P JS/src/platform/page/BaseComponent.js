import React,{ Component } from "react";
import { BackHandler } from "react-native";

export default class BaseComponent extends Component {
    _didFocusSubscription;
    _willBlurSubscription;

    constructor(props) {
        super(props);
        this._didFocusSubscription = props.navigation.addListener('didFocus', payload =>
            BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
        );
    }

    componentDidMount() {
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
            BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
        );
    }

    onBackButtonPressAndroid = () => {
        console.log('父类1的onBackButtonPressAndroid')
        if(this.state.animating) {
            this.setState({ animating: false });
            return true
        }else {
            return false;
        }
    };

    componentWillUnmount() {
        this._didFocusSubscription && this._didFocusSubscription.remove();
        this._willBlurSubscription && this._willBlurSubscription.remove();
    }
}