class DocumentsController < ApplicationController
	require "base64"
	require 'net/http'

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
  		redirect_to document_path(document.id, capitalize:true)
  	else
  		redirect_to :back, flash[:errors] => "Failed to Save Document"
  	end
  end

  def show
  	if(params[:capitalize])
  		show_capitalized
  	else
  		@document = Document.find(params[:id])
  	end
  end

  def show_capitalized
  	@document = Document.find(params[:id])  
  	encoded = Base64.encode64(@document.to_xml(skip_instruct: true))
  	decoded = Base64.decode64(encoded)
  	puts "encoded :\n #{encoded}"
  	puts "decoded :\n #{decoded}"
  	url = URI.parse('http://localhost:3002/capitalize.json')
  	data = { "data": encoded }
	res = Net::HTTP.post_form url, data
	# res = Net::HTTP.start(url.host, url.port) {|http|
	#   http.request(req)
	# }
	puts "response: \n#{res.body}"
	response_xml = Base64.decode64(res.body)
	puts "decoded response: \n#{response_xml}"
  	render :xml => response_xml
  end

  private def document_params
  	params.require(:document).permit(:title, :author, :content)
  end
end
