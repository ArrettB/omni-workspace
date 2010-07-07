package ims;

import junit.framework.TestCase;

/**
 * Created by IntelliJ IDEA.
 * User: dave
 * Date: Jul 7, 2010
 * Time: 9:46:26 AM
 * To change this template use File | Settings | File Templates.
 */
public class TimeUtilsTest extends TestCase {
    public void testGetTimeAsString() {
        assertEquals("10:30 PM", TimeUtils.getTimeAsString(2230));
        assertEquals("10:30 AM", TimeUtils.getTimeAsString(1030));
        assertEquals("12:00 PM", TimeUtils.getTimeAsString(1200));
        assertEquals("12:00 AM", TimeUtils.getTimeAsString(0));
    }
}
