<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

    </style>

</head>


<body>

<div style="width: 100%; height:1020px; border: 2px solid #a9a9a9; ">

    <div style="color:white; background:#00008b; height:25px; text-align:center; vertical-align:middle; font-weight:bold; width:100%;">
        <label>HOT SHEET</label>
    </div>

    <form:form action="${pageContext.request.contextPath}/saveClient.do" method="post" commandName="hotSheet">

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
