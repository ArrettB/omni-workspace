YAHOO.namespace("example.container");
YAHOO.util.Event.onDOMReady(function () {
    initializeOriginAddress();
});

function initializeOriginAddress() {
    // Define various event handlers for new origin address
    var handleLocationSubmit = function() {
        var result = this.submit();
        if (result) {
            YAHOO.example.container.addJobLocation.element.style.zIndex = -1;
        }
    };
    var handleLocationCancel = function() {
        this.cancel();
        YAHOO.example.container.addJobLocation.element.style.zIndex = -1;
    };

    var handleLocationSuccess = function(o) {
        var messages = YAHOO.lang.JSON.parse(o.responseText);

        var originAddressDropdown = document.getElementById("originAddressDropdown");
        originAddressDropdown.options.length = 0;
        for (var i = 0; i < messages.length; i++) {
            var newOption = document.createElement("OPTION");
            originAddressDropdown.options.add(newOption);
            newOption.value = messages[i].jobLocationId;
            newOption.text = messages[i].jobLocationName;
            if (i == 0) {
                originAddressDropdown.value = messages[i].jobLocationId
                document.getElementById("originAddress.jobLocationName").value = messages[i].jobLocationName;
                document.getElementById("originAddress.streetOne").value = messages[i].streetOne;
                var cityStateZip = messages[i].city + ' ' + messages[i].state + ' ' + messages[i].zip;
                document.getElementById("cityStateZip").value = cityStateZip;
            }
        }
    };

    var handleLocationFailure = function(o) {
        alert("Add job location failed: " + o.status);
    };

    // Remove progressively enhanced content class, just before creating the module
    YAHOO.util.Dom.removeClass("addJobLocation", "yui-pe-content");

    // Instantiate the Dialog
    YAHOO.example.container.addJobLocation = new YAHOO.widget.Dialog("addJobLocation",
                                                                     { width : "30em",
                                                                         zIndex : -1,
                                                                         fixedcenter : true,
                                                                         visible : false,
                                                                         constraintoviewport : true,
                                                                         buttons : [
                                                                             { text:"Submit", handler:handleLocationSubmit, isDefault:true },
                                                                             { text:"Cancel", handler:handleLocationCancel }
                                                                         ]
                                                                     });

    // Validate the entries in the form to require that both first and last name are entered
    YAHOO.example.container.addJobLocation.validate = function() {

        var data = this.getData();

        if (data == undefined) {
            return false;
        }

        if (YAHOO.lang.trim(data.jobLocationName) == "") {
            alert("A job location name is required.");
            return false;
        }

        if (YAHOO.lang.trim(data.streetOne) == "") {
            alert("An address is required.");
            return false;
        }

        if (YAHOO.lang.trim(data.city) == "") {
            alert("A city is required.");
            return false;
        }

        var isZip = /^\d{5}([\-]\d{4})?$/;
        if (YAHOO.lang.trim(data.zip) == "" || !isZip.test(data.zip)) {
            alert("A valid zip code is required.");
            return false;
        }

        return true;
    };

    // Wire up the success and failure handlers
    YAHOO.example.container.addJobLocation.callback = {
        success: handleLocationSuccess,
        failure: handleLocationFailure
    };

    // Render the Dialog
    YAHOO.example.container.addJobLocation.render();

    function init(e) {
        YAHOO.example.container.addJobLocation.show();
        YAHOO.example.container.addJobLocation.element.style.zIndex = 2;
    }


    YAHOO.util.Event.addListener("newOriginAddress", "click", init, YAHOO.example.container.addJobLocation, true);
}


YAHOO.util.Event.on('originAddressDropdown', 'change', function (event) {

    var callbacks = {

        start : function(o) {
            document.getElementById('spinner').style.visibility = 'visible';
        },

        complete : function(o) {
            document.getElementById('spinner').style.visibility = 'hidden';
        },

        success : function (o) {
            var messages = [];
            try {
                messages = YAHOO.lang.JSON.parse(o.responseText);
                document.getElementById("originAddress.jobLocationName").value = messages['jobLocationName'];
                document.getElementById("originAddress.streetOne").value = messages['streetOne'];
                var cityStateZip = messages['city'] + ' ' + messages['state'] + ' ' + messages['zip'];
                document.getElementById("cityStateZip").value = cityStateZip;
            }
            catch (exception) {
                alert("JSON Parse failed: " + exception);
                document.getElementById('spinner').style.visibility = 'hidden';
            }
        },

        failure : function (o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                document.getElementById('spinner').style.visibility = 'hidden';
            }
        },

        // 10 second timeout
        timeout : 10000
    };

    YAHOO.util.Connect.startEvent.subscribe(callbacks.start, callbacks);
    YAHOO.util.Connect.completeEvent.subscribe(callbacks.complete, callbacks);

    var id = this.value;
    var url = '/stc/updateOriginAddress.html?jobLocationId=' + id;
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
});

