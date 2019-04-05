import { Component } from "react";
import { Toast } from '@ant-design/react-native';

/**
 * fetch 网络请求的header，可自定义header 内容
 * @type {{Accept: string, Content-Type: string, accessToken: *}}
 */
let header = {
    Accept: "application/json",
    "Content-Type": "application/json"
};

/**
 * GET 请求时，拼接请求URL
 * @param url 请求URL
 * @param params 请求参数
 * @returns {*}
 */
const handleUrl = (url) => (params) => {
    if (params) {
        let paramsArray = [];
        Object.keys(params).forEach((key) =>
            paramsArray.push(key + "=" + encodeURIComponent(params[key]))
        );
        if (url.search(/\?/) === -1) {
            typeof params === "object" ? (url += "?" + paramsArray.join("&")) : url;
        } else {
            url += "&" + paramsArray.join("&");
        }
    }
    return url;
};

/**
 * fetch 网络请求超时处理
 * @param original_promise 原始的fetch
 * @param timeout 超时时间 30s
 * @returns {Promise.<*>}
 */
const timeoutFetch = (originalFetch, timeout = 30000) => {
    let timeoutBlock = () => {};
    let timeoutPromise = new Promise((resolve, reject) => {
        timeoutBlock = () => {
            // 请求超时处理
            reject("timeout promise");
        };
    });

    // Promise.race(iterable)方法返回一个promise
    // 这个promise在iterable中的任意一个promise被解决或拒绝后，立刻以相同的解决值被解决或以相同的拒绝原因被拒绝。
    let abortablePromise = Promise.race([originalFetch, timeoutPromise]);

    setTimeout(() => {
        timeoutBlock();
    }, timeout);

    return abortablePromise;
};

/**
 * 网络请求工具类
 */
export default class HttpUtils extends Component {
    /**
     * 基于fetch 封装的GET 网络请求
     * @param url 请求URL
     * @param params 请求参数
     * @returns {Promise}
     */
    static getRequest = (url, params) => {
        return timeoutFetch(
            fetch(handleUrl(url)(params), {
                method: "GET",
                headers: header
            })
        )
            .then((response) => {
                if (response.ok) {
                    return response.json();
                } else {
                    // alert("服务器繁忙，请稍后再试！");
                }
            })
            .then((response) => {
                if (response) {
                    return response;
                } else {
                    return response;
                }
            })
            .catch((error) => {});
    };

    /**
     * 基于fetch 的 POST 请求
     * @param url 请求的URL
     * @param params 请求参数
     * @returns {Promise}
     */
    static postRequrst = (url, headerDic,bodyDic) => {
        return timeoutFetch(
            fetch(url, {
                method: "POST",
                headers:headerDic,
                body: JSON.stringify(bodyDic)
            })
        )
            .then((response) => {
                return response.json();
            })
            .then((json) => {
                let header = json.head;
                if (header && header.errCode == '0000') {
                    if(json.hasOwnProperty('body')) {
                        return json.body;
                    }else{
                        return []
                    }
                } else {
                    return header;
                }
            })
            .catch((error) => {
                Toast.info('网络异常，请检查网络连接',1)
            });


    };
}