class Item < Microframe::ORM::Base
  property :id, type: :integer, primary_key: true
  property :description, type: :text
  property :done, type: :boolean
  property :list_id, type: :integer

  create_table

  belongs_to :list
end
