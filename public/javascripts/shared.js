$(function() {
  $('#first_sub_b, #second_sub_b').click(function(){
    $('#first_sub').toggle();
    $('#second_sub').toggle();
  });

  // on doc load call
  select_sub_plan($('#selected_sub_plan').val());

  $("#new_user, #change_subscription_form, #renew_form").validationEngine();
  amount();//on load call

  $("#term").change(function(){

    amount();
    var today=  moment().format('DD-MM-YYYY') ;
    $("#fromdate").text(today).css({
      'font-weight':'bold'
    });
    $("#todate").text(moment().add('days',$(this).val()*30).format('DD-MM-YYYY')).css({
      'font-weight':'bold'
    });
  });
  $("input:radio").click(function(){
    //Make Due Amount
    amount();
    //[name='user[subscription_details_attributes][0][plan_id]']
    //alert($(this).attr("name"));
    //alert($(this).attr('id'));

    if ($(this).attr("name")=='user[subscription_details_attributes][0][plan_id]' || $(this).attr("name")=='plan_id'){

      var attr_id = $(this).attr("plan_data").split('@')
      $('#subPlan').text(attr_id[0]).css({
        'font-weight':'bold'
      });
      $('#campPerMonth').text(attr_id[1]).css({
        'font-weight':'bold'
      });
      $('#plan_id').val(attr_id[2]);
    }
    else
      {
        $('#subLevel').text($(this).attr("service_level")).css({
          'font-weight':'bold'
        });

        if($(this).attr("id")=='rdoself'){
          /* 
             $("div.full").hide();
             $("div.self").show();
             */
          collection = changeUserPackages("s");
//          $('#plan_9').parent().addClass('checked');
//          $('#plan_10').parent().removeClass('checked');
//          $('#plan_11').parent().removeClass('checked');
//          $('#plan_12').parent().removeClass('checked');
//          $('#subPlan').text('Platinum').css({ 'font-weight':'bold' });
          index = $(".self").find("#plans").find("input:radio").index($(".self").find("#plans").find("input:radio:checked"));
            if( index >= 0 ){
              $('#plan_id').val(collection[index].id);
              if($(".subscription_present").length == 0){
                $('#dueamount').text(collection[index].price); 
               }
            }else{
              $('#plan_id').val('9');
              if($(".subscription_present").length == 0){
                $('#dueamount').text('999'); 
              }
            }

        }
        else if($(this).attr("id")=='rdofull')
          {
            /*$("div.full").show();
              $("div.self").hide();
              */
            collection = changeUserPackages("f");
//            $('#plan_13').parent().addClass('checked');
//
//            $('#plan_14').parent().removeClass('checked');
//            $('#plan_15').parent().removeClass('checked');
//            $('#plan_16').parent().removeClass('checked');
//            $('#subPlan').text('Platinum').css({ 'font-weight':'bold' });
            index = $(".self").find("#plans").find("input:radio").index($(".self").find("#plans").find("input:radio:checked"));
            if( index >= 0 ){
              $("#plan_id").val($(".self").find("#plans").find("input:radio:checked").val());
              if($(".subscription_present").length == 0){
                //$('#plan_id').val('13');
                $('#dueamount').text(collection[index].price);
              }
            }else{
              $("#plan_id").val("13");
              if($(".subscription_present").length == 0){
                $('#dueamount').text(1099);
              }
            }
          }
      }
  });

  $("#payment_expireDate").datepicker({
    dateFormat: "dd.mm.yy"
  });
});

function amount()
{
  var price=0;
  var period=$("#term").val();

  var selected = $("input[type='radio']:checked");

  if (selected.length > 0) // for admin end
    price = selected.attr("data");
  else if(selected.length==0) // for retailer end
    price = $('#selected_plan_price').val();

  $("#dueamount").html(Math.round(price*period));
  $("#payment_amount").val(Math.round(price*period));
}


function select_sub_plan(element_id){
  //alert('..'+element_id);
  //    if($("'#"+element_id+"'").length > 0){
  //        $("'#"+element_id+"'").attr('checked',true);
  //        alert($("'#"+element_id+"'").parent().attr('class'))
  //        $("'#"+element_id+"'").parent().addClass('checked');
  //    }
  var main_parent = $('#s_type').val()

  if(main_parent=='self'){
    $("div#full").hide();
    $("div#self").show();

  }
  else if(main_parent=='full')
    {
      $("div#full").show();
      $("div#self").hide();

    }
    //    alert($('#s_type').val())
}
