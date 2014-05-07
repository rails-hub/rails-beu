module DealsWizardsHelper

  def selected_objective(compaign_obj_ids, obj)
     if compaign_obj_ids.present? and (compaign_obj_ids.include?(obj.id.to_s) or compaign_obj_ids.include?(obj.id))
       return true
     end
     return false
  end

end
