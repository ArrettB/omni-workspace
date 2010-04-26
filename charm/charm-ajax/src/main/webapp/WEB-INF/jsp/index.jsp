<%@ include file="includes/init.jsp" %>

<html>
<head>
<title>Ajax Demo</title>

<script src="<c:url value="/js/prototype.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/rico.js"/>" type="text/javascript"></script>

<style>
.fixedTable {
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
		new Rico.LiveGrid ('data_grid', 5, 1000, '/ca/data.html' ,opts);
	}


   function updateHeader( liveGrid, offset )
   {
      $('bookmark').innerHTML = "Listing movies " + (offset+1) + " - " + (offset+liveGrid.metaData.getPageSize()) + " of " +
      liveGrid.metaData.getTotalRows();
      var sortInfo = "";
      if (liveGrid.sortCol)
      {
         sortInfo = "&data_grid_sort_col=" + liveGrid.sortCol + "&data_grid_sort_dir=" + liveGrid.sortDir;
      }
	  $('bookmark').href="/rico/livegrid.page" + "?data_grid_index=" + offset + sortInfo;
   }

</script>

</head>

<body onload="javascript:bodyOnLoad()" >


<a id="bookmark" style="margin-bottom:3px;font-size:12px">Listing movies</a>
<div id="container" >
<table id="data_grid_header" class="fixedTable" cellspacing="0" cellpadding="0" style="width:560px">
  <tr>

	  <th class="first tableCellHeader" style="width:30px;text-align:center">#</th>
	  <th class="tableCellHeader" style="width:280px">Title</th>
	  <th class="tableCellHeader" style="width:80px">Genre</th>
	  <th class="tableCellHeader" style="width:50px">Rating</th>
	  <th class="tableCellHeader" style="width:60px">Votes</th>
	  <th class="tableCellHeader" style="width:60px">Year</th>

  </tr>
</table> 

<div id="data_grid_container" style="width:600px">
	<div id="viewPort" style="float:left">
