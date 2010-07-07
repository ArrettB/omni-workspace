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

    public static String getTimeAsString( int timeValue ) {
        int hours = timeValue / 100;

        int minutes = timeValue - (hours * 100);

        String amPm = " AM";
        if( timeValue >= 1200) {
            amPm = " PM";
        }

        if(timeValue >= 1300) {
            hours = hours - 12;
        }

        String minutesString;
        if(minutes < 10) {
            minutesString = "0" + minutes;
        } else {
            minutesString = String.valueOf(minutes);
        }

        String hoursString;
        if(hours == 0) {
            hours += 12;
        }
        
        if(hours < 10) {
            hoursString = "0" + hours;
        } else {
            hoursString = String.valueOf(hours);
        }

        return hoursString + ":" + minutesString + amPm;
    }
}