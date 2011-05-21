<html>
<head>
    <title>Send Password Request</title>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/yahoo-dom-event/yahoo-dom-event.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/connection/connection-min.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/json/json-min.js"></script>

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
    </style>

    <%--<script type="text/javascript">--%>
        <%--var RecaptchaOptions = {--%>
            <%--theme : 'clean'--%>
        <%--};--%>
    <%--</script>--%>

</head>

<body style="background:#ded4c6;">

<table class="formTable" border="0" style="margin-left:auto; margin-right:auto; margin-top:30px; border: 0;">
    <tbody>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td class="label" style="padding-left:10px; padding-bottom:10px;" colspan="2">
            <span style="font-size:9px; white-space:nowrap;">
                Enter your serviceTrax username and click Email Password:
            </span>
        </td>
    </tr>

    <tr>
        <td class="label" style="padding-left:10px; font-weight: bold; font-size:11px;">
            User Name:
        </td>
        <td class="control">
            <label style="padding-left:10px;">
                <input name="username" id="username"/>
            </label>
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <%--<tr>--%>
        <%--<td colspan="2">--%>
            <%--${captcha}--%>
        <%--</td>--%>
    <%--</tr>--%>
    <tr>
        <td colspan="2">
            <label style="padding-left:10px;">
                <input type="button" id="sendPasswordButton" value="Email Password" class="passwordButton"
                       onclick="sendPassword();"/>
            </label>
            <label style="padding-right:10px;">
                <input type="button" id="clearPasswordButton" value="Cancel" class="passwordButton" onclick="closeWindow();"/>
            </label>
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2">
            <div align="center"><img src="/ims/images/login/omni.jpg" width="100" height="80" border="0"
                                     alt="Omni Manufacturing"></div>
        </td>
    </tr>
</table>

<script type="text/javascript">

    var handleSuccess = function(o) {

        var result = YAHOO.lang.JSON.parse(o.responseText);
        if (result.success) {
            alert(result.message);
            window.close();
        }
        else {
            alert(result.message);
            // This gets us a new captcha
            window.location.reload();
        }
    };

    var handleFailure = function(o) {
        alert("fail!!");
    };

    var callback =
    {
        success:handleSuccess,
        failure:handleFailure
    };

    var url = '/stc/handleSendPassword.html?username=';

    function sendPassword() {
        var username = document.getElementById("username").value;

        if (!username) {
            alert("A username is required.");
            return false;
        }

//        var captchaChallenge = document.getElementById("recaptcha_challenge_field").value;
//        var captchaResponse = document.getElementById("recaptcha_response_field").value;
//        var captcha = '&captchaChallenge=' + captchaChallenge + '&captchaResponse=' + captchaResponse;
//        YAHOO.util.Connect.asyncRequest('POST', url + username + captcha, callback);
        YAHOO.util.Connect.asyncRequest('POST', url + username, callback);
        return true;
    }

    YAHOO.util.Event.addListener("sendPasswordButton", "mousedown", function() {
        document.getElementById("sendPasswordButton").style.background = '#336666';
    });

    YAHOO.util.Event.addListener("sendPasswordButton", "mouseup", function() {
        document.getElementById("sendPasswordButton").style.background = '#669999';
    });

    YAHOO.util.Event.addListener("clearPasswordButton", "mousedown", function() {
        document.getElementById("clearPasswordButton").style.background = '#336666';
    });

    YAHOO.util.Event.addListener("clearPasswordButton", "mouseup", function() {
        document.getElementById("clearPasswordButton").style.background = '#669999';
    });

    function closeWindow() {
        window.close();
        return true;
    }
</script>

</body>
</html>
