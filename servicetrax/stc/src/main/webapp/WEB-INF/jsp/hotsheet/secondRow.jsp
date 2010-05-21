<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<script type="text/javascript">
    YAHOO.namespace("example.container");

    YAHOO.util.Event.onDOMReady(function () {

        // Define various event handlers for Dialog
        var handleSubmit = function() {
            this.submit();
        };
        var handleCancel = function() {
            this.cancel();
        };
        var handleSuccess = function(o) {
            var response = o.responseText;
            response = response.split("<!")[0];
            document.getElementById("resp").innerHTML = response;
        };
        var handleFailure = function(o) {
            alert("Submission failed: " + o.status);
        };

        // Remove progressively enhanced content class, just before creating the module
        YAHOO.util.Dom.removeClass("dialog1", "yui-pe-content");

        // Instantiate the Dialog
        YAHOO.example.container.dialog1 = new YAHOO.widget.Dialog("dialog1",
                                                                  { width : "30em",
                                                                      fixedcenter : true,
                                                                      visible : false,
                                                                      constraintoviewport : true,
                                                                      buttons : [
                                                                          { text:"Submit", handler:handleSubmit, isDefault:true },
                                                                          { text:"Cancel", handler:handleCancel }
                                                                      ]
                                                                  });

        // Validate the entries in the form to require that both first and last name are entered
        YAHOO.example.container.dialog1.validate = function() {
            var data = this.getData();
            if (data.firstname == "" || data.lastname == "") {
                alert("Please enter your first and last names.");
                return false;
            }
            else {
                return true;
            }
        };

        // Wire up the success and failure handlers
        YAHOO.example.container.dialog1.callback = { success: handleSuccess,
            failure: handleFailure };

        // Render the Dialog
        YAHOO.example.container.dialog1.render();

        YAHOO.util.Event.addListener("show", "click", YAHOO.example.container.dialog1.show, YAHOO.example.container.dialog1, true);
        YAHOO.util.Event.addListener("hide", "click", YAHOO.example.container.dialog1.hide, YAHOO.example.container.dialog1, true);
    });
</script>

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
            <form:select path="originAddressId" cssStyle="min-width:225px; max-width:225px;">
                <form:options items="${hotSheet.originAddresses}" itemValue="key" itemLabel="value"/>
            </form:select>
        </td>
    </tr>

    <tr>
        <td>
            <form:input path="originAddress.jobLocationName" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="jobLocationAddress.jobLocationName" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="originAddress.jobLocationName" readonly="true" cssClass="disabledCell"/>
        </td>
    </tr>

    <tr>
        <td>
            <form:input path="originAddress.streetOne" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="jobLocationAddress.streetOne" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="originAddress.streetOne" readonly="true" cssClass="disabledCell"/>
        </td>
    </tr>
    <tr>
        <td>
            <form:input path="originAddress.streetTwo" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="jobLocationAddress.streetTwo" cssClass="disabledCell"/>
        </td>
        <td>&nbsp;</td>
        <td>
            <form:input path="originAddress.streetTwo" readonly="true" cssClass="disabledCell"/>
        </td>
    </tr>

    <tr>
        <td>
            <input type="text" readonly="true" class="disabledCell"
                   value="<c:out value='${hotSheet.originAddress.city}, ${hotSheet.originAddress.state} ${hotSheet.originAddress.zip}'/>">
        </td>
        <td>
            <label>
                <input type="button" value="New" id="show"
                       style=" background:#d3d3d3"/>
            </label>
        </td>
        <td>
            <label>
                <input type="text" readonly="true" class="disabledCell"
                       value="<c:out value='${hotSheet.jobLocationAddress.city}, ${hotSheet.jobLocationAddress.state} ${hotSheet.jobLocationAddress.zip}'/>">
            </label>
        </td>
        <td>
            &nbsp;
        </td>
        <td>
            <input type="text" readonly="true" class="disabledCell"
                   value="<c:out value='${hotSheet.originAddress.city}, ${hotSheet.originAddress.state} ${hotSheet.originAddress.zip}'/>">
        </td>
    </tr>
</table>

<div id="dialog1" class="yui-panel">
    <div class="hd">Please enter job location information</div>
    <div class="bd">

        <form name="job_loc_frm" id="job_loc_frm" method="POST"
              action="{!s:action!}newJobLocation/enet/embeds/job_loc_response.html">
            <div id="jobLocationFormDiv"></div>
            <table border="0" cellspacing="5" cellpadding="0">
                <tr>
                    <td>
                        Name:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="job_location_name"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Address:
                    </td>
                    <td>
                        <input type="text" name="street1"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Address Two:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="street2"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        City:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="city"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        County:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="county"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        State:
                    </td>
                    <td>
                        <div id="jobLocationStatesDiv"></div>
                    </td>
                </tr>
                <tr>
                    <td>
                        Zip:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="zip"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Country:
                    </td>
                    <td>
                        <div id="jobLocationCountryDiv"></div>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
