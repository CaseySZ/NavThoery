

import React, {Component} from 'react';
import {Text, View, Image, FlatList} from 'react-native';



export default class TableView extends Component {

    /** 必须有两个属性 data 和 renderItem*/
    render() {

        return (

            <View style={styles.container}>

                <FlatList 
                    data={[
                        {key: 'one', desc:'1'},
                        {key: 'three', desc:'2'},
                        {key: 'four', desc:'3'},
                        {key: 'five', desc:'4'},
                        {key: 'six'},
                    ]}
                    
                    renderItem={({item}) => 

                        <Text style={styles.item}>{item.key} {item.desc}</Text>

                    }
                    
                />

            </View>


        )



    }



}


const styles = {

    container:{

        flex: 1,
        paddingTop: 64,

    },

    item: {

        padding: 10,
        fontSize: 18,
        height:50,
    }

}


