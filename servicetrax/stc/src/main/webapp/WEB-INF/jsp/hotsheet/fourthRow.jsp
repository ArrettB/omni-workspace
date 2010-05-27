<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--Third Row--%>
<table style="margin-top:15px;" border="0">
<tr>
<td>
<span style="position: relative; top: 0.7em;  margin-left: 15px; font-weight:bold; background: #d3d3d3; color:#000000;">
Equipment
</span>

    <div style="text-align:left; border: 1.5px solid #000000; padding-bottom:20px; padding-left:10px;">
        <table style="width:325px; padding-top:25px;">
            <col width="25px"/>
            <col/>
            <col width="25px"/>
            <col/>

            <tr>
                <td>
                    <form:input path="details[machine_cart_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    Machine Carts 3/4
                </td>
                <td>
                    <form:input path="details[vacuums_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    Vacuums
                </td>
            </tr>
            <tr>
                <td>
                    <form:input path="details[dollies_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    Dollies
                </td>
                <td>
                    <form:input path="details[safe_kit_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    Safe Kit
                </td>
            </tr>
            <tr>
                <td>
                    <form:input path="details[panel_carts_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    Panel Carts
                </td>
                <td>
                    <form:input path="details[shrink_wrap_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    Shrink Wrap
                </td>
            </tr>
            <tr>
                <td>
                    <form:input path="details[tote_stacks_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    Tote Stacks
                </td>
                <td>
                    <form:input path="details[boards_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    Shrt/Long Boards
                </td>
            </tr>
            <tr>
                <td>
                    <form:input path="details[picture_totes_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    Picture Totes
                </td>
                <td>
                    <form:input path="details[full_masonite_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    Full Masonite
                </td>
            </tr>
            <tr>
                <td>
                    <form:input path="details[pr_carton_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    PR Carton
                </td>
                <td>
                    <form:input path="details[blue_tape_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    Blue Tape
                </td>
            </tr>
            <tr>
                <td>
                    <form:input path="details[half_masonite_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    1/2 Masonite
                </td>
                <td>
                    <form:input path="details[custom_equipment_1_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_1].name" cssClass="details"
                                cssStyle="width:100px; text-align:left;"/>
                </td>
            </tr>
            <tr>
                <td>
                    <form:input path="details[corner_boards_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    Corner Boards
                </td>
                <td>
                    <form:input path="details[custom_equipment_2_qty].attributeValue"
                                maxlength="3" cssClass="details"/>
                </td>
                <td>
                    <form:input path="details[custom_equipment_2].name" cssClass="details"
                                cssStyle="width:100px; text-align:left;"/>
                </td>
            </tr>
        </table>
    </div>
</td>
<td style="padding-left:8px;">
    <span style="position: relative; top: 0.7em;  margin-left: 25px; font-weight:bold; background: #d3d3d3; color:#000000;">
Position
    </span>

    <div style="text-align:left; border: 1.5px solid #000000; padding-bottom:25px; margin-left:15px;">
        <table style="width:120px; padding-top:23px;">
            <col width="25px"/>
            <col/>

            <tr>
                <td>
                    <form:input path="details[project_manager_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    Proj. Mgr.
                </td>
            </tr>

            <tr>
                <td>
                    <form:input path="details[supervisor_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    Supervisor
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
                <td>
                    <form:input path="details[packer_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    Packer
                </td>
            </tr>
            <tr>
                <td>
                    <form:input path="details[tech_qty].attributeValue"
                                maxlength="3" cssClass="details" cssStyle="margin-left:5px;"/>
                </td>
                <td>
                    Tech
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

<td>
<span style="position: relative; top: 0.7em;  margin-left: 25px; font-weight:bold; background: #d3d3d3; color:#000000;">
Special Instructions
</span>

    <div style="text-align:left; border: 1.5px solid #000000; padding-bottom:20px; margin-left:15px;">
        <form:textarea path="specialInstructions" cols="30" rows="13" cssStyle="margin-top:25px; margin-left:15px; margin-right:10px;
        border:solid 1px inset;"/>
    </div>
</td>

</tr>
</table>
