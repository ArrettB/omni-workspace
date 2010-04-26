<!--
var mandatoryFields = new Array();
var allFields = new Array();

function loadColors()
{
}

function loadColors_dontuse()
{
	fixColors();

	if (allFields[0])
		allFields[0].focus();
}

function fixColors()
{
}
function fixColors_dontuse()
{
	for (i = 0; i < allFields.length; i++)
		setColor(allFields[i]);
}

function setColor(field)
{
}

function setColor_dontuse(field)
{
	var td = field.parentElement;

	if (event.type == 'focus' && event.srcElement == field)
	{
		setFieldColor(field,'focus');
		setLabelColor(td,'FormLabelFocus');
	}
	else
	{
		var useMandatoryColor = false;
		for (x = 0; x < mandatoryFields.length; x++)
		{
			if (field == mandatoryFields[x])
			{
				if (field.value.length == 0)
				useMandatoryColor = true;
				break;
			}
		}

		if (useMandatoryColor)
		{
			setFieldColor(field,'mandatory');
			setLabelColor(td,'FormLabelMandatory');
		}
		else
		{
			setFieldColor(field,'regular');
			setLabelColor(td,'FormLabel');
		}
	}
}

function setFieldColor(field,className)
{
	if (field.className == 'error') return;
	if (field.readOnly )
		className = 'readonly';
	field.className = className;
}

//don't want to use right now, renamed setLabelColor
function setLabelColor(td,className)
{
}
function setLabelColor_dontuse(td,className)
{
	if (td == null) return;
	if (td.tagName != 'TD') return;

	if (td.cellIndex > 0)
	{
		var tr = td.parentElement;
		if (tr.tagName != 'TR') return;

		var td = tr.cells[0];
		if (td.tagName != 'TD') return;

		var label = td.innerText;
		if (label != null && label.length > 0 && td.children.length == 0)
			td.className = className;
	}
	else
	{
		var tr = td.parentElement;
		if (tr.tagName != 'TR') return;

		var row = tr.rowIndex;
		var table = tr.parentElement;
		if (table.tagName != 'TBODY') return;

		var td = table.rows[row-1].cells[0];
		if (td.tagName != 'TD') return;

		var label = td.innerText;
		if (label != null && label.length > 0 && td.children.length == 0)
			td.className = className;
	}
}

function checkSaveButton()
{
	allMandatoryFieldsEntered = true;
	for (x = 0; x < mandatoryFields.length; x++)
	{
		field = mandatoryFields[x];
		if (field != null && field.value.length == 0)
		{
			allMandatoryFieldsEntered = false;
			break;
		}
	}
	if (allMandatoryFieldsEntered)
	{
		if (saveButton == null) return;
		saveButton.disabled = false
		saveButton.className = 'button';
	}
	else
	{
		if (saveButton == null) return;
		saveButton.disabled = true;
		saveButton.className = 'disabledButton';
	}
}
//-->