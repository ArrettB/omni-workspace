package com.dynamic.servicetrax.util;

/**
 * Utility class for dealing with military time.
 *
 * User: dave
 * Date: May 19, 2010
 * Time: 11:35:36 AM
 */
public class TimeUtils {
    public static int getTimeAsMilitaryTime( int hours, int minutes, String amPm ) {
        int militaryTime = 0;
        int twelveHours = 0;
        if( "PM".equalsIgnoreCase(amPm) ) {
            twelveHours = 12;
        }

        if( hours == 12 ) {
            hours = 0;
        }

        hours = ( hours + twelveHours ) * 100;
        militaryTime = hours + minutes;

        return militaryTime;
    }

    public static String getHour(int militaryTime) {

        if (militaryTime < 100) {
            return "12";
        }

        int hour = (militaryTime / 100);
        return String.valueOf(hour > 12 ? hour - 12 : hour);
    }

    public static String getMinutes(int militaryTime) {

        if (militaryTime == 0) {
            return "00";
        }

        int minutes = militaryTime % 100;
        return minutes == 0 ? "00" : String.valueOf(minutes);
    }

    public static String getAMPM(int militaryTime) {
        return militaryTime - 1200 < 0 ? "AM" : "PM";
    }
}
