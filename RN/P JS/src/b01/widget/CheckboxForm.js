/**
 * react-native-checkbox-form
 * Checkbox component for react native, it works on iOS and Android
 * https://github.com/cuiyueshuai/react-native-checkbox-form.git
 */

import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {
    View,
    ScrollView,
    Text,
    Dimensions,
    Image,
    TouchableWithoutFeedback
} from 'react-native';

// import Icon from 'react-native-vector-icons/Ionicons';

const WINDOW_WIDTH = Dimensions.get('window').width;

export default class CheckboxForm extends Component {
    constructor(props) {
        super(props);
        this.renderCheckItem = this.renderCheckItem.bind(this);
        this._onPress = this._onPress.bind(this);
        this.state = {
            dataSource: props.dataSource
        };
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            dataSource: nextProps.dataSource
        });
    }

    static propTypes = {
        dataSource: PropTypes.array,
        formHorizontal: PropTypes.bool,
        labelHorizontal: PropTypes.bool,
        itemShowKey: PropTypes.string,
        itemCheckedKey: PropTypes.string,
        iconSize: PropTypes.number,
        iconColor: PropTypes.string,
        onChecked: PropTypes.func,
    };

    static defaultProps = {
        dataSource: [],
        formHorizontal: false,
        labelHorizontal: true,
        itemShowKey: 'label',
        itemCheckedKey: 'checked',
        iconSize: 20,
        iconColor: '#2f86d5',
    };

    _onPress(item, i) {
        //克隆数组
        const outputArr = this.state.dataSource.slice(0);
        outputArr.map((a)=>{
            if(a.value == item.value) {
                a.RNchecked = true
            }else{
                a.RNchecked = false
            }
        })
        outputArr[i] = item;
        this.setState({ dataSource: outputArr });

        if (this.props.onChecked) {
            if(item.RNchecked) {
                this.props.onChecked(item);
            }
        }
    }

    _render_icon(isChecked) {
        return(
            isChecked ? <Image style = {{width:25,height:25}} source={require('../../../res/image/icon_checkbox_check.png')}/> : <Image style = {{width:25,height:25}} source={require('../../../res/image/icon_checkbox.png')}/>
        )
    }

    renderCheckItem(item, i) {
        const { itemShowKey, itemCheckedKey, iconSize, iconColor, textStyle } = this.props;
        const isChecked = item[itemCheckedKey] || false;
        return (
            <TouchableWithoutFeedback
                key={i}
                onPress={() => {
                    item[itemCheckedKey] = !isChecked;
                    this._onPress(item, i);
                }}
            >
                <View
                    style={{ flexDirection: this.props.labelHorizontal ? 'row' : 'column',
                        width:150,paddingBottom:10 }}
                >
                    {this._render_icon(isChecked)}
                    <View
                        style={{ marginLeft: 5 }}
                    >
                        <Text style={{...textStyle,color:'#333',fontSize:15}}>{'' + item[itemShowKey]}</Text>
                    </View>
                </View>
            </TouchableWithoutFeedback>
        );
    }

    render() {
        return (

            <View style={{flexDirection: 'column'}}>
                <View style={{flexDirection: 'row'}}>
                    {
                        this.state.dataSource.slice(0,2).map((item, i) => this.renderCheckItem(item, i))
                    }
                </View>
                <View style={{flexDirection: 'row'}}>
                    {
                        this.state.dataSource.slice(2,4).map((item, i) => this.renderCheckItem(item, i+2))
                    }
                </View>
                <View style={{flexDirection: 'row'}}>
                    {
                        this.state.dataSource.slice(4,6).map((item, i) => this.renderCheckItem(item, i+4))
                    }
                </View>
                <View style={{flexDirection: 'row'}}>
                    {
                        this.state.dataSource.slice(6,8).map((item, i) => this.renderCheckItem(item, i+6))
                    }
                </View>
            </View>



        );
    }

}
