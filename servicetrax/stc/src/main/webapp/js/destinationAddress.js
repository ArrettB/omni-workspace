YAHOO.namespace("example.container");
YAHOO.util.Event.onDOMReady(function () {
    initializeDestinationAddress();
});

function initializeDestinationAddress() {

    var handleAddDestinationSubmit = function() {
        var result = this.submit();
        if (result) {
            YAHOO.example.container.addDestination.element.style.zIndex = -1;
        }

    };
    var handleAddDestinationCancel = function() {
        this.cancel();
        YAHOO.example.container.addDestination.element.style.zIndex = -1;
    };

    var handleAddDestinationSuccess = function(o) {
        var messages = YAHOO.lang.JSON.parse(o.responseText);

        var destinationAddressDropdown = document.getElementById("destinationAddressDropdown");
        destinationAddressDropdown.options.length = 0;
        for (var i = 0; i < messages.length; i++) {
            var newOption = document.createElement("OPTION");
            destinationAddressDropdown.options.add(newOption);
            newOption.value = messages[i].jobLocationId;
            newOption.text = messages[i].jobLocationName;
            if (i == 0) {
                destinationAddressDropdown.value = messages[i].jobLocationId;
                document.getElementById("jobLocationAddress.jobLocationName").value = messages[i].jobLocationName;
                document.getElementById("jobLocationAddress.streetOne").value = messages[i].streetOne;
                document.getElementById("destinationCityStateZip").value =
                        messages[i].city + ' ' + messages[i].state + ' ' + messages[i].zip;
            }
        }
    };

    var handleAddDestinationFailure = function(o) {
        alert("Add destination failed: " + o.status);
    };

    // Remove progressively enhanced content class, just before creating the module
    YAHOO.util.Dom.removeClass("addDestination", "yui-pe-content");

    // Instantiate the Dialog
    YAHOO.example.container.addDestination = new YAHOO.widget.Dialog("addDestinationAddress",
                                                                     { width : "30em",
                                                                         zIndex : -1,
                                                                         fixedcenter : true,
                                                                         visible : false,
                                                                         constraintoviewport : true,
                                                                         buttons : [
                                                                             { text:"Submit", handler:handleAddDestinationSubmit, isDefault:true },
                                                                             { text:"Cancel", handler:handleAddDestinationCancel }
                                                                         ]
                                                                     });

    // Validate the entries in the form to require that both first and last name are entered
    YAHOO.example.container.addDestination.validate = function() {

        var data = this.getData();

        if (data == undefined) {
            return false;
        }

        if (YAHOO.lang.trim(data.jobLocationName) == "") {
            alert("A location name is required.");
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
    YAHOO.example.container.addDestination.callback = {
        success: handleAddDestinationSuccess,
        failure: handleAddDestinationFailure
    };

    // Render the Dialog
    YAHOO.example.container.addDestination.render();

    function init(e) {
        YAHOO.example.container.addDestination.show();
        YAHOO.example.container.addDestination.element.style.zIndex = 2;
    }

    YAHOO.util.Event.addListener("addDestinationButton", "click", init, YAHOO.example.container.addDestination, true);

}

YAHOO.util.Event.on('destinationAddressDropdown', 'change', function (event) {

    var callbacks = {

        start : function(o) {
            document.getElementById('destinationAddressSpinner').style.visibility = 'visible';
        },

        complete : function(o) {
            document.getElementById('destinationAddressSpinner').style.visibility = 'hidden';
        },

        success : function (o) {
            var messages = [];
            try {
                messages = YAHOO.lang.JSON.parse(o.responseText);
                var addressIndex = messages.length - 1;
                document.getElementById("jobLocationAddress.jobLocationName").value =
                        messages[addressIndex]['jobLocationName'];

                document.getElementById("jobLocationAddress.streetOne").value =
                        messages[addressIndex]['streetOne'];

                document.getElementById("destinationCityStateZip").value =
                        messages[addressIndex]['city'] + ' ' +
                                messages[addressIndex]['state'] + ' ' +
                                messages[addressIndex]['zip'];

                //Change the jobLocationId
                document.getElementById("newJobLocationAddressId").value =
                        messages[addressIndex]['jobLocationId'];

                var destinationContactDropdown = document.getElementById("destinationContactDropdown");
                destinationContactDropdown.options.length = 0;

                //Clear these out
                document.getElementById("jobContactPhone").value = '';
                document.getElementById("jobContactName").value = '';

                for (var i = 0; i < messages.length - 1; i++) {
                    var newOption = document.createElement("OPTION");
                    destinationContactDropdown.options.add(newOption);
                    newOption.value = messages[i].CONTACT_ID;
                    newOption.text = messages[i].CONTACT_NAME;
                    if (i == 0) {
                        document.getElementById("jobContactPhone").value = messages[i].PHONE_WORK;
                        document.getElementById("jobContactName").value = messages[i].CONTACT_NAME;
                    }
                }                
            }
            catch (exception) {
                alert("JSON Parse failed: " + exception);
                document.getElementById('destinationAddressSpinner').style.visibility = 'hidden';
            }
        },

        failure : function (o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                document.getElementById('destinationAddressSpinner').style.visibility = 'hidden';
            }
        },

        // 10 second timeout
        timeout : 10000
    };

    YAHOO.util.Connect.startEvent.subscribe(callbacks.start, callbacks);
    YAHOO.util.Connect.completeEvent.subscribe(callbacks.complete, callbacks);

    var id = this.value;
    var url = '/stc/updateDestinationAddress.html?jobLocationId=' + id;
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
});

