class Api::V1::TodoItemsController < ApplicationController
	before_action :find_user
	before_action :set_todo_list

	def index
		user = User.find_by(access_token: request.headers[:AUTHTOKEN])
		 
		if @todo_list.present? && @todo_list.user_id == user.id
			render json: {result:@todo_list.todo_items,responseStatus: true, responseCode: 200, responseMessage: "Todo Item Listed Succesfully!" }
		end
	end

	#Create todo list
	def create
		user = User.find_by(access_token: request.headers[:AUTHTOKEN])
		@todo_item = @todo_list.todo_items.new(todo_item_params)
		return render_message false, 402, "Title Must Exist." unless @todo_item && params[:todo_item][:title].present?
		return render_message false, 402, "Title length should be less than 120." unless @todo_item && @todo_item.check_title_length(params[:todo_item][:title])
		if @todo_item.save
			render json: {result:@todo_item,responseStatus: true, responseCode: 200, responseMessage: "Todo Item Created Succesfully!" }
		else
			render_message false,402, "Todo Item failed to Create!"
		end
	end

	def update
		user = User.find_by(access_token: request.headers[:AUTHTOKEN])
		@todo_item = @todo_list.todo_items.find_by(id: params[:id])
    	return render_message false, 402, "Title length should be less than 120." unless @todo_item && @todo_item.check_title_length(params[:todo_item][:title])
		if @todo_list.present? && @todo_list.user_id == user.id && @todo_item.present?
			if @todo_item.update(todo_item_params)
				render json: {result:@todo_item,responseStatus: true, responseCode: 200, responseMessage: "Todo Item Updated Succesfully!" }
			else
				render_message false,402, "Todo Item failed to Updated!"
			end
		else
			render_message false,402, "You are not authorized to edit this todo Item"
		end	
	end

	def show
		user = User.find_by(access_token: request.headers[:AUTHTOKEN])
		@todo_item = @todo_list.todo_items.find_by(id: params[:id])
		if @todo_list.present? && @todo_list.user_id == user.id && @todo_item.present?
				render json: {result:@todo_item,responseStatus: true, responseCode: 200, responseMessage: "Todo Item Found" }
		else
			render_message false,402, "You are not authorized to View this todo Item"
		end	
	end

	def destroy
		user = User.find_by(access_token: request.headers[:AUTHTOKEN])
		@todo_item = @todo_list.todo_items.find_by(id: params[:id])
		if @todo_list.present? && @todo_list.user_id == user.id && @todo_item.destroy
				render json: {result:@todo_item,responseStatus: true, responseCode: 200, responseMessage: "Todo Item Deleted Succesfully!" }
		else
			render_message false,402, "You are not authorized to Delete this todo Item"
		end	
	end

	private

	def todo_item_params
		params.require(:todo_item).permit(:title)
	end

	def set_todo_list
		@todo_list = TodoList.find_by(id: params[:todo_list_id])
	end
end
