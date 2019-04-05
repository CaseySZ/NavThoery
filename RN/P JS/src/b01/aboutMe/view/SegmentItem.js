import React, {Component} from 'react';
import {
    Text,
    TouchableHighlight,
    StyleSheet,
} from 'react-native'

import PropTypes from "prop-types";


export default class SegmentItem extends Component {

    constructor(props){
        super(props);
        this.state = {
            active: this.props.isSel,
        };
    }

    static propTypes = {
        onPress: PropTypes.func.isRequired,
    }

    setMeSel(isActive){
        this.setState({active: isActive});
    }

    render() {
        let activeStyle = {};
        let txtActiveStyle = {};
        if (this.state.active) {
            activeStyle = {backgroundColor:'rgb(242,173,61)',};
            txtActiveStyle = {color:'white',};
        }

        return (
            <TouchableHighlight style={[styles.item,activeStyle]}
                                activeOpacity={0.2}
                                underlayColor='rgba(255,133,0,0.2)'
                                // onHideUnderlay={()=>{
                                //     this.setState({active:false})
                                // }}
                                // onShowUnderlay={()=>{
                                //     this.setState({active:true})
                                // }}
                                onPress={this.props.onPress.bind(this)}
                                 >

                <Text style={[styles.text,txtActiveStyle]}>{this.props.data}</Text>

            </TouchableHighlight>
        );
    }
}

const styles = StyleSheet.create({
    item:{
        flex:1,
        flexDirection:'row',
        height:40,
        width:100,
        justifyContent:'center',
        alignItems:'center',
        borderRadius: 30,
    },
    text: {
        textAlign:'center',
        fontSize: 14,
        color:'rgb(255,133,0)',
    },
})