from __future__ import division
from django.core.mail import send_mail
from django.conf import settings

def email_send(subject, message, to_email, from_email=settings.QURSE_EMAIL):
	send_mail(subject, message, from_email,
    to_email, fail_silently=False)

def creator_confirmation(transaction):
	message = "Hello " + transaction.creator_first_name + " " + transaction.creator_last_name + ",\n\nYou have successfully requested rent payments from " + transaction.payer_first_name + " " + transaction.payer_last_name + ". An email notification has been sent to the recipient. You will be emailed when the recipient accepts.\n\nThanks,\nQurse team"
	email_send(subject="You have Qursed someone", message=message, to_email=[transaction.creator_email])

def payer_notification(transaction):
	link = "http://qurse.me/pay/" + transaction.transaction_id + "/"
	month_text = "months"
	payments_text = "payments"
	if transaction.transaction_intervals == 1:
		month_text = "month"
	if transaction.num_payments == 1:
		payment_text = "payment"
	message = "Hello " + transaction.payer_first_name + " " + transaction.payer_last_name + ",\n\n" + transaction.creator_first_name + " " + transaction.creator_last_name + " has requested rent payments from you. There will be " + str(transaction.num_payments) + " " + payment_text + " of $" + str(transaction.monthly_amount/100) + ". Payments are every " + str(transaction.transaction_intervals) + " " + month_text + "\n\n\"" + transaction.reason + "\".\n\nClick on the following link to accept and complete the payment. " + link + "\n\nThanks,\nQurse team"
	email_send(subject="You have been Qursed by " + transaction.creator_first_name + " " + transaction.creator_last_name , message=message, to_email=[transaction.payer_email])

def accept_notification(transaction):
	link = "http://qurse.me/status/" + transaction.transaction_id + "/"
	month_text = "months"
	payments_text = "payments"
	if transaction.transaction_intervals == 1:
		month_text = "month"
	if transaction.num_payments == 1:
		payment_text = "payment"
	message = "Hello " + transaction.creator_first_name + " " + transaction.creator_last_name + ",\n\n" + transaction.payer_first_name + " " + transaction.payer_last_name + " has accepted your request for rent payments of $" + str(transaction.monthly_amount/100) + " every " + str(transaction.transaction_intervals) + " " + month_text + " for " + str(transaction.num_payments) + " total " + payment_text + ".\n\nYou can view information about this Qurse by clicking this link. " + link + "\n\nThanks,\nQurse team"
	email_send(subject="Your Qurse has been accepted by " + transaction.payer_first_name + " " + transaction.payer_last_name , message=message, to_email=[transaction.creator_email])

def creator_notification(transaction):
	link = "http://qurse.me/status/" + transaction.transaction_id + "/"
	message = "Hello " + transaction.creator_first_name + " " + transaction.creator_last_name + ",\n\n" + transaction.payer_first_name + " " + transaction.payer_last_name + " has paid you $" + str(transaction.monthly_amount/100) + " for rent. The funds have been deposited into your bank account.\n\nYou can view information about this Qurse by clicking this link. " + link + "\n\nThanks,\nQurse team"
	email_send(subject="Payment for Qurse from " + transaction.payer_first_name + " " + transaction.payer_last_name , message=message, to_email=[transaction.creator_email])

def paid_notification(transaction):
	link = "http://qurse.me/status/" + transaction.transaction_id + "/"
	message = "Hello " + transaction.payer_first_name + " " + transaction.payer_last_name + ",\n\n" + "Your credit card has been charged $" + str(transaction.monthly_amount/100) + " for payment to " + transaction.creator_first_name + " " + transaction.creator_last_name + ". No further action is necessary.\n\nYou can view information about this Qurse by clicking this link. " + link + "\n\nThanks,\nQurse team"
	email_send(subject="Payment for Qurse Received", message=message, to_email=[transaction.payer_email])
