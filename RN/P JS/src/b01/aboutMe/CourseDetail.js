import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    Image,
    StatusBar,
    View,
    TouchableWithoutFeedback,
    TouchableOpacity, SafeAreaView, FlatList, Platform, NativeModules,
} from 'react-native';
import Constant, {ifIphoneX} from "../../../src/platform/common/Constant"
import imgs from './CourseImgDic'
import LinearGradient from 'react-native-linear-gradient'
import FilterSegment from "./view/FilterSegment";
import courseData from "./course"
import CourseBoxCell from "./view/CourseBoxCell"
import CourseTxtCell from "./view/CourseTxtCell"
import CourseTitleCell from "./view/CourseTitleCell"
import CourseBtnCell from "./view/CourseBtnCell"
import CourseImgCell from "./view/CourseImgCell"
import CourseGridCell from "./view/CourseGridCell"
import CourseImgTxtBoxCell from "./view/CourseImgTxtBoxCell"
import CourseBjlCell from "./view/CourseBjlCell"
import data from "./course_type";

export default class CourseDetail extends Component{

    constructor(props) {
        super(props)
        this.state = {
            segmentIdx: 0,
        };
    }

    componentDidMount(){


    }


    render() {
        let courseTypeData = this.props.navigation.getParam("courseType");
        // alert(JSON.stringify(courseTypeData));
        let dataArr = courseData[courseTypeData.type]["data"];
        let data = dataArr[this.state.segmentIdx];

        //在底部添加一个空格
        data.push({type:10,content:20});

        return (
            <View style={styles.container}>
                <LinearGradient colors={courseTypeData.colors} start={{ x : 0.0, y : 0.0 }} end={{ x : 1.0, y : 1.0 }} style={{height: styles.header.height}}>
                    <View style={styles.header}>

                        <View style={styles.navBar}>
                            <TouchableOpacity
                                onPress={() => {
                                    this.props.navigation.pop();
                                }}>
                                <Image
                                    style={styles.leftItem}
                                    source={require('../../../res/image/Backarrow.png')}
                                />
                            </TouchableOpacity>

                            <Text style={styles.navHeader}>{courseTypeData.topTitle}</Text>

                            <TouchableWithoutFeedback
                                style={{padding:8,backgroundColor: 'red'}}
                                onPress={() => {
                                    NativeModules.BridgeModel.showCustomerMenu();
                                }}>
                            <Image
                                style={styles.rightItem}
                                source={require('../../../res/image/serviec.png')}/>
                            </TouchableWithoutFeedback>

                        </View>

                        <View style={styles.navImageBox}>
                            <Image style={{position: 'absolute',right: courseTypeData.img.right}} source={imgs[courseTypeData.img.content]}/>
                            <View style={styles.navImageInnerBox}>
                                <Text style={styles.HeaderTitle}>{courseTypeData.title}</Text>

                                <TouchableOpacity style={[styles.tryPlayBtnBox,{width:courseTypeData.btn.width}]}
                                                  onPress={()=>{
                                                      if (Platform.OS === 'ios') {
                                                          NativeModules.BridgeModel.openGameVC(courseTypeData.item);
                                                      }else {
                                                          // NativeModules.BridgeModel.openGameVC(JSON.stringify(courseTypeData.item));
                                                          if (courseTypeData.type==2){
                                                              this.props.navigation.navigate('GameHall',{'from':'course'});
                                                          } else {
                                                              NativeModules.BridgeModel.openGameVC(JSON.stringify(courseTypeData.item));
                                                          }

                                                      }
                                                  }
                                                  }>
                                    <Text style={[styles.tryPlayBtnText,{color:courseTypeData.btn.color,}]}>{courseTypeData.btn.txt}</Text>
                                </TouchableOpacity>
                            </View>
                        </View>

                    </View>
                </LinearGradient>

                {/*教程内容*/}

                <SafeAreaView style={styles.content}>
                    <View  style={styles.content}>
                        <FilterSegment style={{height:40}} data={courseTypeData.segment} selValue={this.state.segmentIdx} ref={ref=>this.segRef=ref} onPress={(segmentIdx) => {
                            this.setState({segmentIdx: segmentIdx});
                            this.segRef.setSegmentSel(segmentIdx);
                        }} />
                        <FlatList
                            style={{marginTop:16}}
                            data={data}
                            renderItem={({item}) => {
                                switch (item.type){
                                        case 11:
                                        return <CourseBoxCell rowData={item}/>
                                    case 1:
                                        return  <CourseBtnCell rowData={item}/>
                                    case 101:
                                        return  <CourseBtnCell rowData={item} colors={courseTypeData.colors} />
                                    case 2:
                                        return  <CourseTxtCell rowData={item}/>
                                    case 3:
                                        return  <CourseImgCell rowData={item}/>
                                    case 4:
                                        return  <CourseGridCell rowData={item}/>
                                    case 5:
                                        return  <CourseImgTxtBoxCell rowData={item}/>
                                    case 6:
                                        return  <CourseTitleCell rowData={item}/>
                                    // 空格
                                    case 10:
                                        return  <View style={{height:item.content}}/>
                                    // 不可复用模块，单独处理
                                    case 21:
                                        return  <CourseBjlCell/>
                                }
                            }}
                        />
                    </View>
                </SafeAreaView>


            </View>
        );
    }
}

const styles = StyleSheet.create({
    container:{
      flex:1,
    },
    header: {
        // flex: 1,
        flexDirection: 'column',
        // backgroundColor: '#ff8400',
        height: ifIphoneX(88, 64, 64)+100,
    },
    navBar: {
        flexDirection: 'row',
        height: 40,
        marginTop: ifIphoneX(44, 20, (70 - StatusBar.currentHeight) / 2),
    },
    navHeader: {
        flex: 1,
        textAlign: 'center',
        color: '#fff',
        fontSize: 20,
        fontWeight: 'normal',
        marginTop: ifIphoneX(0, 0, (70 - StatusBar.currentHeight) / 2-10)
    },
    rightItem: {
        marginRight: 16,
        marginTop: ifIphoneX(0, 0, (70 - StatusBar.currentHeight) / 2-10)
    },
    leftItem: {
        marginLeft: 16,
        marginRight:16,
        marginTop: ifIphoneX(0, 0, (70 - StatusBar.currentHeight) / 2-10)
    },
    navImageBox:{
        flex:1,
        flexDirection:'row',
        justifyContent:'center',
        alignItems:'flex-end',
    },
    navImageInnerBox:{
        position:'absolute',
        // justifyContent: 'center',
        right:Constant.kScreenWidth*0.45,
        alignItems: 'center',
    },
    tryPlayBtnBox:{
        backgroundColor: 'white',
        width:80,
        height:30,
        borderRadius:12,
        marginBottom:16,
    },
    tryPlayBtnText:{
        color:'rgb(238,139,51)',
        textAlign:'center',
        lineHeight:30,
    },
    HeaderTitle: {
        textAlign: 'center',
        color: '#fff',
        fontSize: 28,
        fontWeight: 'normal',
        marginBottom:16,
    },
    content:{
        flex:1,
        flexDirection:'column'
    }

})