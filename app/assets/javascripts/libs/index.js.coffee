window.changeUserPackages = (v) ->
  collection = JSON.parse($("#plan_#{v}_type_values").val())
  $(".self").find("span#plans").find("input:radio").each (index, value)->
    $this = $(this)
    @value = collection[index].id
    $this.parents("div.radio").next().val("#{collection[index].title} - #{collection[index].month}")
    $(".monthly-pricing-container").find("label").get(index).innerHTML = "#{collection[index].price} per month"
  collection

