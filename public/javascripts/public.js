$(function(){



  // create a convenient toggleLoading function
  var toggleLoading = function() { 
//    alert('going--')
  };
  
//$("credit_card_form").observe("ajax:beforeSend",  toggleLoading).observe("ajax:complete", toggleLoading).observe("ajax:error", alert('error got')).observe("ajax:success", function(data, status, xhr) {
//      alert(status)
//      $("credit_info_display").html(data);
//    });

//$("#credit_card_form").bind("ajax:beforeSend",  toggleLoading).bind("ajax:complete", toggleLoading)
//.bind("ajax:success", function(status, data, xhr) {
//      alert("status"+status)
//      $("#credit_info_display").html(data);
//      $('#cboxClose').click()
//    });

//$('#deal_description').focusin(alert('sss'));
 // deal description text handling
if(readCookie('from_dealwizard')){
    eraseCookie('from_dealwizard')
    $('#deal_description').val($('#offer_description').val())
    save_session($('#deal_description').attr('id'), $('#deal_description').val());
}

//$('#deal_description').val($($('#offer_description').val()).val())
$('.notification').fadeOut(6000);

$('#colorSelector').ColorPicker({
	color: '#fff',
	onShow: function (colpkr) {
		$(colpkr).fadeIn(500);
		return false;
	},
	onHide: function (colpkr) {
		$(colpkr).fadeOut(500);
                save_session();
//                save_session('background_color', $('#deal_background_color').val());
		return false;
	},
	onChange: function (hsb, hex, rgb) {
		$('#colorSelector div').css('backgroundColor', '#' + hex);
		$('#deal_background_color').val('#' + hex);
                
                

	}
});
//   //setting background color fields values
if ($('#hback_color').val()!='')
$('#deal_background_color').val($('#hback_color').val());
$('#colorSelector>div').css({'background-color': $('#deal_background_color').val()});

switch($('#hback_image_or_color').val()){

    case "true":
        $($('.radio_b')[0]).attr('checked','checked').click();
        break;
    case "false":
        $($('.radio_b')[1]).attr('checked','checked').click();
    break;
}


//  //this will set values from coookies to deals form
set_deal_form_values()
 $(".hideable").click(function() {
    $(this).fadeOut(600);
  });
//  //cookies setter for deals function
$('.cookie_setter').click(function() {

    set_deal_values()
});

    // onclick of all checkbox
//    click_all($('#target_rule_all').is(':checked'));
    click_all();
    $('#target_rule_all').click(function(){ 
        check_uncheck($('#target_rule_all').is(':checked'));
    });

    //to set data of preview 
    set_data();
    set_date('#target_rule_stoday');
    
//    onload_set_data();
});
/*
 *on page load this will check/uncheck checkboxes
 */
function click_all(){
    value = readCookie('target_all')
    if($('#target_rule_all').length>0)
    eraseCookie('target_all')
    if(value=='1'){
        $('.under_all input:checkbox').each(function() {
                  $(this).prop('checked',true);
        });
    }


}
/*
 *on click this will check/uncheck checkboxes
 */
function check_uncheck(value){
    $('.under_all input:checkbox').each(function() {
        $(this).attr('checked', value)
       $(this).parent().toggleClass('checked',value)
});
}
//function onload_set_data(){
//    save_session($('#deal_description').attr('id'), $('#deal_description').val());
//    save_session($('#deal_font_name').attr('id'), $('#deal_font_name').val());
//    save_session($('#deal_font_size').attr('id'), $('#deal_font_size').val());
//    save_session($(this).attr('id'), $(this).is(':checked'));
//}

function set_data(){

     $('#deal_description').focusout(function(){
       
         save_session()
    });

    $('#deal_font_name, #deal_font_size').change(function(){

//      var selected_value = $(this).val()
//       $("#"+$(this).attr('id')+" option").each(function(){$(this).removeAttr('selected')});
//      $("#"+$(this).attr('id')+" option[value='"+selected_value+"']").attr('selected','selected')
        save_session()

    });
    
    $('#deal_bold, #deal_italic, #deal_underline').click(function(){

      save_session()
    })
    
    $('.radio_b').click(function(){
        save_session()

    });


}

function serialize_preview(){

    var attr_serialized = '';
    $('.preview_change').each(function(){
        var value = ($(this).attr('type')=='checkbox' || $(this).attr('type')=='radio') ? $(this).is(':checked') : $(this).val()
        attr_serialized += $(this).attr('id')+"="+ value+'&';
    })
    return attr_serialized
}
function save_session(){


    $.ajax({
        type: 'get',
        dataType: 'html',
        url:'/deals/set_preview',
        data:{
            preview_data: serialize_preview(),
            new_deal: $('#new_deal').val(),
            deal_id: $('#deal_id').val()
        },
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        success: function(data){


             try{
                 if ($('.preview').is(':visible')){
                     $('.preview').replaceWith("<div class=showpreview>"+data+"</div>");
                    }
                    else if($('.showpreview').is(':visible')){
                          $('.showpreview').replaceWith("<div class=preview>"+data+"</div>");
                    }
                 
                }catch(ex){}
        },
        error: function(jqXHR, textStatus, errorThrown){

            console.log("Error occured.");
            console.log(jqXHR);
            console.log(textStatus);
            console.log(errorThrown)
        }
    });
}

