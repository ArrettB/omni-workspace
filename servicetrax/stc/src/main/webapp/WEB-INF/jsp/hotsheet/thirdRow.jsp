<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--Third Row--%>
<table style="margin-top:15px;">
<tr>
    <td>
            <span style="position: relative; top: 0.7em;  margin-left: 15px; font-weight:bold; background: #d3d3d3; color:#000000;">
              Vehicle Type & Qty
            </span>

        <div style="text-align:left; border: 1.5px solid #000000; padding-bottom:20px;">
            <table style="width:225px; padding-top:25px;">
                <col width="25px"/>
                <col/>
                <col width="25px"/>
                <col/>

                <tr>
                    <td>
                        <form:input path="details[service_van_qty].attributeValue"
                                    cssStyle="width:20px; margin-left:5px; text-align:center;"/>
                    </td>
                    <td>
                        Service Van
                    </td>
                    <td>
                        <form:input path="details[box_van_qty].attributeValue"
                                    cssStyle="width:20px; text-align:center;"/>
                    </td>
                    <td>
                        Box Van
                    </td>
                </tr>
                <tr>
                    <td>
                        <form:input path="details[bobtail_qty].attributeValue"
                                    cssStyle="width:20px; margin-left:5px; text-align:center;"/>
                    </td>
                    <td>
                        Bob Tail
                    </td>
                    <td>
                        <form:input path="details[tractor_trailer_qty].attributeValue"
                                    cssStyle="width:20px; text-align:center;"/>
                    </td>
                    <td>
                        Tractor<br/>
                        /Trailer
                    </td>
                </tr>
            </table>
        </div>
    </td>
    <td>
        <table style="margin-top:-50px; margin-left:50px; margin-right:25px;" cellpadding="0" cellspacing="0">
            <tr>
                <td style="padding-bottom:5px;">
                    <label style="font-weight:400;">Job Location Contact:</label>
                </td>
            </tr>
            <tr>
                <td>
                    <label>
                        <input type="text" disabled="true" value="Name"
                               style="background:#d3d3d3; width:225px;"/>
                    </label>
                </td>
            </tr>
            <tr>
                <td>
                    <label>
                        <input type="text" disabled="true" value="Phone"
                               style="background:#d3d3d3;  width:225px;"/>
                    </label>
                </td>
            </tr>
            <tr>
                <td>
                    <label>
                        <input type="text" disabled="true" value="email"
                               style="background:#d3d3d3; width:225px;"/>
                    </label>
                </td>
            </tr>
        </table>
    </td>

    <td>
        <table style="margin-left:20px;">
            <tr>
                <td align="right" style="color:red;">
                    Date:
                </td>
                <td>
                    <label>
                        <input type="text" style="width:65px">
                    </label>
                </td>
            </tr>
            <tr>
                <td align="right" style="color:red;">
                    Requested Start Time:
                </td>
                <td>
                    <label>
                        <input type="text" style="width:65px">
                    </label>
                </td>
            </tr>
            <tr>
                <td align="right" style="color:red;">
                    Whse. Start:
                </td>
                <td>
                    <label>
                        <input type="text" style="width:65px">
                    </label>
                </td>
            </tr>

            <tr>
                <td align="right" style="color:red;">
                    Job Length:
                </td>
                <td>
                    <label>
                        <input type="text" style="width:35px">&nbsp;hrs.
                    </label>
                </td>
            </tr>
        </table>
    </td>

</tr>
</table>
