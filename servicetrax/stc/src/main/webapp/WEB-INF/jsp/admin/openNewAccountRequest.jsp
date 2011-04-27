<html>
<head>
    <title>Hello World</title>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/yahoo-dom-event/yahoo-dom-event.js"></script>

    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/yui281/build/connection/connection-min.js"></script>

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

</head>

<body style="background:#ded4c6;">

<table class="formTable" border="0"
       style="margin-left:auto; margin-right:auto; margin-top:30px; border: 0;">
    <tbody>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td class="label" style="padding-left:10px; padding-bottom:10px; font-size:9px;" colspan="2">
            Enter the following information and click Request New Account:
        </td>
    </tr>

    <tr>
        <td class="label" style="padding-left:10px;">
            Username:
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
    <tr>
        <td colspan="2">
            <label style="padding-left:10px;">
                <input type="button" id="requestNewAccountButton" value="Request New Account" class="passwordButton"
                       onclick="requestNewAccount();"/>
                <input type="reset" value="Cancel" class="passwordButton" onclick="closeWindow();">
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
        window.close();
    };

    var handleFailure = function(o) {
        alert("fail!!");
    };

    var callback =
    {
        success:handleSuccess,
        failure:handleFailure
    };

    var url = '/stc/requestNewAccount.html?username=';

    function requestNewAccount() {
        var username = document.getElementById("username").value;
        if (!username) {
            alert("A username is required.");
            return false;
        }
        YAHOO.util.Connect.asyncRequest('POST', url + username, callback);
        return true;
    }

    function closeWindow() {
        window.close();
    }
</script>

</body>
</html>
