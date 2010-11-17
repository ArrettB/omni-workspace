<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<%--Second Row--%>
<table border="0" cellpadding="1" cellspacing="2" style="width: 790px; margin-top: 15px;">
<col style="width:28%">
<col style="width:5%">
<col style="width:24%">
<col style="width:5%">
<col>

<tr>
    <td>
        Origin Address:
    </td>
    <td>&nbsp;</td>
    <td>
        Destination Address:
    </td>
    <td>&nbsp;</td>
    <td>
        Billing Address:
    </td>
</tr>

<tr>
    <td>
        <form:select path="originAddressId" cssStyle="min-width:225px; max-width:225px;" id="originAddressDropdown">
            <form:options items="${hotSheet.originAddresses}" itemValue="jobLocationId"
                          itemLabel="jobLocationName"/>
        </form:select>
    </td>
    <td>
        <div id="spinner" style="visibility:hidden; text-align:center;">
            <img src="images/ajax-loader.gif" alt="Working...">
        </div>
    </td>
    <td>
        <form:select path="jobLocationAddressId" cssStyle="min-width:225px; max-width:225px;"
                     id="destinationAddressDropdown">
            <form:options items="${hotSheet.destinationAddresses}" itemValue="jobLocationId"
                          itemLabel="jobLocationName"/>
        </form:select>
    </td>
    <td>
        <div id="destinationAddressSpinner" style="visibility:hidden; text-align:center;">
            <img src="images/ajax-loader.gif" alt="Working...">
        </div>
    </td>
    <td>
        <form:input path="billingAddress.jobLocationName" readonly="true" cssClass="disabledCell"
                    cssStyle="width:225px;"/>
    </td>
</tr>

<tr>
    <td>
        <form:input path="originAddress.jobLocationName" readonly="true" cssClass="disabledCell"/>
    </td>
    <td>
        <input type="button" value="New" id="newOriginAddress" style=" background:#d3d3d3"/>
    </td>
    <td>
        <form:input path="jobLocationAddress.jobLocationName" readonly="true" cssClass="disabledCell"/>
    </td>
    <td>
        <input type="button" value="New" id="addDestinationButton" style=" background:#d3d3d3"/>
    </td>
    <td>
        <form:input path="billingAddress.streetOne" readonly="true" cssClass="disabledCell"
                    cssStyle="width:225px;"/></td>
</tr>

<tr>
    <td>
        <form:input path="originAddress.streetOne" readonly="true" cssClass="disabledCell"/>
    </td>
    <td>
        &nbsp;
    </td>
    <td>
        <form:input path="jobLocationAddress.streetOne" readonly="true" cssClass="disabledCell"/>
    </td>
    <td>&nbsp;</td>
    <td>
        <form:input path="billingAddress.streetTwo" readonly="true" cssClass="disabledCell" cssStyle="width:225px;"/>
    </td>
</tr>
<tr>
<tr>
    <td>
        <input type="text" readonly="true" class="disabledCell" id="cityStateZip"
               value="<c:out value='${hotSheet.originAddress.city}, ${hotSheet.originAddress.state} ${hotSheet.originAddress.zip}'/>">
    </td>
    <td>&nbsp;</td>
    <td>
        <label>
            <input type="text" readonly="true" class="disabledCell" id="destinationCityStateZip"
                   value="<c:out value='${hotSheet.jobLocationAddress.city}, ${hotSheet.jobLocationAddress.state} ${hotSheet.jobLocationAddress.zip}'/>">
        </label>
    <td>&nbsp;</td>
    <td>
        <input type="text" readonly="true" class="disabledCell" style="width:225px;"
               value="<c:out value='${hotSheet.billingAddress.city}, ${hotSheet.billingAddress.state} ${hotSheet.billingAddress.zip}'/>">
    </td>
</tr>

