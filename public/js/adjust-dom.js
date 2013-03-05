// replace date time input field with one that we parse 
function api_ui_dateAdjust()
{
	$(".real_when").hide();
	$(".dummy_when").show();
	$(".dummy_i_when").val(new Date().toString());
	$(".dummy_i_when").blur(function(){
		d = $(this).val();
		dd = Date.parse(d);
		if(isNaN(dd)) {
			$(this).css('background-color','red');
		} else {
			$(this).css('background-color','#00aa00');
			$(this).parent().siblings(".real_when").children(".real_i_when").val(dd)
		}
	});
}

api_ui_dateAdjust();