import React, { Component } from 'react'
import {
    View,
    Image,
    Dimensions
} from 'react-native'
import Swiper from 'react-native-swiper'
import {httpPost} from "../../../platform/network/NPHttpManager";
const { width } = Dimensions.get('window')

const styles = {
    wrapper: {
        height:160,
    },

    slide: {
        flex: 1,
        justifyContent: 'center',
        backgroundColor: 'transparent'
    },
    image: {
        width,
        flex: 1,
        backgroundColor: 'transparent'
    },

    loadingView: {
        position: 'absolute',
        justifyContent: 'center',
        alignItems: 'center',
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        backgroundColor: 'rgba(0,0,0,.5)'
    },

    loadingImage: {
        width: 60,
        height: 60
    }
}

const Slide = props => {
    return (<View style={styles.slide}>
        <Image onLoad={props.loadHandle.bind(null, props.i)} style={styles.image} source={{uri: props.uri}} />
        {/*{*/}
            {/*!props.loaded && <View style={styles.loadingView}>*/}
                {/*<Image style={styles.loadingImage} source={loading} />*/}
            {/*</View>*/}
        {/*}*/}
    </View>)
}

export default class Carousel extends Component {
    constructor (props) {
        super(props)
        this.state = {
            dataSource: [
                // 'http://5b0988e595225.cdn.sohucs.com/images/20180421/193a3464c8ba4713ac2d3f2fb93829c7.jpeg',
                // 'http://seopic.699pic.com/photo/40006/5720.jpg_wh1200.jpg',
                // 'http://i.ce.cn/ce/culture/gd/201806/11/W020180611287087593895.jpg',
                // 'https://dimg02.c-ctrip.com/images/fd/tg/g3/M02/00/43/CggYGlXdjuGAYCFnACqsg8R0NVs661_C_350_230.jpg'
                '','', '','',
            ],
            loadQueue: [0, 0, 0, 0]
        }
        this.loadHandle = this.loadHandle.bind(this)
    }
    loadHandle (i) {
        let loadQueue = this.state.loadQueue
        loadQueue[i] = 1
        this.setState({
            loadQueue
        })
    }

    componentDidMount() {
        httpPost('_extra_/b01/queryByKeyList',{keys:['gamesLobby']},(responseJson)=>{
            // console.log(responseJson);

            // alert(JSON.stringify(responseJson));

            let dataList = new Array();
            for (let i = 0; i <responseJson.gamesLobby.length; i++) {
                let item = responseJson.gamesLobby[i];
                dataList[i] = item.image;
            }

            this.setState({
                dataSource: dataList,
                refreshing: false,
            })
        });

    }

    render () {
        return (
            <Swiper loadMinimal loadMinimalSize={1} style={styles.wrapper} loop={true} autoplay>
                {
                    this.state.dataSource.map((item, i) => <Slide
                        loadHandle={this.loadHandle}
                        loaded={!!this.state.loadQueue[i]}
                        uri={item}
                        i={i}
                        key={i} />)
                }
            </Swiper>
        )
    }
}
