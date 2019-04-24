class TodoList < ApplicationRecord
  belongs_to :user
  has_many :todo_items

  def check_title_length(title)
  	title.length <= 120
  end

  def check_description_length(description)
  	description.length <= 160
  end
end
