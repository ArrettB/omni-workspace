<html>
<head>
    <title>Password Change</title>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/yahoo-dom-event/yahoo-dom-event.js"></script>


    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/connection/connection-min.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/json/json-min.js"></script>


    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/jsvalidateModified.js"></script>

    <link href="/css/stc.css" media="screen" rel="Stylesheet" type="text/css"/>

    <style type="text/css">
        .passwordButton {
            background-color: #669999;
            border: 1px solid #000000;
            color: #000000;
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 11px;
            font-weight: bold;
            padding: 2px;
            text-align: center;
        }

        .validation-failed {
        /* for textboxes, textareas, passwords */
            border: 1px solid #000000;
            background-color: #FF0000;
        }

        .validation-failed-cr {
        /* for checkboxes and radios */

        }

        .validation-failed-sel {
        /* for selects */

        }

        .validation-passed {
        /* for textboxes, textareas, passwords */
        /*border: 1px solid #6C6;*/
            background-color: #FFFFFF;
        }

        .validation-passed-cr {
        /* for checkboxes and radios */

        }

        .validation-passed-sel {
        /* for selects */

        }

    </style>

</head>

<body style="background:#ded4c6;">

<form action="${pageContext.request.contextPath}/handleChangePassword.html" method="post" id="changePasswordForm">
    <input type="hidden" name="userId" value="${userId}"/>
    <table class="formTable" border="0"
           style="margin-left:auto; margin-right:auto; margin-top:30px; border: 0;">
        <tbody>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td class="label" style="padding-left:10px; padding-bottom:10px;" colspan="4">
                <span style="font-size:9px; white-space:nowrap;">
                    Enter the following information and click Change Password:
                </span>
            </td>
        </tr>

        <tr>
            <td class="label" style="padding-left:10px;">
                Existing Password:
            </td>
            <td class="control">
                <label style="padding-left:10px;">
                    <input name="existingPassword" id="existingPassword" class="required"
                           title="Your existing password is required"/>
                </label>
            </td>
        </tr>

        <tr>
            <td class="label" style="padding-left:10px;">
                New Password:
            </td>
            <td class="control">
                <label style="padding-left:10px;">
                    <input name="newPassword" id="newPassword" class="required" minlength="6"
                           title="A new password is required and must be at least 6 characters"/>
                </label>
            </td>
        </tr>

        <tr>
            <td class="label" style="padding-left:10px;">
                Confirm New Password:
            </td>
            <td class="control">
                <label style="padding-left:10px;">
                    <input name="confirmPassword" id="confirmPassword" class="required" minlength="6"
                           title="A confirm password is required and must be at least 6 characters"/>
                </label>
            </td>
        </tr>

        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="4">
                <label style="padding-left:10px;">
                    <input type="submit" id="passwordChangeButton" value="Change Password"
                           class="passwordButton"/>
                </label>
                <label style="padding-right:10px;">
                    <input type="button" id="cancelPasswordChangeButton" value="Cancel" class="passwordButton"
                           onclick="closeWindow();">
                </label>
            </td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="4">
                <div align="center"><img src="/ims/images/login/omni.jpg" width="100" height="80" border="0"
                                         alt="Omni Manufacturing"></div>
            </td>
        </tr>
    </table>
</form>

<script type="text/javascript">

    var handleSuccess = function(o) {

        var result = YAHOO.lang.JSON.parse(o.responseText);
        if (result.success) {
            alert(result.message);
            window.close();
        }
        else {
            alert(result.message);
        }
    };

    var handleFailure = function(o) {
        alert("Password not changed.");
    };

    var callback =
    {
        success:handleSuccess,
        failure:handleFailure
    };

    var theForm = document.getElementById("changePasswordForm");

    YAHOO.util.Event.addListener(theForm, "submit", function(e) {
        YAHOO.util.Event.stopEvent(e);
        if (FIC_checkForm(e)) {
            var theForm = document.getElementById("changePasswordForm");
            YAHOO.util.Connect.setForm(theForm);
            YAHOO.util.Connect.asyncRequest(theForm.method, theForm.action, callback);
        }
        return true;
    });

    YAHOO.util.Event.addListener("passwordChangeButton", "mousedown", function() {
        document.getElementById("passwordChangeButton").style.background = '#336666';
    });

    YAHOO.util.Event.addListener("passwordChangeButton", "mouseup", function() {
        document.getElementById("passwordChangeButton").style.background = '#669999';
    });

    YAHOO.util.Event.addListener("cancelPasswordChangeButton", "mousedown", function() {
        document.getElementById("cancelPasswordChangeButton").style.background = '#336666';
    });

    YAHOO.util.Event.addListener("cancelPasswordChangeButton", "mouseup", function() {
        document.getElementById("cancelPasswordChangeButton").style.background = '#669999';
    });


    function closeWindow() {
        window.close();
    }
</script>

</body>
</html>
