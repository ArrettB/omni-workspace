<!--// 
//Attach with:
// <script language="JavaScript" src="/js/formatting.js"></script>


function trim(textToTrim)
{
	while(textToTrim.charAt(0) == ' ')
		textToTrim = textToTrim.substring(1);

	while(textToTrim.charAt(textToTrim.length-1) == ' ')
		textToTrim = textToTrim.substring(0, textToTrim.length-1);

	return textToTrim;
}

function replaceAll(value, searchText, replaceText)
{
	while (value.indexOf(searchText) >= 0)
	{
		value = value.replace(searchText, replaceText);
	}

	return value;
}

function padout(number)
{
	return (number < 10) ? '0' + number : number;
}


function ampm(time)
{
	var hours = time.getHours(), minutes = padout(time.getMinutes());
	var adjhours = (hours == 0) ? 12 : ((hours < 13) ? hours : hours-12);
	return ((adjhours < 10) ? ' ' : '') + adjhours + ':' + minutes + ((hours < 12) ? ' am' : ' pm');
}

function formatMoney(number)
{
	return "$" + formatDollars(Math.floor(number-0) + '') + formatCents(number - 0);
}

function formatDollars(number)
{
	if (number.length <= 3)
		return (number == '' ? '0' : number);
	else {
		var mod = number.length%3;
		var output = (mod == 0 ? '' : (number.substring(0,mod)));
		for (i=0 ; i < Math.floor(number.length/3) ; i++) {
			if ((mod ==0) && (i ==0))
				output+= number.substring(mod+3*i,mod+3*i+3);
			else
				output+= ',' + number.substring(mod+3*i,mod+3*i+3);
		}
		return (output);
	}
}

function formatCents(amount)
{
	amount = Math.round( ( (amount) - Math.floor(amount) ) *100);
	return (amount < 10 ? '.0' + amount : '.' + amount);
}

function formatDate(date)
{
	var result;
	if (isNaN(date.getMonth()) || isNaN(date.getDate()) || isNaN(date.getYear()))
	{
		return "";
	}
	else
	{
		result = padout(date.getMonth() + 1);
		result += "/" + padout(date.getDate());
		result += "/" + padout(date.getFullYear());
		return result;
	}
}


function formatDateTime(date)
{
	var result;
	result = padout(date.getMonth() + 1);
	result += "/" + padout(date.getDate());
	result += "/" + padout(date.getFullYear());
	result += " " + ampm(date);
	return result;
}



function moveItems(fromSelect, toSelect)
{
	var fromOptions = fromSelect.options;
	for (var i = fromOptions.length - 1; i >= 0; i--)
	{
		if (fromOptions[i].selected)
		{
			var moveMe = fromOptions[i];
			toSelect.options[toSelect.options.length] = new Option(moveMe.text, moveMe.value, false, false);
			fromSelect.options.remove(i);
		}
	}
}

function clearOptions(selectObj)
{
	if (selectObj.options)
	{
		var length = selectObj.options.length;
		for (var i = length -1; i >= 0; i--)
		{
			selectObj.options[i] = null;
		}
	}
}

function putFocus(formIndex)
{	
	if (formIndex < document.forms.length)
	{
		var theForm = document.forms[formIndex];
		if (theForm.elements.length > 0)
		{
			for (var i = 0; i < theForm.elements.length; i++)
			{
				if (theForm.elements[i].type != "hidden")
				{
					theForm.elements[i].focus();
					break;
				}
			}
		}
	
	}
 }

function titleCaseFieldChanged(field)
{
	var result = "";
	var val = field.value;
	var valArray = val.split(" ");
	for (var i = 0; i < valArray.length; i++)
	{
		result += valArray[i].substring(0, 1).toUpperCase() + valArray[i].substring(1).toLowerCase();
		result += " ";
	}
	
	field.value = result.substring(0, result.length - 1);
}

function timeFieldChanged(field)
{
	return true;
}


function dateFieldChanged(field)
{
	var val = field.value;
	var months = null;
	var days = null;
	var years = null;

        val = replaceAll(val, " ", "");
	val = replaceAll(val, "\\", "");
	val = replaceAll(val, "-", "/");
	
	firstSep = val.indexOf("/");
	secondSep = val.indexOf("/", firstSep + 1);
	lastSep = val.lastIndexOf("/");
	
	if (firstSep != -1 && secondSep != -1 && secondSep == lastSep) 
	{
		months = val.substring(0, firstSep);
		days = val.substring(firstSep + 1, secondSep);
		years = val.substring(secondSep + 1);
	
	}
	else
	{

		if( val.length == 0 )
		{
			//do nothing
		}
		else if( val.length < 4 || val.length > 8 )
		{//invalid date entered
			if ( alert("You entered an invalid date of '"+field.value+"'. Please update the last field.") )
			{
			}
			field.value = "";
		}
		else
		{//format date

			if( val.length == 4 || val.length == 6)
			{//1 digit month and day
				months = val.substring(0,1);
				days = val.substring(1,2);
				years = val.substring(2);
			}
			else if( val.length == 5 || val.length == 7)
			{//assume 1 digit month and 2 digit day if no separator
				var monthDayTest = new Number(field.value.substring(2,3));
				if( isNaN( monthDayTest ) )
				{
					months = val.substring(0,2);
					days = val.substring(2,3);
				}
				else
				{
					months = val.substring(0,1);
					days = val.substring(1,3);
				}
				years = val.substring(3);
			}
			else if( val.length == 6 || val.length == 8)
			{//assuming 1 digit month and 2 digit day
				months = val.substring(0,2);
				days = val.substring(2,4);
				years = val.substring(4);
			}
		}
	}
		
	months--;
	if (years.length == 2)
	{
		var yearTest = new Number(years);
		if (!(isNaN(yearTest)))
		{	
			if (yearTest < 50)
			{
				years = "20" + years;
			}
			else
			{
				years = "19" + years;
			}
		}
		field.value = formatDate(new Date(years, months, days));
	}
	else if (years.length == 4)
	{
		field.value = formatDate(new Date(years, months, days));
	}
	else
	{
		field.value = "";
		field.focus();
		return false;
	}

}


function moneyFieldChanged(field)
{

	var amount = field.value;
	amount = replaceAll(amount, ",", "");
	amount = replaceAll(amount, "$", "");

	var isNeg = false;
	if (amount.charAt(0) == '(' && amount.charAt(amount.length-1) == ')')
	{
		isNeg = true;
		amount = "-" + amount.substring(1, amount.length-1);
	}

	var test = new Number(amount);
	if (!(isNaN(test)))
	{
		if (test < 0)
		{
			test = 0 - test;
			field.value = "(" + formatMoney(test) +")";
		}
		else
		{
			field.value = formatMoney(test);
		}
	}
	else
	{
		field.value = "";
	}

}

//-->