class SendPassword < ApplicationMailer
	default from: "karan.chandnani@infibeam.net"


	def send_mail_student(email,user_id,password)
		@email=email
		@user_id=user_id
		@password=password
		attachments.inline['image.png'] = File.read('public/images/infibeam-logo.png')
		mail(to: email,subject: 'Credentials for test')
	end
	def send_mail_admin(email,user_name,password,sender_name)
		@email=email
		@user_name=user_name
		@password=password
		@sender_name = sender_name
		attachments.inline['image.png'] = File.read('public/images/infibeam-logo.png')
		mail(to: email,subject: 'Credentials for your account')

	end
end

