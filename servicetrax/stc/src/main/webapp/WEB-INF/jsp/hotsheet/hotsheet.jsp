<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
<head>
    <title>Hot Sheet Entry</title>

    <style type="text/css">
        .disabledCell {
            background: #d3d3d3;
            color: #000000;
            width: 200px;
        }

        .regularCell {
            width: 200px;
        }

        .details {
            width: 25px;
            text-align: center;
        }
    </style>

    <link rel="stylesheet" type="text/css" href="/js/yui/fonts/fonts-min.css"/>
    <link rel="stylesheet" type="text/css" href="/js/yui/button/assets/button.css"/>
    <link rel="stylesheet" type="text/css" href="/js/yui/container/assets/container.css"/>

    <script type="text/javascript"
            src="http://yui.yahooapis.com/2.8.1/build/yahoo-dom-event/yahoo-dom-event.js"></script>

    <script type="text/javascript"
            src="http://yui.yahooapis.com/2.8.1/build/connection/connection-min.js"></script>

    <script type="text/javascript"
            src="http://yui.yahooapis.com/2.8.1/build/element/element-min.js"></script>

    <script type="text/javascript"
            src="http://yui.yahooapis.com/2.8.1/build/button/button-min.js"></script>

    <script type="text/javascript"
            src="http://yui.yahooapis.com/2.8.1/build/dragdrop/dragdrop-min.js"></script>

    <script type="text/javascript"
            src="http://yui.yahooapis.com/2.8.1/build/container/container-min.js"></script>

    <script type="text/javascript"
            src="http://yui.yahooapis.com/2.8.1/build/json/json-min.js"></script>


</head>

<script type="text/javascript">

    function submitAction(url) {
        var hotSheetForm = document.getElementById('hotSheetForm');
        var path = "${pageContext.request.contextPath}";
        hotSheetForm.action = path + url;
        hotSheetForm.submit();
    }
</script>


<body class="yui-skin-sam">

<div style="width: 100%; height:1020px; border: 2px solid #a9a9a9; ">

    <div style="color:white; background:#00008b; height:25px; text-align:center; vertical-align:middle; font-weight:bold; width:100%;">
        <label>HOT SHEET</label>
    </div>

    <c:if test="${errors != null && fn:length(errors) > 0}">
        <c:forEach items="${errors}" var="anError">
            ERROR!! <c:out value="${anError.defaultMessage}"/>
        </c:forEach>
    </c:if>

    <form:form action="${pageContext.request.contextPath}/hotSheetSave.html" method="post"
               id="hotSheetForm" commandName="hotSheet">

    <form:hidden path="hotSheetId"/>
    <form:hidden path="requestId"/>
    <form:hidden path="projectId"/>
    <form:hidden path="jobLocationContactId"/>
    <form:hidden path="customerId"/>
    <form:hidden path="endUserId"/>
    <form:hidden path="hotSheetNumber"/>

    <form:hidden path="jobLocationAddressId"/>
    <form:hidden path="jobLocationAddress.city"/>
    <form:hidden path="jobLocationAddress.state"/>
    <form:hidden path="jobLocationAddress.zip"/>

        <%-- originAddressId is the key for the origin address dropdown --%>
    <form:hidden path="originAddress.city"/>
    <form:hidden path="originAddress.state"/>
    <form:hidden path="originAddress.zip"/>

    <form:hidden path="billingAddressId"/>
    <form:hidden path="billingAddress.city"/>
    <form:hidden path="billingAddress.state"/>
    <form:hidden path="billingAddress.zip"/>

    <form:hidden path="requestCreatedName"/>
    <form:hidden path="requestCreatedDate"/>
    <form:hidden path="requestModifiedName"/>
    <form:hidden path="requestModifiedDate"/>

    <form:hidden path="createdBy"/>

    <jsp:include page="firstRow.jsp" flush="true">
        <jsp:param name="hotSheet" value="${hotSheet}"/>
    </jsp:include>

    <jsp:include page="secondRow.jsp" flush="true">
        <jsp:param name="hotSheet" value="${hotSheet}"/>
    </jsp:include>

    <jsp:include page="thirdRow.jsp" flush="true">
        <jsp:param name="hotSheet" value="${hotSheet}"/>
    </jsp:include>

    <jsp:include page="fourthRow.jsp" flush="true">
        <jsp:param name="hotSheet" value="${hotSheet}"/>
    </jsp:include>

    <jsp:include page="lastRows.jsp" flush="true">
        <jsp:param name="hotSheet" value="${hotSheet}"/>
    </jsp:include>

    <c:if test="${errors != null}">
        <ul style="color:black; list-style-type:disc; text-align:left;">
            <c:forEach items="${errors}" var="anError">
                <li>
                    <form:errors path="${anError.field}" cssClass="errorMessages"/>
                </li>
            </c:forEach>
        </ul>
    </c:if>
