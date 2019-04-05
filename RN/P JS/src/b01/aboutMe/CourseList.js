import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    TouchableOpacity,
    DeviceEventEmitter,
    Image,
    StatusBar,
    FlatList,
    View,
} from 'react-native';
import {ifIphoneX} from "../../platform/common/Constant";
import data from "./course_type"

export default class CourseList extends Component{

    static navigationOptions = {
        title: '游戏教程',
    };

    constructor(props) {
        super(props)
        this.renderRow = this.renderRow.bind(this);
    }

    componentDidMount(){


    }

    renderRow(rowData) {
        return (
            <TouchableOpacity style={styles.row} onPress={()=>{
                this.props.navigation.navigate('CourseDetail',{"courseType":data[rowData.idx]});
            }}>
                <Image style={styles.icon} source={rowData.icon} />
            </TouchableOpacity>
        )
    }

    render() {

        let dataSource = [
            {idx:0,icon:require('../../../res/image/aboutMe/courselist_icon_1.png')},
            {idx:1,icon:require('../../../res/image/aboutMe/courselist_icon_2.png')},
            {idx:2,icon:require('../../../res/image/aboutMe/courselist_icon_3.png')},
        ];

        return (
            <FlatList
                data={dataSource}
                renderItem={({item}) =>this.renderRow(item)}
            />
        );
    }
}

const styles = StyleSheet.create({
    row: {
        flex: 1,
        flexDirection:'row',
        paddingTop: 16,
        marginLeft:16,
        marginRight:16,
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    icon:{
        flex: 1,
    },
})