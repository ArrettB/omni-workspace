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
<td>
<span style="position: relative; top: 0.7em;  margin-left: 15px; font-weight:bold; background: #d3d3d3; color:#000000;">
    Equipment
    </span>

    <div style="width:745px; text-align:left; border: 1.5px solid #000000; margin-left:5px; padding-bottom:20px; padding-left:20px; padding-top:15px;">
        <table style="padding-top:10px; width:750px; margin-left:-10px;" class="detailsTable">
            <tr>
                <td>
                    <form:input path="details[custom_equipment_A_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_A].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_B_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_B].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_C_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_C].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_1_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_1].name" cssClass="details"
                                cssStyle="width:100px; text-align:left;"/>
                </td>
            </tr>
            <tr>
                <td>
                    <form:input path="details[custom_equipment_D_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_D].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_E_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_E].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_F_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_F].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>

                <td>
                    <form:input path="details[custom_equipment_2_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_2].name" cssClass="details"
                                cssStyle="width:100px; text-align:left;"/>
                </td>
            </tr>

            <tr>
                <td>
                    <form:input path="details[custom_equipment_G_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_G].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_H_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_H].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_I_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_I].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>

                <td>
                    <form:input path="details[custom_equipment_3_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_3].name" cssClass="details"
                                cssStyle="width:100px; text-align:left;"/>
                </td>
            </tr>
            <tr>
                <td>
                    <form:input path="details[custom_equipment_J_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_J].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_K_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_K].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_L_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:select path="details[custom_equipment_L].name" items="${EquipmentList}"
                                 cssClass="detailsDropdown"/>
                </td>

                <td>
                    <form:input path="details[custom_equipment_4_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_4].name" cssClass="details"
                                cssStyle="width:100px; text-align:left;"/>
                </td>
            </tr>
        </table>
    </div>
</td>
