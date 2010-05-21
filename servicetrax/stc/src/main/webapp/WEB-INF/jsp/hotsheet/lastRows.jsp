<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script type="text/javascript">

    function closeWindow() {
        self.close();
        return false;
    }

</script>

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
                            <form:textarea path="description" cols="90" rows="4" readonly="true"
                                           cssStyle="color:#000000; background:#d3d3d3; margin-left:auto; margin-right:auto;"/>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
</table>

<table style="margin-top:15px;">
    <tr>
        <td>
<span style="position: relative; top: 0.7em;  margin-left: 15px; font-weight:bold; background: #d3d3d3; color:#000000;">
Audit Information
</span>

            <div style="text-align:left; border: 1.5px solid #000000; padding-bottom:20px; padding-left:10px; padding-right:10px;">
                <table style="padding-top:25px; width:500px;">
                    <col width="100px"/>
                    <col width="150px"/>
                    <col width="100px"/>
                    <col/>
                    <tr>
                        <td>
                            Date Created:
                        </td>
                        <td>
                            <fmt:formatDate value="${hotSheet.requestCreatedDate}" pattern="MM/dd/yyyy hh:mm a"/>
                        </td>
                        <td>
                            Date Modified:
                        </td>
                        <td>
                            <fmt:formatDate value="${hotSheet.requestModifiedDate}" pattern="MM/dd/yyyy hh:mm a"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Created By:
                        </td>
                        <td>
                            ${hotSheet.requestCreatedName}
                        </td>
                        <td>
                            Modified By:
                        </td>
                        <td>
                            ${hotSheet.requestModifiedName}
                        </td>
                    </tr>
                </table>
            </div>
        </td>
        <td>
            <table style="width:100px; padding-left:40px;" border="0 " cellpadding="2" cellspacing="2">
                <tr>
                    <td align="center">
                        <input type="submit" value="COPY" name="button"
                               style="width:67px; height:33px; background:#d3d3d3;"
                               onclick="submitAction('/hotSheetCopy.html')">
                    </td>
                    <td align="center">
                        <input type="submit" value="SAVE" name="button"
                               style="width:67px; height:33px; background:#d3d3d3;">
                    </td>
                    <td align="center">
                        <input type="submit" value="Close Window" name="button" onclick="return closeWindow();"
                               style="width:67px; height:33px; background:#d3d3d3; white-space:pre-wrap; word-wrap:break-word;">
                    </td>
                </tr>
                <tr>
                    <td colspan="3" align="center">
                        <input type="submit" value="Print BL" name="button"
                               style="width:220px; height:33px; background:#d3d3d3;"
                               onclick="submitAction('/hotSheetReport.html')">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

