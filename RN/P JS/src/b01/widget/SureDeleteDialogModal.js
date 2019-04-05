import React, {Component} from 'react';
import {
    StyleSheet,
    View,
    Modal,
    Button,
    Alert,
    Text,
    TouchableOpacity, StatusBar, Platform,

} from 'react-native';
import PropTypes from 'prop-types'

export default class SureDeleteDialogModal extends Component {

    static navigationOptions = {
        title: 'Modal',
    };

    state = {
        visible: false,
        transparent: true,
    }
    constructor(props) {
        super(props);
    }


    show(){
        console.log('对话框被调用222222222')
        this.setState({visible:true})
    }

    dismiss() {
        this.setState({visible:false})
    }

    sure() {
        console.log('确定取消对话框被调用')
        this.setState({visible:false})
        this.props.sure()
    }


    render() {
        return (
            <View style={{flex:1}}>

                <Modal
                    animationType='none'
                    visible={this.state.visible}
                    transparent={this.state.transparent}
                    onRequestClose={()=>{
                        this.dismiss()
                    }}
                    onShow={()=>{

                    }}>

                    {
                        Platform.OS === 'ios' ? null :
                            <StatusBar
                                animated={false} //指定状态栏的变化是否应以动画形式呈现。目前支持这几种样式：backgroundColor, barStyle和hidden
                                hidden={false}  //是否隐藏状态栏。
                                backgroundColor={this.state.visible ? 'rgba(0, 0, 0, 0.5)':'transparent'} //状态栏的背景色
                                translucent={true}//指定状态栏是否透明。设置为true时，应用会在状态栏之下绘制（即所谓“沉浸式”——被状态栏遮住一部分）。常和带有半透明背景色的状态栏搭配使用。
                                barStyle={'light-content'} // enum('default', 'light-content', 'dark-content')
                            />
                    }

                    <TouchableOpacity
                        style={{flex:1}}
                        onPress = {()=>{
                            this.setState({visible:false})
                        }}>

                        <View style={{flex:1,backgroundColor:'rgba(0,0,0,0.5)',justifyContent: 'center'}}>
                            <View style={styles.container}>
                                <View style={{flex:1}}>
                                    <View style={{flex:1,justifyContent:'center',paddingLeft:10}}>
                                        <Text style={{color:'black',fontSize:25,marginTop:-6,alignSelf:'center'}}>温馨提示</Text>
                                        <Text style={{color:'black',fontSize:15}}>删除站内信后无法恢复，请确认是否删除。</Text>
                                    </View>
                                    <View style={{height:1,backgroundColor:'rgb(162,162,162)'}}/>
                                </View>
                                <View style={{height:40,flexDirection:'row'}}>
                                    <TouchableOpacity
                                        style={{flex:1,alignItems: 'center',justifyContent:'center'}}
                                        onPress={this.dismiss.bind(this)}>
                                        <Text style={{color:'rgb(55,125,246)',fontSize:15}}>取消</Text>
                                    </TouchableOpacity>
                                    <View style={{width:1,backgroundColor:'rgb(162,162,162)'}}/>
                                    <TouchableOpacity
                                        style={{flex:1,alignItems: 'center',justifyContent:'center'}}
                                        onPress={this.sure.bind(this)}>
                                        <Text style={{color:'rgb(55,125,246)',fontSize:15}} >删除</Text>
                                    </TouchableOpacity>

                                </View>
                            </View>
                        </View>
                    </TouchableOpacity>

                </Modal>
            </View>
        );
    }
}
const styles = StyleSheet.create({

   container:{
       height:140,
       width:300,
       flexDirection:'column',
       backgroundColor:'rgb(249,249,249)',
       borderRadius:10,
       alignSelf:'center',
   }

})