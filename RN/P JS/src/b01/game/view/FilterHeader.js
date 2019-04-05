import React, {Component} from 'react';
import {
    View,
    Image,
    Text,
    TouchableOpacity,
    StyleSheet,
    ViewPropTypes
} from 'react-native'
import Constant from "../../../platform/common/Constant";

type Props = {
    onPress?: Function,

}


export default class FilterHeader extends Component {

    constructor(props){
        super(props);
        this.state={
            title1: '所有类型',
            title2: '全部平台',
            title3: '全部赔付线',
        };

    }

    setFilterTitle(tab,name) {
        if (tab==1){
            this.setState({title1:name});
        } else if(tab==2){
            this.setState({title2:name});
        }else if (tab==3){
            this.setState({title3:name});
        }
    }

    render() {
        return (
            <View style={styles.container}>
                <View style={styles.btns}>
                    <TouchableOpacity style={styles.item} onPress={this.props.onPress.bind(this,1)} >
                        <Text style={styles.text}>{this.state.title1}</Text>
                        <Image style={styles.arrow} source={ require('../../../../res/image/down_arrow.png')}/>
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.item} onPress={this.props.onPress.bind(this,2)} >
                        <Text style={styles.text}>{this.state.title2}</Text>
                        <Image style={styles.arrow} source={ require('../../../../res/image/down_arrow.png')}/>
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.item} onPress={this.props.onPress.bind(this,3)} >
                        <Text style={styles.text}>{this.state.title3}</Text>
                        <Image style={styles.arrow} source={ require('../../../../res/image/down_arrow.png')}/>
                    </TouchableOpacity>
                </View>
                <TouchableOpacity style={styles.seach}  onPress={this.props.onPress.bind(this,4)} >
                    <Image style={styles.seachIcon} source={ require('../../../../res/image/icon_seach_min.png')}/>
                </TouchableOpacity>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex:1,
        flexDirection:'row',
        paddingLeft:16,
        paddingRight:16,
        backgroundColor:'rgba(246, 246, 246, 1)'
    },
    btns: {
        flex:1,
        flexDirection:'row',
        marginRight:5,
    },
    item:{
        flex:1,
        paddingLeft:16,
        paddingRight:16,
        flexDirection:'row',
        height:40,
        justifyContent:'space-between',
        alignItems:'center',
    },
    arrow:{
        alignItems:'flex-start',
        // marginLeft:8,
        // marginRight:16,
        width: 11,
        height: 7,
    },
    text: {
        textAlign:'center',
        fontSize: 14,
        color:'black',
    },
    seach: {
        // width: 40,
        justifyContent:'center',
        alignItems:'flex-end',
    },
    seachIcon: {
        width: 14,
        height: 14,
    },
})