<html>
<head>
    <title>Hello World</title>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/yahoo-dom-event/yahoo-dom-event.js"></script>


    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/connection/connection-min.js"></script>


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

<form action="${pageContext.request.contextPath}/requestNewAccount.html" method="post" id="requestNewAccountForm">
    <table class="formTable" border="0"
           style="margin-left:auto; margin-right:auto; margin-top:30px; border: 0;">
        <tbody>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td class="label" style="padding-left:10px; padding-bottom:10px;" colspan="4">
                <span style="font-size:9px; white-space:nowrap;">
                    Enter the following information and click Request New Account:
                </span>
            </td>
        </tr>

        <tr>
            <td class="label" style="padding-left:10px;">
                First Name:
            </td>
            <td class="control">
                <label style="padding-left:10px;">
                    <input name="firstName" id="firstName" class="required" title="First Name is required"/>
                </label>
            </td>
            <td class="label" style="padding-left:10px;">
                Last Name:
            </td>
            <td class="control">
                <label style="padding-left:10px;">
                    <input name="lastName" id="lastName" class="required" title="Last Name is required"/>
                </label>
            </td>
        </tr>
        <tr>
            <td class="label" style="padding-left:10px;">
                User Name:
            </td>
            <td class="control">
                <label style="padding-left:10px;">
                    <input name="username" id="username" class="required" minlength="6"
                           title="User Name is required and must be at least 6 characters"/>
                </label>
            </td>
            <td class="label" style="padding-left:10px;">
                Password:
            </td>
            <td class="control">
                <label style="padding-left:10px;">
                    <input type="password" name="password" id="password" class="required" minlength="6"
                           title="Password is required and must be at least 6 characters"/>
                </label>
            </td>
        </tr>

        <tr>
            <td class="label" style="padding-left:10px;">
                Email:
            </td>
            <td class="control">
                <label style="padding-left:10px;">
                    <input name="email" id="email" class="required validate-email" title="A valid email is required"/>
                </label>
            </td>
            <td class="label" style="padding-left:10px;">
                Phone Number:
            </td>
            <td class="control">
                <label style="padding-left:10px;">
                    <input type="text" name="phone" id="phone" class="required" title="A phone number is required"/>
                </label>
            </td>
        </tr>


        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="4">
                <label style="padding-left:10px;">
                    <input type="submit" id="requestNewAccountButton" value="Request New Account"
                           class="passwordButton"/>
                </label>
                <label style="padding-right:10px;">
                    <input type="button" id="clearNewAccountButton" value="Cancel" class="passwordButton" onclick="closeWindow();">
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
        alert("Request submitted.");
        window.close();
    };

    var handleFailure = function(o) {
        alert("Request not submitted.");
    };

    var callback =
    {
        success:handleSuccess,
        failure:handleFailure
    };

    var theForm = document.getElementById("requestNewAccountForm");

    YAHOO.util.Event.addListener(theForm, "submit", function(e) {
        YAHOO.util.Event.stopEvent(e);
        if (FIC_checkForm(e)) {
            var theForm = document.getElementById("requestNewAccountForm");
            YAHOO.util.Connect.setForm(theForm);
            YAHOO.util.Connect.asyncRequest(theForm.method, theForm.action, callback);
        }
        return true;
    });

    YAHOO.util.Event.addListener("requestNewAccountButton", "mousedown", function() {
        document.getElementById("requestNewAccountButton").style.background = '#336666';
    });

    YAHOO.util.Event.addListener("requestNewAccountButton", "mouseup", function() {
        document.getElementById("requestNewAccountButton").style.background = '#669999';
    });

    YAHOO.util.Event.addListener("clearNewAccountButton", "mousedown", function() {
        document.getElementById("clearNewAccountButton").style.background = '#336666';
    });

    YAHOO.util.Event.addListener("clearNewAccountButton", "mouseup", function() {
        document.getElementById("clearNewAccountButton").style.background = '#669999';
    });


    function closeWindow() {
        window.close();
    }
</script>

</body>
</html>
