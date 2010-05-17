<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<table border="0" cellpadding="1" cellspacing="2" style="width: 800px; margin-top: 15px;">
    <col style="width:20%">
    <col style="width:30%">
    <col style="width:20%">
    <col>

    <tr>
        <td>
            Project Name:
        </td>
        <td>
            <form:input path="projectName" disabled="true" cssClass="disabledCell"/>
        </td>

        <td>
            Hot Sheet #:
        </td>
        <td>
            <form:input path="hotSheetIdentifier" disabled="true" cssClass="disabledCell"/>
        </td>
    </tr>

    <tr>
        <td>
            Customer Name:
        </td>

        <td>
            <form:input path="customerName" disabled="true" cssClass="disabledCell"/>
        </td>

        <td colspan="4">
            &nbsp;
        </td>

    </tr>

    <tr>
        <td>
            End User Name:
        </td>
        <td>
            <form:input path="endUserName" disabled="true" cssClass="disabledCell"/>
        </td>

        <td>
            PO#:
        </td>
        <td>
            <form:input path="hotSheetNumber" cssClass="regularCell"/>
        </td>
    </tr>
</table>