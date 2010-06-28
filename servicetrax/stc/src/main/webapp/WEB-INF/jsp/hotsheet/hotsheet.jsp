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

        .detailsDropdown {
            width: 125px;
        }

        .detailsTable td {
            padding-left: 0;
            padding-right: 0;
        }
    </style>

    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/js/yui281/build/fonts/fonts-min.css"/>

    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/js/yui281/build/button/assets/skins/sam/button.css"/>

    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/js/yui281/build/container/assets/container.css"/>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/yahoo-dom-event/yahoo-dom-event.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/connection/connection-min.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/element/element-min.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/button/button-min.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/dragdrop/dragdrop-min.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/container/container-min.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/json/json-min.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/hotsheet.js"></script>


</head>

<script type="text/javascript">

    function submitAction(url) {
        var hotSheetForm = document.getElementById('hotSheetForm');
        var path = "${pageContext.request.contextPath}";
        hotSheetForm.action = path + url;
        hotSheetForm.submit();
    }
</script>


<body class="yui-skin-sam" onload="checkForPrint();">

<div style="width: 100%; height:1100px; border: 2px solid #a9a9a9; ">

    <div style="color:white; background:#00008b; height:25px; text-align:center; vertical-align:middle; font-weight:bold; width:100%;">
        <label>HOT SHEET</label>
    </div>

    <form:form action="${pageContext.request.contextPath}/hotSheetSave.html" method="post"
               id="hotSheetForm" commandName="hotSheet">

    <form:errors path="*" cssStyle="font-size:18px;"/>

    <c:if test="${errors != null && fn:length(errors) > 0}">
        <ul style="padding-left:30px;" type="disc">
            <c:forEach items="${errors}" var="anError">
                <li style="color:red;">
                    <c:out value="${anError}"/>
                </li>
            </c:forEach>
        </ul>
    </c:if>

    <form:hidden path="hotSheetId"/>
    <form:hidden path="shouldPrint"/>
    <form:hidden path="requestId"/>
    <form:hidden path="projectId"/>
    <form:hidden path="jobLocationContactId"/>
    <form:hidden path="customerId"/>
    <form:hidden path="endUserId"/>
    <form:hidden path="hotSheetNumber"/>
    <form:hidden path="requestTypeId"/>

    <form:hidden path="jobLocationAddressId"/>
    <form:hidden path="jobLocationAddress.city"/>
    <form:hidden path="jobLocationAddress.state"/>
    <form:hidden path="jobLocationAddress.zip"/>

        <%-- originAddressId is the key for the origin address dropdown --%>
    <form:hidden path="originAddress.city"/>
    <form:hidden path="originAddress.state"/>
    <form:hidden path="originAddress.zip"/>

    <form:hidden path="extCustomerId"/>
    <form:hidden path="billingAddress.city"/>
    <form:hidden path="billingAddress.state"/>
    <form:hidden path="billingAddress.zip"/>

    <form:hidden path="requestCreatedName"/>
    <form:hidden path="requestCreatedDate"/>
    <form:hidden path="requestModifiedName"/>
    <form:hidden path="requestModifiedDate"/>

    <form:hidden path="dateCreated"/>
    <form:hidden path="createdBy"/>
    <form:hidden path="createdByName"/>
    <form:hidden path="dateModified"/>
    <form:hidden path="modifiedBy"/>
    <form:hidden path="modifiedByName"/>

    <form:hidden path="originContactName"/>

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

    function initializeDropdown(e) {
        handleChange('US');
    }

    YAHOO.util.Event.addListener(window, "load", initializeDropdown);

</script>

<div id="addJobLocation" class="yui-panel">
    <div class="hd">Please enter new origin address information</div>
    <div class="bd">

        <form:form name="addJobLocationForm" id="addJobLocationForm" commandName="address"
                   action="${pageContext.request.contextPath}/addJobLocation.html" method="post">
            <table border="0" cellspacing="5" cellpadding="0">
                <input type="hidden" name="jobLocationCustomerId" value="${hotSheet.customerId}"/>
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
                        <br>
                        <span style="font-size:10px;">(optional)</span>
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

<div id="addOriginContact" class="yui-panel">
    <div class="hd">Please enter new contact information</div>
    <div class="bd">

        <form:form name="addOriginContactForm" id="addOriginContactForm"
                   action="${pageContext.request.contextPath}/addOriginContact.html" method="post">
            <table border="0" cellspacing="5" cellpadding="0">
                <input type="hidden" name="customerId" value="${hotSheet.customerId}"/>
                <input type="hidden" name="extDealerId" value="${hotSheet.extCustomerId}"/>
                <tr>
                    <td>
                        Name:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="contactName" id="contactName"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Phone:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="contactPhone" id="contactPhone"/>
                        </label>
                    </td>
                </tr>
            </table>
        </form:form>
    </div>
</div>


