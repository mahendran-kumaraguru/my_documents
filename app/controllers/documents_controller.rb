class DocumentsController < ApplicationController
	require "base64"
  before_action :authenticate_user

  def authenticate_user
    current_user = User.find(session[:user_id]) if session[:user_id]
    if not current_user
      redirect_to login_path, :notice => "Please login to continue!"
    end
  end


  def index
  	@documents = Document.all
  end

  def new
  	@document = Document.new
  end

  def create
  	document = Document.new(document_params)
  	if(document.save)
  		redirect_to document_path(document.id)
  	else
  		redirect_to :back, flash[:errors] => "Failed to Save Document"
  	end
  end

  def show
  	@document = Document.find(params[:id])  
  	encoded = Base64.encode64(@document.to_xml)
  	decoded = Base64.decode64(encoded)
  	puts "encoded :\n #{encoded}"
  	puts "decoded :\n #{decoded}"
  	render :xml => @document	
  end

  private def document_params
  	params.require(:document).permit(:title, :author, :content)
  end
end
