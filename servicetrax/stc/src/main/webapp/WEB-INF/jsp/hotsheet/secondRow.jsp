<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<script type="text/javascript">

    YAHOO.util.Event.on('originAddressId', 'change', function (event) {
        var callbacks = {

            success : function (o) {
                var messages = [];
                try {
                    messages = YAHOO.lang.JSON.parse(o.responseText);
                    document.getElementById("originAddress.jobLocationName").value = messages['jobLocationName'];
                    document.getElementById("originAddress.streetOne").value = messages['streetOne'];
                    document.getElementById("originAddress.streetTwo").value = messages['streetTwo'];
                    var cityStateZip = messages['city'] + ' ' + messages['state'] + ' ' + messages['zip'];
                    document.getElementById("cityStateZip").value = cityStateZip;
                }
                catch (exception) {
                    alert("JSON Parse failed: " + exception);
                }
            },

            failure : function (o) {
                if (!YAHOO.util.Connect.isCallInProgress(o)) {
                    alert("Async call failed!");
                }
            },

            // 10 second timeout
            timeout : 10000
        };

        var id = event.currentTarget.value;
        var url = '<%=request.getContextPath()%>' + '/updateOriginAddress.html?jobLocationId=' + id;
        YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
    });
</script>

<%--Second Row--%>
<table border="0" cellpadding="1" cellspacing="2" style="width: 800px; margin-top: 15px;">
    <col style="width:28%">
    <col style="width:8%">
    <col style="width:28%">
    <col style="width:8%">
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
            <form:select path="originAddressId" cssStyle="min-width:225px; max-width:225px;">
                <form:options items="${hotSheet.originAddresses}" itemValue="key" itemLabel="value"/>
            </form:select>
        </td>
    </tr>

    <tr>
        <td>
            <form:input path="originAddress.jobLocationName" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="jobLocationAddress.jobLocationName" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="originAddress.jobLocationName" readonly="true" cssClass="disabledCell"/>
        </td>
    </tr>

    <tr>
        <td>
            <form:input path="originAddress.streetOne" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="jobLocationAddress.streetOne" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="originAddress.streetOne" readonly="true" cssClass="disabledCell"/>
        </td>
    </tr>
    <tr>
        <td>
            <form:input path="originAddress.streetTwo" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="jobLocationAddress.streetTwo" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="originAddress.streetTwo" readonly="true" cssClass="disabledCell"/>
        </td>
    </tr>

    <tr>
        <td>
            <input type="text" readonly="true" class="disabledCell" id="cityStateZip"
                   value="<c:out value='${hotSheet.originAddress.city}, ${hotSheet.originAddress.state} ${hotSheet.originAddress.zip}'/>">
        </td>
        <td>
            <label>
                <input type="button" value="New" id="show"
                       style=" background:#d3d3d3"/>
            </label>
        </td>
        <td>
            <label>
                <input type="text" readonly="true" class="disabledCell"
                       value="<c:out value='${hotSheet.jobLocationAddress.city}, ${hotSheet.jobLocationAddress.state} ${hotSheet.jobLocationAddress.zip}'/>">
            </label>
        </td>
        <td>
            &nbsp;
        </td>
        <td>
            <input type="text" readonly="true" class="disabledCell"
                   value="<c:out value='${hotSheet.originAddress.city}, ${hotSheet.originAddress.state} ${hotSheet.originAddress.zip}'/>">
        </td>
    </tr>
</table>
