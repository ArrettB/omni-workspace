<%--
  Created by IntelliJ IDEA.
  User: pgarvie
  Date: May 22, 2010
  Time: 4:29:13 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/stateProvince.js"></script>

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

    function fnCallback(e) {
        handleChange('US');
    }
    YAHOO.util.Event.addListener(window, "load", fnCallback);

</script>


<div id="dialog1" class="yui-panel">
    <div class="hd">Please enter new origin address information</div>
    <div class="bd">

        <form name="job_loc_frm" id="job_loc_frm" method="POST"
              action="{!s:action!}newJobLocation/enet/embeds/job_loc_response.html">
            <div id="jobLocationFormDiv"></div>
            <table border="0" cellspacing="5" cellpadding="0">
                <tr>
                    <td>
                        Location Name:
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
                        <label>
                            <input type="text" name="street1"/>
                        </label>
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
                        State/Province:
                    </td>
                    <td>
                        <label>
                            <select name="state" style="width:150px;" id="state"></select>
                        </label>
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
                        <label>
                            <select name="country" style="width:150px;"
                                    onchange="handleChange(this.options[this.selectedIndex].value);">
                                <option value="US" selected="selected">United States</option>
                                <option value="CA">Canada</option>
                            </select>
                        </label>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
