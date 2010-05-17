<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--Third Row--%>
<table style="margin-top:15px;" border="0">
    <tr>
        <td>
<span style="position: relative; top: 0.7em;  margin-left: 15px; font-weight:bold; background: #d3d3d3; color:#000000;">
Narrative Work Request
</span>

            <div style="text-align:left; border: 1.5px solid #000000; padding-bottom:20px; padding-left:10px; padding-right:10px;">
                <table style="width:100%; padding-top:25px;">
                    <tr>
                        <td>
                            <form:textarea path="endUserName" cols="90" rows="4" disabled="true"
                                           cssStyle="color:#000000; background:#d3d3d3; margin-left:auto; margin-right:auto;"/>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
</table>
