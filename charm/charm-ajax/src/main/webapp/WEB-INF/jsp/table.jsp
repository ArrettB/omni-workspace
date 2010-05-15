<%@ include file="includes/init.jsp" %>

<html>
<head>
<title>Ajax Demo</title>

<script src="<c:url value="/js/prototype.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/rico.js"/>" type="text/javascript"></script>

<style>
.hotSheetTable {
   table-layout : fixed;
}

td.cell {
    padding       : 2px 0px 2px 3px;
    margin        : 0px;
    border-bottom : 1px solid #b8b8b8;
    border-right  : 1px solid #b8b8b8;
    height        : 22px;
    overflow      : hidden;
    font-size     : 11px;
    font-family: verdana, arial, helvetica, sans-serif;
    line-height: 12px;
}

.first {
   border-left  : 1px solid #b8b8b8;
}

.tableCellHeader {
   padding          : 2px 0px 2px 3px;
   text-align       : left;
   font-size        : 11px;
   border-top       : 1px solid #b8b8b8;
   border-right     : 1px solid #b8b8b8;
   background-color : #cedebd;
}
</style>

<script type="text/javascript">


	function bodyOnLoad()
	{
		var opts = { prefetchBuffer: true, onscroll: updateHeader };
		new Rico.LiveGrid ('data_grid', 5, 800, '<c:url value="/allCities.ajxt"/>' ,opts);
	}


   function updateHeader( liveGrid, offset )
   {
      $('bookmark').innerHTML = "Listing cities " + (offset+1) + " - " + (offset+liveGrid.metaData.getPageSize()) + " of " +
      liveGrid.metaData.getTotalRows();
      var sortInfo = "";
      if (liveGrid.sortCol)
      {
         sortInfo = "&data_grid_sort_col=" + liveGrid.sortCol + "&data_grid_sort_dir=" + liveGrid.sortDir;
      }
	  $('bookmark').href="<c:url value="/table.html"/>" + "?offset=" + offset + sortInfo;
   }

</script>

</head>

<body onload="javascript:bodyOnLoad()" >


<a id="bookmark" style="margin-bottom:3px;font-size:12px">Listing cities</a>
<div id="container" >
<table id="data_grid_header" class="hotSheetTable" cellspacing="0" cellpadding="0" style="width:400px">
  <tr>
	  <th class="first tableCellHeader" style="width:40px;text-align:center">Id</th>
	  <th class="tableCellHeader" style="width:280px">City</th>
	  <th class="tableCellHeader" style="width:80px">State</th>
  </tr>
</table>

<div id="data_grid_container" style="width:440px">
	<div id="viewPort" style="float:left">
<table id="data_grid"
         class="hotSheetTable"
         cellspacing="0"
	       cellpadding="0"
         style="width:410px; border-left:1px solid #ababab" >
 
 <charm:queryService
  	var="result"
 	namedQueryId="allCities"
/>
<c:forEach var="item" items="${result}" varStatus="loop">
 <c:if test="${loop.count < 10}">
  <tr> 
    <td class="cell" style="width:40px">${item.cityId}</td>
    <td class="cell" style="width:280px">${item.name}</td>
    <td class="cell" style="width:80px">${item.state}</td>
</tr>
</c:if>
</c:forEach> 

	</table>
  </div>
</div>
</div>

</body>
</html>