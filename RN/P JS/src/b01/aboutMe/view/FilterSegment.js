import React, {Component} from 'react';
import {
    View,
    StyleSheet,
} from 'react-native'

import PropTypes from "prop-types";
import SegmentItem from "./SegmentItem"


export default class FilterSegment extends Component {

    constructor(props){
        super(props);
        this.state = {
            selIdx: this.props.selValue,
        };
    }

    static propTypes = {
        onPress: PropTypes.func.isRequired,
    }


    render() {
        if (this.props.data){
            return (
                <View style={styles.container}>

                    <SegmentItem data={this.props.data[0]} isSel={0==this.state.selIdx} ref={ref=>this.seg0=ref} onPress={this.props.onPress.bind(this,0)}/>

                    <SegmentItem data={this.props.data[1]} isSel={1==this.state.selIdx} ref={ref=>this.seg1=ref} onPress={this.props.onPress.bind(this,1)}/>

                    <SegmentItem data={this.props.data[2]} isSel={2==this.state.selIdx} ref={ref=>this.seg2=ref} onPress={this.props.onPress.bind(this,2)}/>

                </View>
            );
        }
        return null;
    }

    setSegmentSel(idx){
        this.setState({selIdx: idx});
        this.seg0.setMeSel(0==idx);
        this.seg1.setMeSel(1==idx);
        this.seg2.setMeSel(2==idx);
    }
}

const styles = StyleSheet.create({
    container: {
        flexDirection:'row',
        width:300,
        height:40,
        alignSelf:'center',
        justifyContent:'space-between',
        backgroundColor:'rgba(249, 245, 245, 1)',
        borderRadius: 30,
        marginTop:16,
    },
})