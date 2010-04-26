<!--
function makeButton(name, off, on, onclick)
{
	result = '';
	result += '<img border="0" src="/ims/images/' + off + '.gif"'
	       + ' onMouseDown="this.src=\'/ims/images/' + on + '.gif\'"'
	       + ' onMouseUp="this.src=\'/ims/images/' + off + '.gif\'"'
	       + ' onMouseOut="this.src=\'/ims/images/' + off + '.gif\'"';
	if (onclick && onclick.length > 0) 
		result += ' onClick="' + hrefToJS(onclick) + '"';
	if (name && name.length > 0) 
		result += ' id="' + name + '"';
	result += '>';

	//document.write(result.replace('<','&lt;').replace('>','&gt;'));
	//alert(result);
	document.write(result);
}

function makeButton2(name, content, className, onclick, style, img)
{
	if ((!content || content.length == 0) && (!img || img.length == 0)) return;
	result = '';
	result += '<div';
	if (name && name.length > 0) result += ' id="' + name + '"';
	if (className && className.length > 0) result += ' class="' + className + '"';
	if (style && style.length > 0) result += ' style="' + style + '"';
	if (onclick && onclick.length > 0)
	{
		result += ' onMouseDown="this.className=\'' + downState(className) + "'";
		if (img && img.length > 0) result += ';document.' + name + '.src=\'/ims/images/' + img + '_02.gif\'';
		result += '"';
		result += ' onMouseUp="this.className=\'' + className + "'";
		if (img && img.length > 0) result += ';document.' + name + '.src=\'/ims/images/' + img + '_01.gif\'';
		result += '"';
		result += ' onMouseOut="this.className=\'' + className + "'";
		if (img && img.length > 0) result += ';document.' + name + '.src=\'/ims/images/' + img + '_01.gif\'';
		result += '"';
		result += ' onClick="' + hrefToJS(onclick) + '"';
	}
	result += '>';
	result += '<table border="0" cellspacing="0" cellpadding="0">';
  	result += '<tr>';
    	result += '<td   class="makebutton2text">'+content+'</td>';
  	result += '</tr>';
	result += '</table>';

	if (img) result += '<img name="' + name + '" hspace="0" vspace="0" border="0" alt="" src="/ims/images/' + img + '_01.gif">';
	result += '</div>';

	//document.write(result.replace('<','&lt;').replace('>','&gt;'));
	//alert(result);
	document.write(result);
}


function hrefToJS(href)
{
	if (href.length > 11 && href.substring(0,11).toLowerCase() == 'javascript:')
		return fixString2(href.substring(11));
	else if (href.substring(0,1) == "/")
		return "location='" + fixString(href) + "'";
	else
		return fixString2(href);
}

function fixString(s)
{
	var result = s.replace(/\\/g , '\\\\');
	result = result.replace(/\'/g , "\\'");
	result = result.replace(/\"/g , '%22');
	return result;
}
function fixString2(s)
{
	var result = s.replace(/\"/g , '&quot;');
	return result;
}
function downState(className)
{
	return className.substr(0, className.length-1) + "2"
}

//-->
