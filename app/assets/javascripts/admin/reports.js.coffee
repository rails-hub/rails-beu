$ ->
  $(".reports-zones").change (eventObject) ->
    $.getJSON "/admin/reports/#{$(this).find("option:selected").val()}/retailers_list", (data) ->
      collection = new Array()
      collection.push "<option></option>"
      $.each data, (index, value) ->
        collection.push "<option value='#{value.id}'>#{value.name}</option>"
      $(".reports-users-lists").html(collection.join(" "))
      $(".report-campaign-list").html("<option></option>")
      $.uniform.update()  
  $(".reports-users-lists").change (eventObject) -> 
    $.getJSON "/admin/reports/#{$(this).find("option:selected").val()}/deals_list", (data) ->
      collection = new Array()
      collection.push "<option></option>"
      $.each data, (index, value) -> 
        collection.push "<option value='#{value.id}'>#{value.name}</option>"
      $(".report-campaign-list").html(collection.join(" "))
      $.uniform.update()  