</div>
</form:form>

<%--
  Created by IntelliJ IDEA.
  User: pgarvie
  Date: May 22, 2010
  Time: 4:29:13 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/stateProvince.js"></script>

<script type="text/javascript">

    YAHOO.namespace("example.container");
    YAHOO.util.Event.onDOMReady(function () {

        // Define various event handlers for Dialog
        var handleSubmit = function() {
            this.submit();
        };
        var handleCancel = function() {
            this.cancel();
        };
        var handleSuccess = function(o) {
            var response = o.responseText;
            response = response.split("<!")[0];
            document.getElementById("resp").innerHTML = response;
        };
        var handleFailure = function(o) {
            alert("Submission failed: " + o.status);
        };

        // Remove progressively enhanced content class, just before creating the module
        YAHOO.util.Dom.removeClass("dialog1", "yui-pe-content");

        // Instantiate the Dialog
        YAHOO.example.container.dialog1 = new YAHOO.widget.Dialog("dialog1",
                                                                  { width : "30em",
                                                                      fixedcenter : true,
                                                                      visible : false,
                                                                      constraintoviewport : true,
                                                                      buttons : [
                                                                          { text:"Submit", handler:handleSubmit, isDefault:true },
                                                                          { text:"Cancel", handler:handleCancel }
                                                                      ]
                                                                  });

        // Validate the entries in the form to require that both first and last name are entered
        YAHOO.example.container.dialog1.validate = function() {

            var data = this.getData();
            if (data.jobLocationName == "") {
                alert("A job location name is required.");
                return false;
            }
            else {
                return true;
            }
        };

        // Wire up the success and failure handlers
        YAHOO.example.container.dialog1.callback = {
            success: handleSuccess,
            failure: handleFailure
        };

        // Render the Dialog
        YAHOO.example.container.dialog1.render();

        YAHOO.util.Event.addListener("show", "click", YAHOO.example.container.dialog1.show, YAHOO.example.container.dialog1, true);
        YAHOO.util.Event.addListener("hide", "click", YAHOO.example.container.dialog1.hide, YAHOO.example.container.dialog1, true);
    });

    function initializeDropdown(e) {
        handleChange('US');
    }
    YAHOO.util.Event.addListener(window, "load", initializeDropdown);

</script>


<div id="dialog1" class="yui-panel">
    <div class="hd">Please enter new origin address information</div>
    <div class="bd">

        <form:form name="addJobLocationForm" id="addJobLocationForm" commandName="address"
                   action="${pageContext.request.contextPath}/addJobLocation.html" method="post">
            <table border="0" cellspacing="5" cellpadding="0">
                <tr>
                    <td>
                        Location Name:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="jobLocationName" id="jobLocationName"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Address:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="streetOne" id="streetOne"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Address Two:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="streetTwo"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        City:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="city" id="city"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        State/Province:
                    </td>
                    <td>
                        <label>
                            <select name="state" style="width:150px;" id="state"></select>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Zip:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="zip" id="zip"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Country:
                    </td>
                    <td>
                        <label>
                            <select name="country" id="country" style="width:150px;"
                                    onchange="handleChange(this.options[this.selectedIndex].value);">
                                <option value="US" selected="selected">United States</option>
                                <option value="CA">Canada</option>
                            </select>
                        </label>
                    </td>
                </tr>
            </table>
        </form:form>
    </div>
</div>


</body>
</html>