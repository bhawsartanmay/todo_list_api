class TodoItem < ApplicationRecord
  belongs_to :todo_list

  def check_title_length(title)
  	title.length <= 120
  end
end
