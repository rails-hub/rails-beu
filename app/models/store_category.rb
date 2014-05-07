class StoreCategory < ActiveRecord::Base
  attr_accessible :category_id, :store_id

  belongs_to :store  ,:dependent => :destroy
  belongs_to :category


  #     @stores =  StoreCategory.find_by_sql("select (select count(id) from user_stores where user_id = #{@user.id} and store_id = st.id) as user_store, st.*,
#       (select count(id) from deals as e where e.store_id = st.id) as coupons_count, st_cat.category_id from store_categories as st_cat
#      inner join stores as st on st_cat.store_id = st.id
#      where ( st_cat.category_id = #{category_id} )
#       order by st.name asc#")

#scope :stores, select('categories.id').select('categories.name').select('categories.description ').select('categories.logo_url').
#    joins("LEFT OUTER JOIN user_categories ON user_categories.category_id = categories.id AND user_categories.user_id = #{user_id}")
#  StoreCategory.find_by_sql("select (select count(id) from user_stores where user_id = #{user.id} and store_id = b.id) as user_store, b.*,
#       (select count(id) from deals as e where e.store_id = b.id) as coupons_count, a.category_id from store_categories
#       as a inner join stores as b on a.store_id = b.id inner join target_rules as c on b.target_rule_id = c.id
#      where (#{category_id} = 0 OR a.category_id = #{category_id} )
#      and (c.all = true or (c.#{user_gender} = true and c.#{get_rule_colum_name}=true)) order by b.name asc")
#  ///


end
