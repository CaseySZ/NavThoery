import {httpPost} from "../../platform/network/NPHttpManager";


export default class SuggestBusiness {


    //查询vip反馈建议
    static querySuggests(params) {
       let url = 'querySuggests'
       return new Promise((resolve,reject)=> {
            //第二个参数是个对象
            httpPost(url,params,(json)=>{
                console.log('打印vip反馈建议结果为1::'+json)
                console.log('打印vip反馈建议结果为2::'+json.length)
                console.log('打印vip反馈建议结果为::'+JSON.stringify(json))
                if(json) {
                    resolve(json)
                }else{
                    reject("没数据")
                }
            });
        })
    }

    //创建客户反馈建议createSuggest
    static createSuggest(params) {
        // let a = JSON.parse(params)
        // a.url = 'createSuggest'
        // let url = JSON.stringify(a)
        let url = 'createSuggest'
        return new Promise((resolve,reject) => {
            //第二个参数是个对象
            httpPost(url,params,(json)=>{
                console.log('创建客户反馈结果为1::'+json)
                console.log('创建客户反馈结果为2::'+json.length)
                console.log('创建客户反馈结果为::'+JSON.stringify(json))
                if(json) {
                    console.log('创建客户反馈成功')
                    resolve(json)
                }else{
                    console.log('创建客户反馈失败')
                    reject("创建客户反馈没数据")
                }
            });
        })
    }




    _getAnnounce() {
        let subUrl = 'message/queryAnnounces'
        let params = {loginName:this.loginName}

        //第二个参数是个对象
        httpPost(subUrl,params,(json)=>{
            console.log('打印公告成功结果为::'+JSON.stringify(json))
            if(json) {
                this.announceSuccess = true
                if(this.letterSuccess && this.announceSuccess) {
                    this.setState({ animating: false });
                }
                if(json.length == 0) {
                    console.log('不使用模拟公告数据')
                    /*let flag = this._findUnreadFlag(fakeAnnounceData)
                    this.setState({
                        announceUnread:flag
                    })*/
                }else{
                    this.setState({
                        annonceData:json[0]
                    })
                }
            }
        });
    }

}