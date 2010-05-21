package ims.handlers.time_capture;

import junit.framework.TestCase;
import static junit.framework.Assert.assertEquals;
import dynamic.intraframe.engine.InvocationContext;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import org.junit.Test;
import ims.handlers.time_capture.ExpressEntryHandler;

/**
 * Test for time conversion methods.
 * User: dave
 * Date: May 19, 2010
 * Time: 11:12:45 AM
 */
public class ExpressEntryHandlerTest {

    @Test
    public void testGetStartTime() {
        InvocationContext ic = mock(InvocationContext.class);

//        String startHours = ic.getParameter("start_time_hour");
//        String startMinutes = ic.getParameter("start_time_minutes");
//        String startAMPM = ic.getParameter("start_time_AMPM");

        when(ic.getParameter("start_time_hour")).thenReturn("7");
        when(ic.getParameter("start_time_minutes")).thenReturn("00");
        when(ic.getParameter("start_time_AMPM")).thenReturn("AM");

        ExpressEntryHandler handler = new ExpressEntryHandler();
        int result = handler.getStartTimeInMilitaryTime(ic);

        assertEquals(700, result);
    }

    @Test
    public void testGetEndTime() {
        InvocationContext ic = mock(InvocationContext.class);

        when(ic.getParameter("end_time_hour")).thenReturn("12");
        when(ic.getParameter("end_time_minutes")).thenReturn("00");
        when(ic.getParameter("end_time_AMPM")).thenReturn("AM");

        ExpressEntryHandler handler = new ExpressEntryHandler();
        int result = handler.getEndTimeInMilitaryTime(ic);

        assertEquals(0, result);
    }
}
