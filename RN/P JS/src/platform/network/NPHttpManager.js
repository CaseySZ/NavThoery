/** 新平台网络请求部分 **/

import HttpUtils from "./HttpUtils";
import { dataCache } from "./HttpCache";
import {
    NativeModules,
    Platform
} from 'react-native';

// const API_URL = "http://www.pt-gateway.com/_glaxy_b01_/";

/**
 * GET
 * 从缓存中读取数据
 * @param isCache: 是否缓存
 * @param url 请求url
 * @param params 请求参数
 * @param isCache 是否缓存
 * @param callback 是否有回调函数
 * @returns {value\promise}
 * 返回的值如果从缓存中取到数据就直接返回数据，或则返回promise对象
 */
const fetchData = (isCache, type) => (subUrl, params={}, callback) => {

    if (Platform.OS === 'ios') {
        NativeModules.BridgeModel.handleReq(subUrl,params,(url,headerDic,bodyDic) => {
            const fetchFunc = () => {
                let promise =
                    type === "get" ? HttpUtils.getRequest(url,bodyDic) : HttpUtils.postRequrst(url, headerDic,bodyDic);
                if (callback && typeof callback === "function") {
                    promise.then((response) => {
                        return callback(response);
                    });
                }
                return promise;
            };

            return dataCache(url, fetchFunc, isCache);
        });
    }else {
        NativeModules.BridgeModel.handleReq(subUrl,JSON.stringify(params),(arr) => {
            let body = JSON.parse(arr[2])
            let formparam = new Object();
            Object.keys(arr[1]).forEach(key=>{formparam[key]=arr[1][key]});
            const fetchFunc = () => {
                let promise =
                    type === "get" ? HttpUtils.getRequest(arr[0],arr[1]) : HttpUtils.postRequrst(arr[0], formparam,body);
                if (callback && typeof callback === "function") {
                    promise.then((response) => {
                        return callback(response);
                    });
                }
                return promise;
            };

            return dataCache(arr[0], fetchFunc, isCache);
        });
    }

};

/**
 * GET 请求
 * @param url
 * @param params
 * @param source
 * @param callback
 * @returns {{promise: Promise}}
 */
const httpGet = fetchData(false, "get");

/**
 * POST 请求
 * @param url
 * @param params
 * @param callback
 * @returns {{promise: Promise}}
 */
const httpPost = fetchData(false, "post");

/**
 * GET 请求，带缓存策略
 * @param url
 * @param params
 * @param callback
 * @returns {{promise: Promise}}
 */
const httpGet4Cache = fetchData(true, "get");

export { httpGet, httpPost, httpGet4Cache };