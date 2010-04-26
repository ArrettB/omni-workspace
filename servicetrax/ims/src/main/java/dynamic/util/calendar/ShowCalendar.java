// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   ShowCalendar.java

package dynamic.util.calendar;

import dynamic.util.diagnostics.Diagnostics;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Calendar;
import java.util.GregorianCalendar;
import javax.servlet.*;
import javax.servlet.http.*;

public class ShowCalendar extends HttpServlet
{

    /**
	 * 
	 */
	private static final long serialVersionUID = -7387622393760493487L;

	public ShowCalendar()
    {
    }

    public void service(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException
    {
        res.setContentType("text/html");
        doGet(req, res);
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException
    {
        String color = req.getParameter("color");
        PrintWriter out = res.getWriter();
        out.println("<html>");
        out.println("<head>");
        out.println("<style><!-- a:{color:" + color + "} a:vlink{color:" + color + "} a:hover{color:#ff0000} --></style>");
        out.println("<title>Calendar</title>");
        out.println("<script type=\"text/javascript\"> ");
        out.println("function winupdate(year, month, day)");
        out.println("{ ");
        out.println("\topener.document." + req.getParameter("form") + "." + req.getParameter("field") + ".value = month + \"/\" + day + \"/\" + year; ");
        out.println("\twindow.close(); ");
        out.println("} ");
        out.println("</script> ");
        out.println("</head>");
        out.println("<body bgcolor=#FFFFFF text=#000000 link=#990000 vlink=#663333 alink=#FF0000 marginwidth=\"0\" marginheight=\"0\" topmargin=\"0\" leftmargin=\"0\">");
        Calendar cal = Calendar.getInstance();
        String year = req.getParameter("year");
        if(year != null)
            try
            {
                int iyear = Integer.parseInt(year);
                int imonth = Integer.parseInt(req.getParameter("month"));
                String direct = req.getParameter("direct");
                cal.set(iyear, imonth, 1);
                if(direct.equalsIgnoreCase("next"))
                    cal.add(2, 1);
                else
                    cal.add(2, -1);
            }
            catch(Exception e)
            {
                Diagnostics.error("Problem in ShowCalendar.doOutput()", e);
            }
        try
        {
            out.println("<center>");
            out.println(getCal(cal, req.getParameter("form"), req.getParameter("field"), color));
            out.println("</center>");
        }
        catch(Exception e)
        {
            Diagnostics.error("Problem in ShowCalendar.doOutput()", e);
        }
        out.println("</body>");
        out.println("</html>");
        out.flush();
        out.close();
    }

    public String getCal(Calendar cal, String form, String field, String color)
    {
        String output = "";
        int mn = cal.get(2);
        int monthEnd = 31;
        GregorianCalendar comp = new GregorianCalendar();
        comp.set(cal.get(1), cal.get(2), 1);
        String month = "";
        switch(mn)
        {
        default:
            break;

        case 0: // '\0'
            month = "January";
            monthEnd = 31;
            break;

        case 1: // '\001'
            month = "February";
            monthEnd = 28;
            if(comp.isLeapYear(cal.get(1)))
                monthEnd++;
            break;

        case 2: // '\002'
            month = "March";
            monthEnd = 31;
            break;

        case 3: // '\003'
            month = "April";
            monthEnd = 30;
            break;

        case 4: // '\004'
            month = "May";
            monthEnd = 31;
            break;

        case 5: // '\005'
            month = "June";
            monthEnd = 30;
            break;

        case 6: // '\006'
            month = "July";
            monthEnd = 31;
            break;

        case 7: // '\007'
            month = "August";
            monthEnd = 31;
            break;

        case 8: // '\b'
            month = "September";
            monthEnd = 30;
            break;

        case 9: // '\t'
            month = "October";
            monthEnd = 31;
            break;

        case 10: // '\n'
            month = "November";
            monthEnd = 30;
            break;

        case 11: // '\013'
            month = "December";
            monthEnd = 31;
            break;
        }
        int relative = comp.get(7);
        output = output + "\n<form><table border=0 cellpadding=0 cellspacing=0 width=141>";
        output = output + "\n\t\t<tr>";
        output = output + "\n\t\t\t<td bgcolor=" + color + " width=6><a href=\"/ims/ShowCalendar?year=" + cal.get(1) + "&month=" + cal.get(2) + "&direct=prev&form=" + form + "&field=" + field + "&color=" + color + "\"><img src=\"/ims/images/browseLeft.gif\" width=6 height=12 hspace=2 border=0></a></td>";
        output = output + "\n\t\t\t<td bgcolor=" + color + " align=center><font face=\"Arial,Helvetica\" size=-1 color=ffffff><b>" + month + " " + cal.get(1) + "</b></font></td>";
        output = output + "\n\t\t\t<td bgcolor=" + color + " width=6><a href=\"/ims/ShowCalendar?year=" + cal.get(1) + "&month=" + cal.get(2) + "&direct=next&form=" + form + "&field=" + field + "&color=" + color + "\"><img src=\"/ims/images/browseRight.gif\" width=6 height=12 hspace=2 border=0></a></td>";
        output = output + "\n\t\t</tr>";
        output = output + "\n</table>";
        output = output + "\n<table border=0 cellpadding=0 cellspacing=0 width=141>";
        output = output + "\n\t\t<tr align=right>";
        output = output + "\n\t\t        <td></td>";
        output = output + "\n\t\t        <td><font face=\"Tahoma,Arial,Helvetica\" color=" + color + " size=-2><b>S</b></font></td>";
        output = output + "\n\t\t        <td><font face=\"Tahoma,Arial,Helvetica\" color=" + color + " size=-2><b>M</b></font></td>";
        output = output + "\n\t\t        <td><font face=\"Tahoma,Arial,Helvetica\" color=" + color + " size=-2><b>T</b></font></td>";
        output = output + "\n\t\t        <td><font face=\"Tahoma,Arial,Helvetica\" color=" + color + " size=-2><b>W</b></font></td>";
        output = output + "\n\t\t        <td><font face=\"Tahoma,Arial,Helvetica\" color=" + color + " size=-2><b>R</b></font></td>";
        output = output + "\n\t\t        <td><font face=\"Tahoma,Arial,Helvetica\" color=" + color + " size=-2><b>F</b></font></td>";
        output = output + "\n\t\t        <td><font face=\"Tahoma,Arial,Helvetica\" color=" + color + " size=-2><b>S</b></font></td>";
        output = output + "\n\t\t        <td></td>";
        output = output + "\n\t\t</tr>";
        output = output + "\n \t\t<tr align=right bgcolor=e5e5e5 >";
        output = output + "\n\t\t\t<td>&nbsp</td>";
        int count = 1;
        for(int i = 1; i <= relative - 1; i++)
        {
            output = output + "\n\t\t\t<td><!-- -->&nbsp</td>";
            count++;
        }

        boolean grey = true;
        for(int i = 1; i <= monthEnd; i++)
        {
            output = output + "\n\t\t\t<td><a href=\"javascript:winupdate('" + cal.get(1) + "', '" + (cal.get(2) + 1) + "', '" + i + "')\"><font face=\"Tahoma,Arial,Geneva\" size=-2 color=" + color + "><i></i>" + i + "</font></a><!-- --></td>";
            count++;
            if(relative == 7 || relative == 14 || relative == 21 || relative == 28 || relative == 35)
            {
                output = output + "\n       \t\t\t<td>&nbsp</td>";
                output = output + "\n\t\t</tr>";
                if(grey)
                {
                    grey = false;
                    output = output + "\n\t\t<tr align=right>";
                } else
                {
                    grey = true;
                    output = output + "\n\t\t<tr align=right bgcolor=e5e5e5>";
                }
                output = output + "\n\t\t\t<td>&nbsp</td>";
                count++;
                count++;
            }
            relative++;
        }

        if(count % 9 != 0)
            for(; count % 9 != 0; count++)
                output = output + "\n\t\t\t<td>&nbsp</td>";

        output = output + "\n\t\t</tr>";
        output = output + "\n</table>\n</form>";
        return output;
    }
}
