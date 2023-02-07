class BooksController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    read_count = ReadCount.new(book_id: @book.id, user_id: current_user.id)
    read_count.save
  end

  def index
    # 投稿一覧をいいねの合計数が多い順に並び替える
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorites).sort_by {|x| x.favorites.where(created_at: from...to).size}.reverse
    #infoテンプレのnewbook用
    @book = Book.new
    @book_comment = BookComment.new
    
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @books = Book.all

      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

   def correct_user
      @book = Book.find(params[:id])
      @user = @book.user
    unless @user == current_user
      redirect_to(books_path)
    end
   end

end
