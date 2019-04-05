import React, {Component} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity,
} from 'react-native'
import PropTypes from "prop-types";


export default class IntroImgCell extends Component {

    static propTypes = {
        onPress: PropTypes.func.isRequired,
    }

    render() {

        let data = this.props.rowData;

        return (
            <View style={styles.container}>

               <Image source={data.img}/>

                <TouchableOpacity onPress={this.props.onPress.bind(this)}>
                    <Text style={styles.text}>{data.content}</Text>
                </TouchableOpacity>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        // flex: 1,
        flexDirection: 'column',
        justifyContent:'center',
        alignItems:'center',
        marginTop:25,
        paddingBottom:20,
    },
    text:{
        marginTop:16,
        color: 'rgb(0,122,255)',
        fontSize:14,
    }
})





