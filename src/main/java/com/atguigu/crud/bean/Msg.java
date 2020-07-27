package com.atguigu.crud.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * 返回通用的类
 */
public class Msg {

    //返回状态码
    private Integer code;

    //返回提示信息
    private String title;

    //返回的数据
    private Map<String,Object> data = new HashMap<>();

    /**
     * 返回成功
     * @return
     */
    public static Msg succes(){
        Msg msg = new Msg();
        msg.setCode(200);
        msg.setTitle("返回成功！！");
        return msg;
    }

    /**
     * 返回失败
     * @return
     */
    public static Msg fail(){
        Msg msg = new Msg();
        msg.setCode(100);
        msg.setTitle("返回失败！！");
        return msg;
    }

    /**
     * 添加数据
     * @param key
     * @param object
     * @return
     */
    public Msg addData(String key,Object object){
        this.getData().put(key,object);
        return this;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Map<String, Object> getData() {
        return data;
    }

    public void setData(Map<String, Object> data) {
        this.data = data;
    }
}