<tr>
    <td>
        <form:select path="originContactId" cssStyle="min-width:225px; max-width:225px;" id="originContactDropdown">
            <form:options items="${hotSheet.originContacts}" itemValue="key"
                          itemLabel="value"/>
        </form:select>
        <form:input path="originContactPhone" readonly="true" cssClass="disabledCell"/>
    </td>

    <td>
        <input type="button" value="New" id="newOriginContact" style=" background:#d3d3d3"/>
    </td>

    <td>
        <form:select path="jobLocationContactId" cssStyle="min-width:225px; max-width:225px;"
                     id="destinationContactDropdown">
            <form:options items="${hotSheet.destinationAddressContacts}"
                          itemValue="key"
                          itemLabel="value"/>
        </form:select>
        <form:input path="jobContactPhone" readonly="true" cssClass="disabledCell"/>
    </td>

    <td>
        <input type="button" value="New" id="newDestinationContact" style=" background:#d3d3d3"/>
    </td>

    <td rowspan="4">
        <table border="0" cellpadding="1" cellspacing="1" width="75%" style="font-size:12px; margin-top:0;">
            <tr>
                <td align="right" style="color:red;">
                    <a href="#" id="calStartAnchor"
                       onclick="doCalendar(); return false;" style="text-decoration:none;">
                        <img src="images/icon-calendar.gif" alt="Calendar"/>
                    </a>
                    <label style="vertical-align:5px;">Date:</label>
                </td>
                <td colspan="3">
                    <label>
                        <input type="text"
                               style="width:75px; background:#d3d3d3; color:#000000; text-align:center;"
                               name="jobDate" id="jobDate" class="calendar" readonly="true"
                               value="<fmt:formatDate value="${hotSheet.jobDate}" pattern="MM/dd/yyyy"/>">
                    </label>
                </td>
            </tr>
            <tr>
                <td align="right" style="color:red;">
                    <label style="white-space:nowrap;">Whse. Start:</label>
                </td>
                <td>
                    <label>
                        <form:select path="warehouseStartTimeHour" id="warehouseStartTimeHour"
                                     cssStyle="max-width:45px;">
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
                        <form:select path="warehouseStartTimeMinutes" id="warehouseStartTimeMinutes"
                                     cssStyle="max-width:45px;">
                            <form:option value="00"/>
                            <form:option value="15"/>
                            <form:option value="30"/>
                            <form:option value="45"/>
                        </form:select>
                    </label>
                </td>

                <td>
                    <label>
                        <form:select path="warehouseStartTimeAMPM" id="warehouseStartTimeAMPM"
                                     cssStyle="max-width:48px;">
                            <form:option value="AM"/>
                            <form:option value="PM"/>
                        </form:select>
                    </label>
                </td>
            </tr>

            <tr>
                <td align="right" style="color:red;">
                    <label style="white-space:nowrap;">Onsite Start:</label>
                </td>
                <td>
                    <label>
                        <form:select path="startTimeHour" id="startTimeHour" cssStyle="max-width:45px;">
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
                        <form:select path="startTimeMinutes" id="startTimeMinutes"
                                     cssStyle="max-width:45px;">
                            <form:option value="00"/>
                            <form:option value="15"/>
                            <form:option value="30"/>
                            <form:option value="45"/>
                        </form:select>
                    </label>
                </td>

                <td>
                    <label>
                        <form:select path="startTimeAMPM" id="startTimeAMPM" cssStyle="max-width:48px;">
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
                        hrs.
                    </label>
                </td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td colspan="4">
    <span style="position: relative; top: 0.7em;  margin-left: 15px; font-weight:bold; background: #d3d3d3; color:#000000;">
      Vehicle Type & Qty
    </span>

        <div style="text-align:left; border: 1.5px solid #000000; padding-bottom:10px; padding-top:15px">
            <table width="100%">
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
                        <form:input path="details[bobtail_qty].attributeValue"
                                    maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                    </td>
                    <td>
                        Bob Tail
                    </td>
                    <td>
                        <form:input path="details[box_van_qty].attributeValue"
                                    maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                    </td>
                    <td>
                        Box Van
                    </td>
                    <td>
                        <form:input path="details[tractor_qty].attributeValue"
                                    maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                    </td>
                    <td>
                        Tractor
                    </td>
                    <td>
                        <form:input path="details[trailer_qty].attributeValue"
                                    maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                    </td>
                    <td>
                        Trailer
                    </td>
                </tr>
            </table>
        </div>
    </td>

</table>
