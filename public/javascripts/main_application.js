$(function() {
// deals wizard related functions started
 $('.data_restrict').click(function(){
    
    var div_id = $(this).attr('id');
    $('.toggle_d').addClass('hide').removeClass('show');
    $("div#d_"+div_id).addClass('show').removeClass('hide');

 });

 $('#validation_applier').click(function(){
    var div_id = $('div.toggle_d.show').attr('id');
    $('div#'+div_id+' .radio span input[type=radio]').each(function(){
        $(this).addClass('validate[required] radio');
    })
 });
    // deals wizard form validations
    $('#deals_wizard').validationEngine();
// deals wizard related functions ended


    $("#self, #full").click(function(){
        if($(this).attr("id")=='self'){
            $("table#full").hide();
            $("table#self").show();
        }
        else
        {
            $("table#full").show();
            $("table#self").hide();
        }
    });

});


function save_style_data(element){

    var attr_id, attr_style,column_name;
   attr_id= $(element).attr('id');
   attr_style = $(element).attr('style');
        //alert('attr_id'+attr_id+' ===>attr_style'+attr_style);
        //return
   switch(attr_id){
       case 'img_container':
           column_name = 'front_image_container_css'
           break;
       case 'item_img_container':
           column_name = 'item_image_container_css'
           break;
       case 'text' :
           column_name = 'description_css'
           break;
       default:
           alert('Element id not matched');
           return;
   }

      $.ajax({
        type: 'post',
        dataType: 'script',
        url:'/temp_images',
        data:{
            column_name: column_name,
            column_value: attr_style,
            not_image: true
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
//            alert("Error occured.");
//            alert(jqXHR.valueOf());
//            alert(textStatus);
//            alert(errorThrown)
        }
    });
}
