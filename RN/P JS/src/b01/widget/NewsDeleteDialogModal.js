import React, {Component} from 'react';
import {
    StyleSheet,
    View,
    Modal,
    Button,
    Alert,
    Text,
    TouchableOpacity,
    StatusBar, Dimensions, Platform
} from 'react-native';
import PropTypes from 'prop-types'

export default class NewsDeleteDialogModal extends Component {

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


    static propTypes = {
        selectItem: PropTypes.func.isRequired,  //一键删除
    }


    show(){
        console.log('对话框被调用')
        this.setState({visible:true})
    }

    dismiss() {
        this.setState({visible:false})
    }

    render() {
        const {selectItem} = this.props
        return (

               <Modal
                   style={{ flex:1,marginTop:50}}
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
                       style={{ flex:1,backgroundColor: 'rgba(0, 0, 0, 0.5)'}}
                       onPress = {()=>{
                           this.setState({visible:false})
                       }}>
                       <View style={{flex:1,flexDirection:"column",justifyContent:'flex-end'}}>
                           <View>
                               {/*<View style={{backgroundColor:'rgb(255,170,21)',height:48,alignItems:'center',justifyContent:'center'}}>*/}
                                   <TouchableOpacity
                                       style={{backgroundColor:'rgb(255,170,21)',height:48,alignItems:'center',justifyContent:'center'}}
                                       onPress={this.props.selectItem.bind(this)}>
                                       <Text style={{color:'white',fontSize:18}} >一键删除</Text>
                                   </TouchableOpacity>
                               {/*</View>*/}
                               <View style={{backgroundColor:'white',height:48,alignItems:'center',justifyContent:'center'}}>
                                   <Text style={{color:'black',fontSize:18}} onPress={()=>{this.setState({visible:false})}}>取消</Text>
                               </View>
                           </View>
                       </View>

                   </TouchableOpacity>
                </Modal>

        );
    }
}
