//secondRow.jsp - javascript to support the addJobLocation and addOriginContact dialog
YAHOO.namespace("example.container");
YAHOO.util.Event.onDOMReady(function () {
    initializeOriginAddress();
    initializeOriginContact();
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

        var originContactDropdown = document.getElementById("originContactDropdown");
        originContactDropdown.options.length = 0;
        for (var i = 0; i < messages.length; i++) {
            var newOption = document.createElement("OPTION");
            originContactDropdown.options.add(newOption);
            newOption.value = messages[i].CONTACT_ID;
            newOption.text = messages[i].CONTACT_NAME;
            if (i == 0) {
                document.getElementById("originContactPhone").value = messages[i].PHONE_WORK;
                document.getElementById("originContactName").value = messages[i].CONTACT_NAME;
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
                document.getElementById("jobLocationAddress.jobLocationName").value = messages['jobLocationName'];
                document.getElementById("jobLocationAddress.streetOne").value = messages['streetOne'];
                var cityStateZip = messages['city'] + ' ' + messages['state'] + ' ' + messages['zip'];
                document.getElementById("destinationCityStateZip").value = cityStateZip;
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


function initializeOriginContact() {

    var handleContactSubmit = function() {
        var result = this.submit();
        if (result) {
            YAHOO.example.container.addContact.element.style.zIndex = -1;
        }

    };
    var handleContactCancel = function() {
        this.cancel();
        YAHOO.example.container.addContact.element.style.zIndex = -1;
    };

    var handleContactSuccess = function(o) {
        var messages = YAHOO.lang.JSON.parse(o.responseText);

        var originContactDropdown = document.getElementById("originContactDropdown");
        originContactDropdown.options.length = 0;
        for (var i = 0; i < messages.length; i++) {
            var newOption = document.createElement("OPTION");
            originContactDropdown.options.add(newOption);
            newOption.value = messages[i].CONTACT_ID;
            newOption.text = messages[i].CONTACT_NAME;
            if (i == 0) {
                document.getElementById("originContactPhone").value = messages[i].PHONE_WORK;
                document.getElementById("originContactName").value = messages[i].CONTACT_NAME;
            }
        }
    };

    var handleContactFailure = function(o) {
        alert("Add origin contact failed: " + o.status);
    };

    // Remove progressively enhanced content class, just before creating the module
    YAHOO.util.Dom.removeClass("addContact", "yui-pe-content");

    // Instantiate the Dialog
    YAHOO.example.container.addContact = new YAHOO.widget.Dialog("addOriginContact",
                                                                 { width : "30em",
                                                                     zIndex : -1,
                                                                     fixedcenter : true,
                                                                     visible : false,
                                                                     constraintoviewport : true,
                                                                     buttons : [
                                                                         { text:"Submit", handler:handleContactSubmit, isDefault:true },
                                                                         { text:"Cancel", handler:handleContactCancel }
                                                                     ]
                                                                 });

    // Validate the entries in the form to require that both first and last name are entered
    YAHOO.example.container.addContact.validate = function() {

        var data = this.getData();

        if (data == undefined) {
            return false;
        }

        if (YAHOO.lang.trim(data.contactName) == "") {
            alert("A name is required.");
            return false;
        }

        if (YAHOO.lang.trim(data.contactPhone) == "") {
            alert("A phone is required.");
            return false;
        }
        return true;
    };

    // Wire up the success and failure handlers
    YAHOO.example.container.addContact.callback = {
        success: handleContactSuccess,
        failure: handleContactFailure
    };

    // Render the Dialog
    YAHOO.example.container.addContact.render();

    function init(e) {
        YAHOO.example.container.addContact.show();
        YAHOO.example.container.addContact.element.style.zIndex = 2;
    }

    YAHOO.util.Event.addListener("newOriginContact", "click", init, YAHOO.example.container.addContact, true);
}


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

YAHOO.util.Event.on('originContactDropdown', 'change', function (event) {

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
                document.getElementById("originContactPhone").value = messages['PHONE_WORK'];
                document.getElementById("originContactName").value = messages['CONTACT_NAME'];
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
    var url = '/stc/updateOriginContact.html?originContactId=' + id;
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
});



