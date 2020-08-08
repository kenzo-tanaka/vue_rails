class V1::TodosController < ApplicationController
  def create
    todo = Todo.new(todo_params)
    if todo.save
      render json: todo, statsu: :created
    else
      render json: todo.errors, status: :unprocessable_entity
    end
  end

  private
    def todo_params
      params.require(:todo).permit(:title)
    end
end
