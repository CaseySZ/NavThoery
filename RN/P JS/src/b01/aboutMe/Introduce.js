import React, {Component} from 'react';
import {
    FlatList,
    Image,
    SafeAreaView
} from 'react-native';
import IntroduceCell from './view/IntroduceCell'
import IntroImgCell from './view/IntroImgCell'
import data from "./Introduce.json"
import {
    Modal,
    Provider,
} from '@ant-design/react-native';


export default class Introduce extends Component{

    static navigationOptions = {
        title: '关于乐橙',
    };

    constructor(props) {
        super(props);
        this.onClose = () => {
            this.setState({
                visible: false,
            });
        };
        this.state = {
            visible: false,
        };
    }


    render() {

        let footData = {img:require('../../../res/image/aboutMe/zhengjian_sm.png'),content:'点击查看原图'};

        return (
            <Provider>
                <SafeAreaView>
                <FlatList
                    data={data}
                    renderItem={({item}) => <IntroduceCell rowData={item}/>}
                    ListFooterComponent={() => <IntroImgCell rowData={footData} onPress={() => this.setState({visible: true})} />}
                />

                <Modal
                    style={{backgroundColor:'rgba(0,0,0,0)'}}
                    transparent
                    onClose={this.onClose}
                    maskClosable
                    visible={this.state.visible}
                >
                    <Image source={require('../../../res/image/aboutMe/zhengjian.png')}/>

                </Modal>
                </SafeAreaView>
            </Provider>
        );
    }
}