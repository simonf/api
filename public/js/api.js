$(function(){
	fetch_and_show_item_types('/activities','#a_table tbody',['what','when','category','quantity']);
	fetch_and_show_item_types('/events','#e_table tbody',['what','when','category','who','where']);
});

function fetch_and_show_item_types(url,selector, attribute_names) {
	$.getJSON(url, function(data) {
  		var items = [];
 		$.each(data, function(ndx, val) {
    		items.push(make_table_row(val,attribute_names));
  		});
 		$(selector).append(items.join(''));
	});
}

function make_table_row(obj, attribute_names) {
	retval="<tr>";
	var i = 0;
	var len = attribute_names.length;
	for(i=0;i<len;i++) {
		retval = retval + "<td>" + obj[attribute_names[i]] + "</td>";
	}
	return retval+"</tr>";
}