<script type="text/javascript">

    //we need three because we have different actions on our hotSheetController
    YAHOO.namespace("example.container");
    YAHOO.util.Event.onDOMReady(function () {

        // Event handlers
        var handleSaveSubmit = function() {
            document.getElementById('saveHotsheet').style.visibility = "hidden";
            document.getElementById('saveProgress').style.visibility = "visible";
            var buttons = YAHOO.example.container.confirmSave.getButtons();
            for (var i = 0; i < buttons.length; i++) {
                buttons[i].set('disabled', true);
            }

            var hotSheetForm = document.getElementById('hotSheetForm');
            var path = "/stc";
            hotSheetForm.action = path + '/hotSheetSave.html';
            hotSheetForm.submit();
        };

        var handleCopySubmit = function() {
            document.getElementById('copyHotsheet').style.visibility = "hidden";
            document.getElementById('copyProgress').style.visibility = "visible";
            var hotSheetForm = document.getElementById('hotSheetForm');
            var path = "${pageContext.request.contextPath}";
            hotSheetForm.action = path + '/hotSheetCopy.html';
            hotSheetForm.submit();
        };


        var handlePrintSubmit = function() {
            document.getElementById('printHotsheet').style.visibility = "hidden";
            document.getElementById('printProgress').style.visibility = "visible";
            var hotSheetForm = document.getElementById('hotSheetForm');
            var path = "${pageContext.request.contextPath}";
            hotSheetForm.action = path + '/hotSheetReport.html';
            hotSheetForm.submit();
        };


        var handleCancel = function() {
            YAHOO.example.container.confirmSave.hide();
            YAHOO.example.container.confirmPrint.hide();
            YAHOO.example.container.confirmCopy.hide();
        };

        // Remove progressively enhanced content class, just before creating the module
        YAHOO.util.Dom.removeClass("confirmSave", "yui-pe-content");
        YAHOO.util.Dom.removeClass("confirmPrint", "yui-pe-content");
        YAHOO.util.Dom.removeClass("confirmCopy", "yui-pe-content");

        // Instantiate the save Dialog
        YAHOO.example.container.confirmSave = new YAHOO.widget.Dialog("confirmSave",
                                                                      {
                                                                          width : "20em",
                                                                          fixedcenter : true,
                                                                          visible : false,
                                                                          constraintoviewport : true,
                                                                          buttons : [
                                                                              { text:"Save", handler:handleSaveSubmit, isDefault:true },
                                                                              { text:"Cancel", handler:handleCancel }
                                                                          ]
                                                                      });

        // Instantiate the copy Dialog
        YAHOO.example.container.confirmCopy = new YAHOO.widget.Dialog("confirmCopy",
                                                                      {
                                                                          width : "20em",
                                                                          fixedcenter : true,
                                                                          visible : false,
                                                                          constraintoviewport : true,
                                                                          buttons : [
                                                                              {text:"Copy", handler:handleCopySubmit, isDefault:true},
                                                                              {text:"Cancel", handler:handleCancel }
                                                                          ]
                                                                      });

        // Instantiate the print Dialog
        YAHOO.example.container.confirmPrint = new YAHOO.widget.Dialog("confirmPrint",
                                                                       {
                                                                           width : "20em",
                                                                           fixedcenter : true,
                                                                           visible : false,
                                                                           constraintoviewport : true,
                                                                           buttons : [
                                                                               {text:"Print", handler:handlePrintSubmit, isDefault:true},
                                                                               {text:"Cancel", handler:handleCancel }
                                                                           ]
                                                                       });
        // Render the Dialogs
        YAHOO.example.container.confirmSave.render();
        YAHOO.example.container.confirmCopy.render();
        YAHOO.example.container.confirmPrint.render();

        YAHOO.util.Event.addListener("saveButton", "click", YAHOO.example.container.confirmSave.show, YAHOO.example.container.confirmSave, true);
        YAHOO.util.Event.addListener("copyButton", "click", YAHOO.example.container.confirmCopy.show, YAHOO.example.container.confirmCopy, true);
        YAHOO.util.Event.addListener("printButton", "click", YAHOO.example.container.confirmPrint.show, YAHOO.example.container.confirmPrint, true);
    });
</script>

<div id="confirmSave" class="yui-panel">
    <div class="hd">HOT SHEET SAVE CONFIRMATION</div>
    <div class="bd" style="text-align:center; font-size:14px;">
        <label id="saveHotsheet">
            Save this Hotsheet?
        </label>
        <label id="saveProgress" style="visibility:hidden;">
            <img src="images/saving.gif" alt="">
        </label>
    </div>
</div>

<div id="confirmCopy" class="yui-panel">
    <div class="hd">HOT SHEET COPY CONFIRMATION</div>
    <div class="bd" style="text-align:center; font-size:14px;">
        <label id="copyHotsheet">
            Copy this Hotsheet?
        </label>
        <label id="copyProgress" style="visibility:hidden;">
            <img src="images/saving.gif" alt="">
        </label>
    </div>
</div>


<div id="confirmPrint" class="yui-panel">
    <div class="hd">HOT SHEET PRINT CONFIRMATION</div>
    <div class="bd" style="text-align:center; font-size:14px;">
        <label id="printHotsheet">
            Print this Hotsheet?
        </label>
        <label id="printProgress" style="visibility:hidden;">
            <img src="images/saving.gif" alt="">
        </label>
    </div>
</div>

<script type="text/javascript">

    function checkForPrint() {

        var shouldPrint = document.getElementById("shouldPrint").value;
        if (shouldPrint != undefined && shouldPrint == 'true') {
            var hotSheetId = document.getElementById("hotSheetId").value;
            if (hotSheetId == undefined || hotSheetId == '') {
                alert("Invalid hot sheet id. Printing not available.");
            }
            else {
                makeRequest(hotSheetId);
            }
        }
    }

    function makeRequest(hotSheetId) {
        var hotSheetForm = document.getElementById('hotSheetForm');
        var path = "${pageContext.request.contextPath}";
        hotSheetForm.action = path + '/hotSheetPrint.html';
        hotSheetForm.submit();
    }

</script>
</body>
</html>

