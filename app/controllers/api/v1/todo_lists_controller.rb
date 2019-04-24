class Api::V1::TodoListsController < ApplicationController
	before_action :find_user
	def index
		user = User.find_by(access_token: request.headers[:AUTHTOKEN])
		@todo_lists = user.todo_lists
		render json: {result:@todo_lists,responseStatus: true, responseCode: 200, responseMessage: "Todo List Listed Succesfully!" }
	end

	#Create todo list
	def create
		user = User.find_by(access_token: request.headers[:AUTHTOKEN])
		@todo_list = user.todo_lists.new(todo_list_params)
		return render_message false, 402, "Title Must Exist." unless @todo_list && params[:todo_list][:title].present?
		return render_message false, 402, "Title length should be less than 120." unless @todo_list && @todo_list.check_title_length(params[:todo_list][:title])
    return render_message false, 402, "Description length should be less than 160." unless @todo_list && @todo_list.check_description_length(params[:todo_list][:description])
		if @todo_list.save
			render json: {result:@todo_list,responseStatus: true, responseCode: 200, responseMessage: "Todo List Created Succesfully!" }
		else
			render_message false,402, "Todo List failed to Create!"
		end
	end

	def update
		user = User.find_by(access_token: request.headers[:AUTHTOKEN])
		@todo_list = TodoList.find_by(id: params[:id])
    return render_message false, 402, "Title length should be less than 120." unless @todo_list && @todo_list.check_title_length(params[:todo_list][:title])
    return render_message false, 402, "Description length should be less than 160." unless @todo_list && @todo_list.check_description_length(params[:todo_list][:description])
		if @todo_list.present? && @todo_list.user_id == user.id
			if @todo_list.update(todo_list_params)
				render json: {result:@todo_list,responseStatus: true, responseCode: 200, responseMessage: "Todo List Updated Succesfully!" }
			else
				render_message false,402, "Todo List failed to Updated!"
			end
		else
			render_message false,402, "You are not authorized to edit this todo list"
		end	
	end

	def show
		user = User.find_by(access_token: request.headers[:AUTHTOKEN])
		@todo_list = TodoList.find_by(id: params[:id])
		if @todo_list.present? && @todo_list.user_id == user.id
				render json: {result:@todo_list,responseStatus: true, responseCode: 200, responseMessage: "Todo List Found" }
		else
			render_message false,402, "You are not authorized to View this todo list"
		end	
	end

	def destroy
		user = User.find_by(access_token: request.headers[:AUTHTOKEN])
		@todo_list = TodoList.find_by(id: params[:id])
		if @todo_list.present? && @todo_list.user_id == user.id && @todo_list.destroy
				render json: {result:@todo_list,responseStatus: true, responseCode: 200, responseMessage: "Todo List Deleted Succesfully!" }
		else
			render_message false,402, "You are not authorized to Delete this todo list"
		end	
	end

	private

	def todo_list_params
		params.require(:todo_list).permit(:title, :description)
	end
end
