package ims;

/**
 * Utility class for dealing with military time.
 *
 * User: dave
 * Date: May 19, 2010
 * Time: 11:35:36 AM
 */
public class TimeUtils {
    public static int getTimeAsMilitaryTime( int hours, int minutes, String amPm ) {
        int militaryTime;
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
}