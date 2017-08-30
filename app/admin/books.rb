ActiveAdmin.register Book do

  permit_params :title, :genre, :author, :publisher, :description, :library_id

  index do
    selectable_column
    column :id
    column :library
    column :title
    column :author
    column :author
    column :publisher
    column :address
    column :created_at
    actions
  end
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end