<table id="data_grid"
         class="fixedTable"
         cellspacing="0"
	       cellpadding="0"
         style="width:530px; border-left:1px solid #ababab" >

    <tr>
    <td class="cell" style="width:30px;text-align:center">1</td>
	  <td class="cell" style="width:280px">Mr&nbsp;and&nbsp;Mrs&nbsp;Smith</td>

	  <td class="cell" style="width:80px">action</td>
	  <td class="cell" style="width:50px">9.0</td>
	  <td class="cell" style="width:60px">0</td>
	  <td class="cell" style="width:60px">0</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">2</td>

	  <td class="cell" style="width:280px">Shichinin&nbsp;no&nbsp;samurai</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">9.0</td>
	  <td class="cell" style="width:60px">31947</td>
	  <td class="cell" style="width:60px">1954</td>

	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">3</td>
	  <td class="cell" style="width:280px">The&nbsp;Lord&nbsp;of&nbsp;the&nbsp;Rings:&nbsp;The&nbsp;Return&nbsp;of&nbsp;the&nbsp;King</td>

	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">9.0</td>
	  <td class="cell" style="width:60px">103911</td>
	  <td class="cell" style="width:60px">2003</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">4</td>

	  <td class="cell" style="width:280px">Buono,&nbsp;y&nbsp;il&nbsp;brutto,&nbsp;il&nbsp;cattivo,&nbsp;Il</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">9.0</td>
	  <td class="cell" style="width:60px">30840</td>

	  <td class="cell" style="width:60px">1966</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">5</td>
	  <td class="cell" style="width:280px">The&nbsp;Lord&nbsp;of&nbsp;the&nbsp;Rings:&nbsp;The&nbsp;Fellowship&nbsp;of&nbsp;the&nbsp;Ring</td>

	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">9.0</td>
	  <td class="cell" style="width:60px">157984</td>
	  <td class="cell" style="width:60px">2001</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">6</td>

	  <td class="cell" style="width:280px">Star&nbsp;Wars</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">9.0</td>
	  <td class="cell" style="width:60px">135001</td>
	  <td class="cell" style="width:60px">1977</td>
	  </tr>


    <tr>
    <td class="cell" style="width:30px;text-align:center">7</td>
	  <td class="cell" style="width:280px">The&nbsp;Lord&nbsp;of&nbsp;the&nbsp;Rings:&nbsp;The&nbsp;Two&nbsp;Towers</td>
	  <td class="cell" style="width:80px">Action</td>

	  <td class="cell" style="width:50px">9.0</td>
	  <td class="cell" style="width:60px">115175</td>
	  <td class="cell" style="width:60px">2002</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">8</td>
	  <td class="cell" style="width:280px">Star&nbsp;Wars:&nbsp;Episode&nbsp;V&nbsp;-&nbsp;The&nbsp;Empire&nbsp;Strikes&nbsp;Back</td>

	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">9.0</td>
	  <td class="cell" style="width:60px">104167</td>
	  <td class="cell" style="width:60px">1980</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">9</td>

	  <td class="cell" style="width:280px">Raiders&nbsp;of&nbsp;the&nbsp;Lost&nbsp;Ark</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">9.0</td>
	  <td class="cell" style="width:60px">94133</td>
	  <td class="cell" style="width:60px">1981</td>

	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">10</td>
	  <td class="cell" style="width:280px">Apocalypse&nbsp;Now</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">9.0</td>

	  <td class="cell" style="width:60px">64552</td>
	  <td class="cell" style="width:60px">1979</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">11</td>
	  <td class="cell" style="width:280px">The&nbsp;Matrix</td>

	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">143322</td>
	  <td class="cell" style="width:60px">1999</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">12</td>

	  <td class="cell" style="width:280px">The&nbsp;Treasure&nbsp;of&nbsp;the&nbsp;Sierra&nbsp;Madre</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">10433</td>

	  <td class="cell" style="width:60px">1948</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">13</td>
	  <td class="cell" style="width:280px">Ran</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>

	  <td class="cell" style="width:60px">11917</td>
	  <td class="cell" style="width:60px">1985</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">14</td>
	  <td class="cell" style="width:280px">Taegukgi&nbsp;hwinalrimyeo</td>

	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">1746</td>
	  <td class="cell" style="width:60px">2004</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">15</td>

	  <td class="cell" style="width:280px">Oldboy</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">8719</td>
	  <td class="cell" style="width:60px">2003</td>
	  </tr>


    <tr>
    <td class="cell" style="width:30px;text-align:center">16</td>
	  <td class="cell" style="width:280px">Yojimbo</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">8921</td>

	  <td class="cell" style="width:60px">1961</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">17</td>
	  <td class="cell" style="width:280px">The&nbsp;Great&nbsp;Escape</td>
	  <td class="cell" style="width:80px">Action</td>

	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">19997</td>
	  <td class="cell" style="width:60px">1963</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">18</td>
	  <td class="cell" style="width:280px">Saving&nbsp;Private&nbsp;Ryan</td>

	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">99905</td>
	  <td class="cell" style="width:60px">1998</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">19</td>

	  <td class="cell" style="width:280px">The&nbsp;Incredibles</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">30189</td>
	  <td class="cell" style="width:60px">2004</td>
	  </tr>


    <tr>
    <td class="cell" style="width:30px;text-align:center">20</td>
	  <td class="cell" style="width:280px">Aliens</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">64570</td>

	  <td class="cell" style="width:60px">1986</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">21</td>
	  <td class="cell" style="width:280px">Kill&nbsp;Bill:&nbsp;Vol.&nbsp;1</td>
	  <td class="cell" style="width:80px">Action</td>

	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">65566</td>
	  <td class="cell" style="width:60px">2003</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">22</td>
	  <td class="cell" style="width:280px">Braveheart</td>

	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">92120</td>
	  <td class="cell" style="width:60px">1995</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">23</td>

	  <td class="cell" style="width:280px">All&nbsp;Quiet&nbsp;on&nbsp;the&nbsp;Western&nbsp;Front</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">6806</td>

	  <td class="cell" style="width:60px">1930</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">24</td>
	  <td class="cell" style="width:280px">Wo&nbsp;hu&nbsp;cang&nbsp;long</td>
	  <td class="cell" style="width:80px">Action</td>

	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">52043</td>
	  <td class="cell" style="width:60px">2000</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">25</td>
	  <td class="cell" style="width:280px">The&nbsp;Adventures&nbsp;of&nbsp;Robin&nbsp;Hood</td>

	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">7330</td>
	  <td class="cell" style="width:60px">1938</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">26</td>

	  <td class="cell" style="width:280px">Sin&nbsp;City</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">22697</td>
	  <td class="cell" style="width:60px">2005</td>
	  </tr>


    <tr>
    <td class="cell" style="width:30px;text-align:center">27</td>
	  <td class="cell" style="width:280px">Kill&nbsp;Bill:&nbsp;Vol.&nbsp;2</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>

	  <td class="cell" style="width:60px">44831</td>
	  <td class="cell" style="width:60px">2004</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">28</td>
	  <td class="cell" style="width:280px">Kumonosu&nbsp;jo</td>

	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">3309</td>
	  <td class="cell" style="width:60px">1957</td>
	  </tr>

    <tr>
    <td class="cell" style="width:30px;text-align:center">29</td>

	  <td class="cell" style="width:280px">Tasogare&nbsp;seibei</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">1808</td>
	  <td class="cell" style="width:60px">2002</td>
	  </tr>


    <tr>
    <td class="cell" style="width:30px;text-align:center">30</td>
	  <td class="cell" style="width:280px">Blade&nbsp;Runner</td>
	  <td class="cell" style="width:80px">Action</td>
	  <td class="cell" style="width:50px">8.0</td>
	  <td class="cell" style="width:60px">75479</td>

	  <td class="cell" style="width:60px">1982</td>
	  </tr>

	</table>
  </div>
</div>
</div>

</body>
</html>