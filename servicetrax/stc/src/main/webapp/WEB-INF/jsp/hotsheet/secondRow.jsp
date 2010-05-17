<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


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
            <form:input path="endUserName" cssClass="regularCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="endUserName" cssClass="regularCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="endUserName" disabled="true" cssClass="disabledCell"/>
        </td>
    </tr>

    <tr>
        <td>
            <form:input path="endUserName" cssClass="regularCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="endUserName" cssClass="regularCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="endUserName" disabled="true" cssClass="disabledCell"/>
        </td>
    </tr>
    <tr>
        <td>
            <form:input path="endUserName" cssClass="regularCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="endUserName" cssClass="regularCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="endUserName" disabled="true" cssClass="disabledCell"/>
        </td>
    </tr>

    <tr>
        <td>
            <form:input path="endUserName" cssClass="regularCell"/>
        </td>
        <td>
            <label>
                <input type="button" value="New" onclick="alert('Not yet implemented');"
                       style=" background:#d3d3d3"/>
            </label>
        </td>
        <td>
            <form:input path="endUserName" cssClass="regularCell"/>
        </td>
        <td>
            <label>
                <input type="button" value="New" onclick="alert('Not yet implemented');"
                       style="background:#d3d3d3"/>
            </label>
        </td>
        <td>
            <form:input path="endUserName" disabled="true" cssClass="disabledCell"/>
        </td>
    </tr>
</table>