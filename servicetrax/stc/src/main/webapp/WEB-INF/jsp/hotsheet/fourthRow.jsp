<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--Third Row--%>
<table style="margin-top:15px;" border="0">
    <tr>
        <td>
<span style="position: relative; top: 0.7em;  margin-left: 25px; font-weight:bold; background: #d3d3d3; color:#000000;">
Special Instructions
</span>

            <div style="text-align:left; border: 1.5px solid #000000; padding-bottom:20px; padding-right:25px; padding-left:5px; margin-left:4px;">
                <form:textarea path="specialInstructions" cols="89" rows="9"
                               cssStyle="width:557px; margin-top:25px; margin-left:15px; margin-right:10px; border:solid 1px inset;"/>
            </div>
        </td>

        <td style="padding-left:8px;">
    <span style="position: relative; top: 0.7em;  margin-left: 25px; font-weight:bold; background: #d3d3d3; color:#000000;">
Positions
    </span>

            <div style="text-align:left; border: 1.5px solid #000000; padding-bottom:25px; margin-left:15px; padding-top:15px;">
                <table style="width:120px; padding-top:23px;">
                    <col width="25px"/>
                    <col/>

                    <tr>
                        <td>
                            <form:input path="details[lead_qty].attributeValue"
                                        maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                        </td>
                        <td>
                            Lead
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <form:input path="details[driver_qty].attributeValue"
                                        maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                        </td>
                        <td>
                            Driver
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <form:input path="details[installer_qty].attributeValue"
                                        maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                        </td>
                        <td>
                            Installer
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <form:input path="details[mover_qty].attributeValue"
                                        maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                        </td>
                        <td>
                            Mover
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding-bottom:5px;">
                            &nbsp;
                        </td>
                    </tr>

                </table>
            </div>
        </td>
    </tr>
</table>
