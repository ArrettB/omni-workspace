<%@ include file="includes/init.jsp" %>

<html>
<head>
<title>Ajax Demo</title>

<script src="<c:url value="/js/prototype.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/rico.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/scriptaculous.js"/>"  type="text/javascript"></script>
<link href="<c:url value="/styles/script.aculo.us.css"/>"  media="screen" rel="Stylesheet" type="text/css" />
<style type="text/css">


    div.auto_complete {
            width: 350px;
            background: #cdcdcd;
          }
          div.auto_complete ul {
            border:1px solid #888;
            margin:0;
            padding:0;
            width:100%;
            list-style-type:none;
          }
          div.auto_complete ul li {
            margin:0;
            padding:3px;
          }
          div.auto_complete ul li.selected { 
            background-color: #ffb; 
          }
          div.auto_complete ul strong.highlight { 
            color: #800; 
            margin:0;
            padding:0;
          }
    
  </style>
  
<script language="javascript">
<!--//

function updateHidden(txt, li, prefix)
{
    hiddenName = txt.id.replace("_","");
    id = li.id.replace(prefix,"");
    txt.form[hiddenName].value = id;
}

-->
</script>
  
</head>

<body>
<br><br>
<input  type="hidden" name="cityautocomplete" value="-1">
City: <input autocomplete="off" type="text" id="city_autocomplete"/><div class="auto_complete" id="auto_complete"></div>
<script type="text/javascript">
new Ajax.Autocompleter("city_autocomplete", "auto_complete", "<c:url value="/cityByName2.ajxl"/>", {paramName: "name", minChars: 2, parameters: "prefix=city", afterUpdateElement: update});

function update(txt, li)
{
    updateHidden(txt, li, "city_");
}
</script>


<br/><br/><br/><br/>


CharmCity: <charm-ajax:autoSearch name="city" searchList="/charm-ajax/cityByName.ajxl" targetParam="name" value="x"/>

</body>
</html>