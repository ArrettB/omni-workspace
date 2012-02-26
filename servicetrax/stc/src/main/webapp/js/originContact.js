YAHOO.namespace("example.container");
YAHOO.util.Event.onDOMReady(function () {
    initializeOriginContact();
});

function validateContactFields() {
    return function() {

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
}
function setHiddenContactId(widgetId) {
    var contactDropDown = document.getElementById('originContactDropdown');
    var contactId = contactDropDown.options[contactDropDown.selectedIndex];
    var contactIdHidden = document.getElementById(widgetId);
    if (contactIdHidden != undefined) {
        contactIdHidden.value = contactId.value;
    }
}
function initializeOriginContact() {

    var handleContactSubmit = function() {
        setHiddenContactId('editContactId');
        var result = this.submit();
        if (result) {
            YAHOO.example.container.addContact.element.style.zIndex = -1;
        }
    };

    var handleDeactivateSubmit = function() {
        setHiddenContactId('deactivateContactId');
        var result = this.submit();
        if (result) {
            YAHOO.example.container.deactivateContact.element.style.zIndex = -1;
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
    YAHOO.util.Dom.removeClass("editContact", "yui-pe-content");

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

    YAHOO.example.container.editContact = new YAHOO.widget.Dialog("editContact",
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
    YAHOO.example.container.deactivateContact = new YAHOO.widget.Dialog("deactivateContact",
                                                                        { width : "25em",
                                                                            zIndex : -1,
                                                                            fixedcenter : true,
                                                                            visible : false,
                                                                            constraintoviewport : true,
                                                                            buttons : [
                                                                                { text:"&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;", handler:handleDeactivateSubmit, isDefault:true },
                                                                                { text:"&nbsp;&nbsp;&nbsp;No&nbsp;&nbsp;&nbsp;", handler:handleContactCancel }
                                                                            ]
                                                                        });


    // Validate the entries in the form to require that both first and last name are entered
    YAHOO.example.container.addContact.validate = validateContactFields();
    YAHOO.example.container.editContact.validate = validateContactFields();

    // Wire up the success and failure handlers
    YAHOO.example.container.addContact.callback = {
        success: handleContactSuccess,
        failure: handleContactFailure
    };

    YAHOO.example.container.editContact.callback = {
        success: handleContactSuccess,
        failure: handleContactFailure
    };

    YAHOO.example.container.deactivateContact.callback = {
        success: handleContactSuccess,
        failure: handleContactFailure
    };


    // Render the Dialog
    YAHOO.example.container.addContact.render();
    YAHOO.example.container.editContact.render();
    YAHOO.example.container.deactivateContact.render();

    function init(e) {
        document.getElementById('contactName').value = "";
        document.getElementById('contactPhone').value = "";
        YAHOO.example.container.addContact.show();
        YAHOO.example.container.addContact.element.style.zIndex = 2;
    }

    function initEdit(e) {
        YAHOO.example.container.editContact.show();
        YAHOO.example.container.editContact.element.style.zIndex = 2;
        var contactDropDown = document.getElementById('originContactDropdown');
        document.getElementById('editContactName').value = contactDropDown.options[contactDropDown.selectedIndex].text;
        document.getElementById('editContactPhone').value = document.getElementById('originContactPhone').value;
    }

    function initDeactivate(e) {
        YAHOO.example.container.deactivateContact.show();
        YAHOO.example.container.deactivateContact.element.style.zIndex = 2;
    }

    YAHOO.util.Event.addListener("newOriginContact", "click", init, YAHOO.example.container.addContact, true);
    YAHOO.util.Event.addListener("editContactButton", "click", initEdit, YAHOO.example.container.editContact, true);
    YAHOO.util.Event.addListener("deactivateContactButton", "click", initDeactivate, YAHOO.example.container.deactivateContact, true);
}


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
    YAHOO.util.Connect.asyncRequest('POST', url, callbacks);
});



