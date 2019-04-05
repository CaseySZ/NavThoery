

import React, {Component} from 'react';
import {Text, View, Image, SectionList} from 'react-native';



export default class TableViewSection extends Component {


    render() {

        return (

            <View style={styles.container}>

                <SectionList
                
                    sections={[

                        {title:'A', data: ['Abf', 'Acc']},
                        {title:'B', data: ['bbf', 'bcc']},
                        {title:'D', data: ['DDDbf', 'Dccdd']},

                    ]}
                    
                    renderItem={({item}) =>  

                        <Text style={styles.item}> {item} </Text>
                    }

                    renderSectionHeader={({section}) => 
                
                        <Text style={styles.sectionHeader}> {section.title} </Text>
                    
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
    },

    sectionHeader: {

        paddingTop: 2,
        paddingLeft: 10,
        paddingRight: 10,
        paddingBottom: 2,
        fontSize: 28,
        fontWeight: 'bold',
        backgroundColor: 'red',

    },

}


