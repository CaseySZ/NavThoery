import React, {Component} from 'react';
import {
    View,
    StyleSheet,
    Text,
} from 'react-native'

import { Grid } from '@ant-design/react-native';

export default class CourseGridCell extends Component {

    render() {
        let data = this.props.rowData;
        return (
            <View style={styles.container}>
                <Grid
                    data={data.title}
                    columnNum={data.title.length}
                    renderItem={(el) =>  <Text style={[styles.title,{ backgroundColor: 'rgb(250,245,245)' }]}>{el}</Text>}
                    itemStyle={{ height: 40 }}
                />
                <Grid
                    data={data.content}
                    columnNum={data.title.length}
                    renderItem={(el) =>  <Text style={[styles.title,{backgroundColor: 'white' ,lineHeight:el.indexOf('\n')==-1?40:20}]}>{el}</Text>}
                    itemStyle={{ height: 40 }}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        flexDirection: 'column',
        margin:16,
    },
    title:{
        color: 'black',
        fontSize:12,
        height: 40,
        lineHeight:40,
        textAlign:'center'
    }
})