$(document).delegate( ".ajax-form", "ajax:complete", function(data, status){
    $("#cboxClose").click();
    save_session();
});

function set_background(value){
            save_session('back_image', value);
}




function values_setter(form_id){
//    alert(form_id);

    $(form_id+'back_color').val($('#colorSelector>div').css('background-color'));

    if($('#deal_back_image_or_color_true').is(':checked')== true){
         $(form_id+'back_img_color').val($('#colorSelector>div').css('background-color'));
    }else{

    }
    $(form_id+'back_img_color').val($('#colorSelector>div').css('background-color'));
    var back_image_or_color = $('.radio_b');
    if(back_image_or_color[0].checked == true){

        $('#temp_image_back_img_color').val(true);
    }
    else if(back_image_or_color[1].checked == true){
        $('#temp_image_back_img_color').val(false);
    }


//    alert($(form_id+'back_color').val())
//    $('#'+form_name+'_back_color').val($('#colorSelector>div').css('background-color'))

}

function show_coupen(){
    if ($('#hback_image_or_color').val() == "false"){
            $('#d_div').css({'background-color': $('#hback_color').val()});
            $('#d_div .p_image').hide();
       }
}
function preview_coupen(){
//
//    $('#dynamic_p').removeClass('hiden_div').addClass('show_div')
//    $('#basic_p').addClass('hiden_div').removeClass('show_div');
//    switch($('.radio_b')[1].checked){
//        case true:
//            $('.p_image').hide();
//            $('#dynamic_p').css({'background-color': $('#colorSelector>div').css('background-color')});
//            break;
//        case false:
//            $('.p_image').show();
//            $('#dynamic_p').css({'background-color': ''});
//            break;
//    }
}


function set_date(element){

      if($(element).attr('id')=='target_rule_stoday' ){
        switch($(element).is(':checked')){
            case true:
                $('#s_div .selector').addClass('disabled')
                $('#s_div select').each(function(){
                    $(this).attr('disabled','disabled')
                });
                break;
            default :
                $('#s_div .selector').removeClass('disabled');
                $('#s_div select').each(function(){
                    $(this).removeAttr('disabled')
                });
                break;

        }
    }
}

//function coupen_place_holder(element){
//
//    $(element).click($(element).attr('placeholder',''))
//}

//$('li.mainmenu a').click(alert('ff'));
function set_color(){
    $('#deal_background_color').val($('#colorSelector div').css('background-color'))
}


function check_format()
{
/*    alert('taim');
    if($('#target_rule_stoday').is(':checked')){
        $('#target_rule_start_date').val('today');
    }else{
        Time.utc(2000,"2",21,'','','')
        $('#target_rule_start_year').val()+','+$('#target_rule_start_month').val()+','+$('#target_rule_start_day').val()+','+
        $('#target_rule_start_date').val('today');
    }
*/
}

var colorboxOptions = {
  scroll: false,
  width: '400px',
  height: '400px',
    href : '#upload_f'
 // opacity: .7,
  //fixed: true,
  
//iframe:true
}



function upload_img(element){

    switch($(element).attr('id')){
        case 'upload_r':
        $("#upload_r").colorbox({
            inline:true,
            iframe:true,
            scrolling:false,
            href:"#upload_retail"
        });
        break;
        case 'upload_item' :
        $("#upload_item").colorbox({
            inline:true,
            iframe:true,
            scrolling:false,
            href:"#upload_item_div"
        });
        break;
        case 'upload_retailer' :
        $("#upload_retailer").colorbox({
            inline:true,
            iframe:true,
            scrolling:false,
            href:"#upload_retailer_div"
        });
        break;
        default:
        $("#upload").colorbox({
            width:'400px',
            height:'200px',
            inline:true,
            scrolling:false,
            href:"#upload_f"
        });
    }
    
    
    

}
function show_colorbox(element){
//    alert('fff')
    switch($(element).attr('id')){
        case 'credit_card_info':
        $("#credit_card_info").colorbox({
            inline:true,
//            iframe:true,
            scrolling:false,
            width:'500px',
//            id:'dd',
            href:"#credit_card_info_div"
        });
        break;
        default:
    }




}
function set_deal_form_values(){
//alert("in"+readCookie('deal_bold'))
//if(readCookie('deal_italic')==true)
//$('#deal_italic').attr('checked', 'checked').click()
//if(readCookie('deal_bold')=="true")
//$('#deal_bold').attr('checked', 'checked').click()
//if(readCookie("deal_underline")==true)
//$('#deal_underline').attr('checked', 'checked').click()
//$("#deal_font_name").val(readCookie("deal_font_name"))
//$("#deal_font_size").val(readCookie("deal_font_size"))
//$("#deal_title").val(readCookie("deal_title"))

}
function set_deal_values(){
 createCookie("deal_title",$('#deal_title').val(),1)
}

function rgb2hex(rgb){
 rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
 return "#" +
  ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
  ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
  ("0" + parseInt(rgb[3],10).toString(16)).slice(-2);
}

//  /functions used for cookies handling started
function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else  expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}

//  /functions used for cookies handling ended
