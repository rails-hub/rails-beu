class ArchiveContentsController < ApplicationController
  def index
    @deals = Deal.joins(:target_rule).where("target_rules.end_date <= ?  OR deals.is_inactive = ?",Time.zone.now.utc.to_datetime.to_s(:db), true).where(:store_id => current_user.stores.first.id) if current_user.stores.present? and current_user.stores.first.present?
  end
  def create
    redirect_to edit_deal_path(params[:deal_id])
  end
end