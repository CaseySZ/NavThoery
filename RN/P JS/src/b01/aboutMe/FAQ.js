import React, {Component} from 'react';
import {
    FlatList, SafeAreaView, View,
} from 'react-native';
import IntroduceCell from './view/IntroduceCell'
import data from "./faq.json"
import CourseBtnCell from "./view/CourseBtnCell";
import CourseTxtCell from "./view/CourseTxtCell";
import IntroTextCell from "./view/IntroTextCell";


export default class FAQ extends Component{

    static navigationOptions = {
        title: '常见问题',
    };

    render() {

        return (
            <SafeAreaView>
                <FlatList
                    data={data}
                    renderItem={({item}) => {
                        switch (item.type){
                            case 1:
                                return  <CourseBtnCell rowData={item}/>
                            case 2:
                                return  <CourseTxtCell rowData={item}/>
                            // 不可复用模块，单独处理
                            case 22:
                                return  <IntroduceCell rowData={item}/>
                            case 23:
                                return<IntroTextCell rowData={item}/>
                        }
                    }}
                />
            </SafeAreaView>
        );
    }
}
