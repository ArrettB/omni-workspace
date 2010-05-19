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

        hours = ( hours + twelveHours ) * 100;
        militaryTime = hours + minutes;

        return militaryTime;
    }  
}
