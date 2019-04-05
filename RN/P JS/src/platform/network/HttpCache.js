import store from "react-native-simple-store";

/**
 * @param key：key为url的Path
 * @param fetchFunc：回调函数
 * @param isCache：是否需要缓存
 * @returns {value}
 */
const dataCache = (key, fetchFunc, isCache) => {
    if (!isCache) {
        return fetchFunc();
    }
    return store.get(key).then((value) => {
        if (value) {
            return value;
        } else {
            return fetchFunc().then((value) => {
                value ? store.save(key, value) : null;
                return value;
            });
        }
    });
};

export { dataCache };