<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/calendarPopup/CalendarPopup.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/calendarPopup.css">


<script type="text/javascript">

    var cal = new CalendarPopup("calendar");
    cal.setCssPrefix("calendar");

    function doCalendar() {
        cal.select(document.getElementById("jobDate"),
                   "calStartAnchor",
                   "MM/dd/yyyy");
    }
</script>

<div id="calendar"
     style="position:absolute; float:left; width:100px; visibility:hidden; background-color:#ffffff;"></div>

<%--Third Row--%>
<table style="margin-top:15px;">
    <tr>
        <td>
            <span style="position: relative; top: 0.7em;  margin-left: 15px; font-weight:bold; background: #d3d3d3; color:#000000;">
              Vehicle Type & Qty
            </span>

            <div style="text-align:left; border: 1.5px solid #000000; padding-bottom:20px;">
                <table style="width:225px; padding-top:25px;">
                    <col width="25px"/>
                    <col/>
                    <col width="25px"/>
                    <col/>

                    <tr>
                        <td>
                            <form:input path="details[service_van_qty].attributeValue"
                                        cssStyle="width:20px; margin-left:5px; text-align:center;"/>
                        </td>
                        <td>
                            Service Van
                        </td>
                        <td>
                            <form:input path="details[box_van_qty].attributeValue"
                                        cssStyle="width:20px; text-align:center;"/>
                        </td>
                        <td>
                            Box Van
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <form:input path="details[bobtail_qty].attributeValue"
                                        cssStyle="width:20px; margin-left:5px; text-align:center;"/>
                        </td>
                        <td>
                            Bob Tail
                        </td>
                        <td>
                            <form:input path="details[tractor_trailer_qty].attributeValue"
                                        cssStyle="width:20px; text-align:center;"/>
                        </td>
                        <td>
                            Tractor<br/>
                            /Trailer
                        </td>
                    </tr>
                </table>
            </div>
        </td>
        <td>
            <table style="margin-top:-50px; margin-left:40px; margin-right:25px;" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="padding-bottom:5px;">
                        <label style="font-weight:400;">Job Location Contact:</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <form:input path="jobContactName" cssClass="disabledCell"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <form:input path="jobContactPhone" cssClass="disabledCell"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <form:input path="jobContactEmail" cssClass="disabledCell"/>
                    </td>
                </tr>
            </table>
        </td>

        <td>
            <table border="0" cellpadding="1" cellspacing="1" style="padding-left:50px;">
                <tr>
                    <td align="right" style="color:red;">
                        <a href="#" id="calStartAnchor"
                           onclick="doCalendar(); return false;">
                            <img src="images/icon-calendar.gif" alt="Calendar"/>
                        </a>
                        Date:
                    </td>
                    <td colspan="3">
                        <label>
                            <input type="text" style="width:65px" id="jobDate" class="calendar">
                        </label>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="color:red;">
                        Start Time:
                    </td>
                    <td>
                        <label>
                            <select name="start_time_hour" id="start_time_hour">
                                <option value="0">12</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                                <option value="8">8</option>
                                <option value="9">9</option>
                                <option value="10">10</option>
                                <option value="11">11</option>
                            </select>
                        </label>
                    </td>
                    <td>
                        <label>
                            <select name="start_time_minutes" id="start_time_minutes">
                                <option value="00">00</option>
                                <option value="15">15</option>
                                <option value="30">30</option>
                                <option value="45">45</option>
                            </select>
                        </label>
                    </td>

                    <td>
                        <label>
                            <select name="start_time_AMPM" id="start_time_AMPM">
                                <option value="AM">AM</option>
                                <option value="PM">PM</option>
                            </select>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="color:red;">
                        Whse. Start:
                    </td>
                    <td>
                        <label>
                            <select name="start_time_hour" id="warehouse_time_hour">
                                <option value="0">12</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                                <option value="8">8</option>
                                <option value="9">9</option>
                                <option value="10">10</option>
                                <option value="11">11</option>
                            </select>
                        </label>
                    </td>
                    <td>
                        <label>
                            <select name="start_time_minutes" id="warehouse_time_minutes">
                                <option value="00">00</option>
                                <option value="15">15</option>
                                <option value="30">30</option>
                                <option value="45">45</option>
                            </select>
                        </label>
                    </td>

                    <td>
                        <label>
                            <select name="start_time_AMPM" id="warehouse_time_AMPM">
                                <option value="AM">AM</option>
                                <option value="PM">PM</option>
                            </select>
                        </label>
                    </td>
                </tr>

                <tr>
                    <td align="right" style="color:red;">
                        Job Length:
                    </td>
                    <td colspan="3">
                        <label>
                            <input type="text" style="width:35px">&nbsp;hrs.
                        </label>
                    </td>
                </tr>
            </table>
        </td>

    </tr>
</table>
