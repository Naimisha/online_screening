class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  $page_title = "Online Screening"
  rescue_from CanCan::AccessDenied do |exception|
  	flash.now[:error] = exception.message
  	flash.keep
  	redirect_to new_user_session_path
  end
  #UDPSocket.open do |s|
   #s.connect '64.233.187.99', 1
    #$ip_addr = s.addr.last
	#end	
end
