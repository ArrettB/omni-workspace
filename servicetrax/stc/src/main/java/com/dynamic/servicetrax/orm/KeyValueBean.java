package com.dynamic.servicetrax.orm;

/**
 * User: pgarvie
 * Date: May 21, 2010
 * Time: 1:56:33 PM
 */
public class KeyValueBean {

    private Object key;
    private Object value;

    public KeyValueBean(Object key, Object value) {
        this.key = key;
        this.value = value;
    }

    public Object getKey() {
        return key;
    }

    public Object getValue() {
        return value;
    }
}
