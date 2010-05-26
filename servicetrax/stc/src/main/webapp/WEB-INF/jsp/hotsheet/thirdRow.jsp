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
     style="position:absolute; float:left; width:150px; visibility:hidden; background-color:#ffffff;"></div>

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
                                        maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                        </td>
                        <td>
                            Service Van
                        </td>
                        <td>
                            <form:input path="details[box_van_qty].attributeValue"
                                        maxlength="3" cssClass="details"/>
                        </td>
                        <td>
                            Box Van
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <form:input path="details[bobtail_qty].attributeValue"
                                        maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                        </td>
                        <td>
                            Bob Tail
                        </td>
                        <td>
                            <form:input path="details[tractor_trailer_qty].attributeValue"
                                        maxlength="3" cssClass="details"/>
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
                           onclick="doCalendar(); return false;" style="text-decoration:none;">
                            <img src="images/icon-calendar.gif" alt="Calendar"/>
                        </a>
                        Date:
                    </td>
                    <td colspan="3">
                        <label>
                            <input type="text" style="width:75px; background:#d3d3d3; color:#000000; text-align:center;"
                                   name="jobDate" id="jobDate" class="calendar" readonly="true"
                                   value="<fmt:formatDate value="${hotSheet.jobDate}" pattern="MM/dd/yyyy"/>">
                        </label>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="color:red;">
                        Start Time:
                    </td>
                    <td>
                        <label>
                            <form:select path="startTimeHour" id="startTimeHour">
                                <form:option value="12"/>
                                <form:option value="1"/>
                                <form:option value="2"/>
                                <form:option value="3"/>
                                <form:option value="4"/>
                                <form:option value="5"/>
                                <form:option value="6"/>
                                <form:option value="7"/>
                                <form:option value="8"/>
                                <form:option value="9"/>
                                <form:option value="10"/>
                                <form:option value="11"/>
                            </form:select>
                        </label>
                    </td>
                    <td>
                        <label>
                            <form:select path="startTimeMinutes" id="startTimeMinutes">
                                <form:option value="00"/>
                                <form:option value="15"/>
                                <form:option value="30"/>
                                <form:option value="45"/>
                            </form:select>
                        </label>
                    </td>

                    <td>
                        <label>
                            <form:select path="startTimeAMPM" id="startTimeAMPM">
                                <form:option value="AM"/>
                                <form:option value="PM"/>
                            </form:select>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="color:red;">
                        Whse. Start:
                    </td>
                    <td>
                        <label>
                            <form:select path="warehouseStartTimeHour" id="warehouseStartTimeHour">
                                <form:option value="12"/>
                                <form:option value="1"/>
                                <form:option value="2"/>
                                <form:option value="3"/>
                                <form:option value="4"/>
                                <form:option value="5"/>
                                <form:option value="6"/>
                                <form:option value="7"/>
                                <form:option value="8"/>
                                <form:option value="9"/>
                                <form:option value="10"/>
                                <form:option value="11"/>
                            </form:select>
                        </label>
                    </td>
                    <td>
                        <label>
                            <form:select path="warehouseStartTimeMinutes" id="warehouseStartTimeMinutes">
                                <form:option value="00"/>
                                <form:option value="15"/>
                                <form:option value="30"/>
                                <form:option value="45"/>
                            </form:select>
                        </label>
                    </td>

                    <td>
                        <label>
                            <form:select path="warehouseStartTimeAMPM" id="warehouseStartTimeAMPM">
                                <form:option value="AM"/>
                                <form:option value="PM"/>
                            </form:select>
                        </label>
                    </td>
                </tr>

                <tr>
                    <td align="right" style="color:red;">
                        Job Length:
                    </td>
                    <td>
                        <label>
                            <form:input path="jobLength" cssStyle="width:30px;" maxlength="4"/>
                        </label>
                    </td>
                    <td colspan="2">
                        <label>
                            &nbsp;
                        </label>
                    </td>
                </tr>
            </table>
        </td>

    </tr>
</table>
