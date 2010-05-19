package com.dynamic.servicetrax.tc;

import junit.framework.TestCase;

/**
 * TimeRecord test.  Used for testing gettors that translate from screen data to database data.
 *
 * User: dave
 * Date: May 17, 2010
 * Time: 2:10:38 PM
 */
public class TimeRecordTest extends TestCase {
    public void testGetMilitaryTime() {
        TimeRecord record = new TimeRecord();
        record.setStartTimeHour(0);
        record.setStartTimeMinutes(30);
        record.setStartTimeAmPm("AM");

        assertEquals( 30, record.getStartTimeAsMilitaryTime());
    }

    public void testGetMilitaryTimePm() {
        TimeRecord record = new TimeRecord();
        record.setStartTimeHour(0);
        record.setStartTimeMinutes(30);
        record.setStartTimeAmPm("PM");

        assertEquals( 1230, record.getStartTimeAsMilitaryTime());
    }

    public void testGetMilitaryTimeNoon() {
        TimeRecord record = new TimeRecord();
        record.setStartTimeHour(0);
        record.setStartTimeMinutes(0);
        record.setStartTimeAmPm("PM");

        assertEquals( 1200, record.getStartTimeAsMilitaryTime());
    }

    public void testGetMilitaryTimeMidnight() {
        TimeRecord record = new TimeRecord();
        record.setStartTimeHour(0);
        record.setStartTimeMinutes(0);
        record.setStartTimeAmPm("AM");

        assertEquals( 0, record.getStartTimeAsMilitaryTime());
    }

    public void testGetBreakTimeDuration() {
        TimeRecord record = new TimeRecord();
        record.setBreakTimeHours(1);
        record.setBreakTimeMinutes(0);

        assertEquals( 60, record.getBreakTimeDuration());
    }

    public void testGetBreakTimeDurationNoTime() {
        TimeRecord record = new TimeRecord();
        record.setBreakTimeHours(0);
        record.setBreakTimeMinutes(0);

        assertEquals( 0, record.getBreakTimeDuration());
    }

    public void testGetBreakTimeDuration30Minutes() {
        TimeRecord record = new TimeRecord();
        record.setBreakTimeHours(0);
        record.setBreakTimeMinutes(30);

        assertEquals( 30, record.getBreakTimeDuration());
    }

    public void testGetBreakTimeDuration90Minutes() {
        TimeRecord record = new TimeRecord();
        record.setBreakTimeHours(1);
        record.setBreakTimeMinutes(30);

        assertEquals( 90, record.getBreakTimeDuration());
    }
}
