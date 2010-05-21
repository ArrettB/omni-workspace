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
</body>
</html>