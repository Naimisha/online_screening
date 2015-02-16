class SendPassword < ApplicationMailer
	default from: "karan.chandnani@infibeam.net"


	def send_mail(email,user_id,password)
		@email=email
		@user_id=user_id
		@password=password
		mail(to: email,subject: 'Your Id and password for test')
	end
end

