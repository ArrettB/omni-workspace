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
Scope of Work
</span>

            <div style="text-align:left; border: 1.5px solid #000000; padding: 15px 10px 20px;  ">
                <table style="width:100%; padding-top:5px;">
                    <tr>
                        <td>
                            <form:textarea path="description" cols="119" rows="4" readonly="true"
                                           cssStyle=" width:735px; color:#000000; background:#d3d3d3;
                                           margin-left:auto; margin-right:auto;"/>
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
<span style="position: relative; top: 0.1em;  margin-left: 15px; font-weight:bold; background: #d3d3d3; color:#000000;">
Audit Information
</span>

            <div style="text-align:left; border: 1.5px solid #000000; margin-top: -9px;padding: 15px 10px 20px;">
                <table style="padding-top:5px; width:500px;">
                    <col width="100px"/>
                    <col width="150px"/>
                    <col width="100px"/>
                    <col/>
                    <tr>
                        <td>
                            Date Created:
                        </td>
                        <td>
                            <fmt:formatDate value="${hotSheet.dateCreated}" pattern="MM/dd/yyyy hh:mm a"/>
                        </td>
                        <td>
                            Date Modified:
                        </td>
                        <td>
                            <fmt:formatDate value="${hotSheet.dateModified}" pattern="MM/dd/yyyy hh:mm a"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Created By:
                        </td>
                        <td>
                            ${hotSheet.createdByName}
                        </td>
                        <td>
                            Modified By:
                        </td>
                        <td>
                            ${hotSheet.modifiedByName}
                        </td>
                    </tr>
                </table>
            </div>
        </td>
        <td>
            <table style="width:90px; padding-left:15px;" border="0 " cellpadding="2" cellspacing="2">
                <tr>
                    <td align="center">
                        <label>
                            <input type="button" value="COPY" name="button" id="copyButton"
                                   style="width:67px; height:40px; background:#d3d3d3;">
                        </label>
                    </td>
                    <td align="center">
                        <label>
                            <input type="button" value="SAVE" name="button" id="saveButton"
                                   style="width:67px; height:40px; background:#d3d3d3;">
                        </label>
                    </td>
                    <td align="center">
                        <label>
                            <button name="button" onclick="return closeWindow();"
                                    style="width:72px; height:40px; background:#d3d3d3; text-align:center; display:block; word-wrap:break-word;">
                                Close<br/>Window
                            </button>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td colspan="3" align="center">
                        <label>
                            <input type="button" value="Print BL" name="button" id="printButton"
                                   style="width:220px; height:40px; background:#d3d3d3;">
                        </label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

