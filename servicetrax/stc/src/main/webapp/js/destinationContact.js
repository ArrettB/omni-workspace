YAHOO.namespace("example.container");
YAHOO.util.Event.onDOMReady(function () {
    initializeDestinationContact();
});

function initializeDestinationContact() {

    var handleContactSubmit = function() {
        var result = this.submit();
        if (result) {
            YAHOO.example.container.addDestinationContact.element.style.zIndex = -1;
        }

    };
    var handleContactCancel = function() {
        this.cancel();
        YAHOO.example.container.addDestinationContact.element.style.zIndex = -1;
    };

    var handleContactSuccess = function(o) {
        var messages = YAHOO.lang.JSON.parse(o.responseText);

        var destinationContactDropdown = document.getElementById("destinationContactDropdown");
        destinationContactDropdown.options.length = 0;
        for (var i = 0; i < messages.length; i++) {
            var newOption = document.createElement("OPTION");
            destinationContactDropdown.options.add(newOption);
            newOption.value = messages[i].CONTACT_ID;
            newOption.text = messages[i].CONTACT_NAME;
            if (i == 0) {
                document.getElementById("jobContactPhone").value = messages[i].PHONE_WORK;
                document.getElementById("jobContactName").value = messages[i].CONTACT_NAME;
            }
        }
    };

    var handleContactFailure = function(o) {
        alert("Add origin contact failed: " + o.status);
    };

    // Remove progressively enhanced content class, just before creating the module
    YAHOO.util.Dom.removeClass("addDestinationContact", "yui-pe-content");

    // Instantiate the Dialog
    YAHOO.example.container.addDestinationContact = new YAHOO.widget.Dialog("addDestinationContact",
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
    YAHOO.example.container.addDestinationContact.validate = function() {

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
    YAHOO.example.container.addDestinationContact.callback = {
        success: handleContactSuccess,
        failure: handleContactFailure
    };

    // Render the Dialog
    YAHOO.example.container.addDestinationContact.render();

    function init(e) {
        YAHOO.example.container.addDestinationContact.show();
        YAHOO.example.container.addDestinationContact.element.style.zIndex = 2;
    }

    YAHOO.util.Event.addListener("newDestinationContact", "click", init, YAHOO.example.container.addDestinationContact, true);
}


YAHOO.util.Event.on('destinationContactDropdown', 'change', function (event) {

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
                document.getElementById("jobContactPhone").value = messages['PHONE_WORK'];
                document.getElementById("jobContactName").value = messages['CONTACT_NAME'];
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
    var url = '/stc/updateDestinationContact.html?jobLocationContactId=' + id;
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
});



