/*
 * Created on May 20, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.dynamic.charm.web.tag;

import junit.framework.TestCase;

import com.dynamic.charm.common.LogUtil;

/**
 * @author gcase
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class TagDefaultsTest extends TestCase
{

    private int defaultInt = 12;

    private Integer defaultInteger = new Integer(42);

    private String defaultString = "This is a string";
    private String defaultString2 = "This is a silly string";

    private int setInt = 14;

    private Integer setInteger = new Integer(42 * 42);

    private String setString = "This is a not string";

    private TagDefaults TD;

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception
    {
        LogUtil.addConsoleAppender();
        
        super.setUp();

        TD = TagDefaults.getInstance();
        TD.clearAllDefaults();
 //       TD.registerDefault(ExampleBean.class, "intValue", new Integer(defaultInt));
        TD.registerDefault(ExampleBean.class, "integerValue", defaultInteger);
        TD.registerDefault(ExampleBean.class, "stringValue", defaultString);
        
        TD.registerDefault(AnotherExampleBean.class, "stringValue", defaultString2);
   }

    /**
     * Ensure that we are indeed setting setting defaults to null values
     *
     */
    public void testSetDefaults()
    {
        ExampleBean instance = new ExampleBean();
        TD.setAllDefaults(instance);
        
 //       assertEquals(defaultInt, instance.getIntValue());
        assertEquals(defaultInteger, instance.getIntegerValue());
        assertEquals(defaultString, instance.getStringValue());
 
    }
    
    /**
     * Make sure that defaults from one class do not leak into another
     *
     */
    public void testClassIsolation()
    {
        AnotherExampleBean instance = new AnotherExampleBean();
        TD.setAllDefaults(instance);
        assertEquals(defaultString2, instance.getStringValue());
 
    }
    /**
     * Ensure that we do not accidently overritting previously set values
     *
     */
    public void testDoesNotOverride()
    {

        ExampleBean instance = new ExampleBean();
        instance.setIntValue(setInt);
        instance.setIntegerValue(setInteger);
        instance.setStringValue(setString);

        TD.setAllDefaults(instance);
        
        assertEquals(setInt, instance.getIntValue());
        assertEquals(setInteger, instance.getIntegerValue());
        assertEquals(setString, instance.getStringValue());
   }
}




