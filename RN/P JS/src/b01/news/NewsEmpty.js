import React,{ Component } from "react";
import {StyleSheet, View, Text, TouchableWithoutFeedback, Image, NativeModules} from 'react-native';

export default class NewsEmpty extends Component {

    constructor(props) {
        super(props)
        this.title = this.props.title
    }

    _consultServce(){
        NativeModules.BridgeModel.showCustomerMenu();
    }

    render(){
        return(
            <View
                style={styles.container}>

                <Image
                    style={styles.announce_img}
                    source={require('../../../res/image/empty_news.png')}
                    />
                <Text  style={styles.first_text}>您当前没有收到新的{this.title}</Text>
                <View
                    style={styles.service_view}
                    >
                    <Text style={styles.second_text}>或许您想要</Text>
                    <TouchableWithoutFeedback
                        onPress={this._consultServce}
                        style={styles.btn_style}
                        >
                        <Text style={styles.service_text}>咨询客服</Text>
                    </TouchableWithoutFeedback>
                </View>

            </View>

        )
    }

}

const styles = StyleSheet.create({

    container:{
        flex:1,
        flexDirection: 'column',
        alignItems: 'center',
        marginTop: 100
    },
    service_view:{
      flexDirection: 'row',
      marginTop: 20,
      justifyContent: 'center',
      alignItems: 'center',
    },
    btn_style:{
        backgroundColor:'#fe6723',
        padding:5
    },
    first_text:{
        marginTop:20,
        color:'#4c4747',
    },
    second_text:{
        color:'#4c4747',
    },
    service_text:{
        color:'#4c4747',
        borderWidth:1,
        borderRadius:5,
        borderColor:'rgb(50,51,50)',
        padding:5,
        marginLeft:5
    }

})