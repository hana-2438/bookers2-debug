class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
      render "/searches/search"
    else
      @books = Book.looks(params[:search], params[:word])
      render "/searches/search"
    end
  end
end
