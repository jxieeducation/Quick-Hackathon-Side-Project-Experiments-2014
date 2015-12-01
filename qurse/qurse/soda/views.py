from __future__ import division
from django.shortcuts import render
from django.shortcuts import redirect
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from notification import *
from soda.models import transaction
from form import creator_form, payer_form
from stripe import create_pay, create_transaction, transfer, cancel_pay
import json

def index(request):
	context = {}
	return render(request, 'index.html', context)

def create(request):
	message = ""
	if request.method == 'GET':
		form = creator_form()
		context = {'creator_form':form, 'message': message}
		return render(request, 'create.html', context)
	elif request.method == 'POST':
		form = creator_form(request.POST)
		if form.is_valid():
			creator_first_name = form.cleaned_data['creator_first_name']
			creator_last_name = form.cleaned_data['creator_last_name']
			creator_email = form.cleaned_data['creator_email']
			payer_first_name = form.cleaned_data['payer_first_name']
			payer_last_name = form.cleaned_data['payer_last_name']
			payer_email = form.cleaned_data['payer_email']
			reason = form.cleaned_data['personal_message']
			monthly_amount = int(form.cleaned_data['monthly_amount'] * 100)
			num_payments = form.cleaned_data['num_payments']
			transaction_intervals = form.cleaned_data['transaction_intervals']
			creator_routing_number = form.cleaned_data['creator_routing_number']
			creator_account_number = form.cleaned_data['creator_account_number']
			creator_bank_id = create_transaction(creator_first_name + " " + creator_last_name, creator_email, creator_account_number, creator_routing_number)
			if creator_bank_id:
				#creates object
				new_transaction = transaction(creator_first_name=creator_first_name, creator_last_name=creator_last_name, creator_email=creator_email, creator_bank_id=creator_bank_id, payer_first_name=payer_first_name, payer_last_name=payer_last_name, payer_email=payer_email, monthly_amount=monthly_amount, num_payments=num_payments, transaction_intervals=transaction_intervals, reason=reason)
				new_transaction.save()
				creator_confirmation(new_transaction)
				payer_notification(new_transaction)
				return render(request, 'confirmation.html', {})
			else:
				message = "The bank account information is not valid."
		if not message:
			message = str(form.errors)
		context = {'creator_form':form, 'message':message}
		return render(request, 'create.html', context)

def pay(request, transaction_id):
	message = ""
	specific_transaction = transaction.objects.get(transaction_id=transaction_id)
	month_text = "months"
	payments_text = "payments"
	if specific_transaction.transaction_intervals == 1:
		month_text = "month"
	if specific_transaction.num_payments == 1:
		payment_text = "payment"
	if not specific_transaction.active or specific_transaction.payer_payment_id != "0":
		return redirect('soda.views.index')
	payment_info = "Payment to " + specific_transaction.creator_first_name + " " + specific_transaction.creator_last_name + ". Payment is $" + str(specific_transaction.monthly_amount / 100) + " every " + str(specific_transaction.transaction_intervals) + " " + month_text + " for " + str(specific_transaction.num_payments) + " " + payment_text + "."
	if request.method == 'GET':
		form = payer_form()
		context = {'payer_form':form, 'message':'', 'transaction_id':transaction_id, 'payment_info':payment_info}
		return render(request, 'pay.html', context)
	elif request.method == 'POST':
		form = payer_form(request.POST)
		if form.is_valid():
			card_number = form.cleaned_data['card_number']
			card_exp_year = form.cleaned_data['card_exp_year']
			card_exp_month = form.cleaned_data['card_exp_month']
			card_cvc = form.cleaned_data['card_cvc']
			payer_info = create_pay(card_number, card_exp_month, card_exp_year, card_cvc, specific_transaction.monthly_amount, transaction_id, specific_transaction.transaction_intervals)
			if payer_info:
				payer_payment_id = payer_info["customer"]
				payer_subscription_id = payer_info["subscription"]
				specific_transaction.payer_payment_id = payer_payment_id
				specific_transaction.payer_subscription_id = payer_subscription_id
				specific_transaction.save()
				accept_notification(specific_transaction)
				return render(request, 'receipt.html', {})
			else:
				message = "Invalid card information."
		if not message:
			message = str(form.errors)
		context = {'payer_form':form, 'message':message, 'transaction_id':transaction_id, 'payment_info':payment_info}
		return render(request, 'pay.html', context)


def status(request, transaction_id):
	message = ""
	specific_transaction = transaction.objects.get(transaction_id=transaction_id)
	context = {}
	context['creator_name'] = specific_transaction.creator_first_name + " " + specific_transaction.creator_last_name
	context['payer_name'] = specific_transaction.payer_first_name + " " + specific_transaction.payer_last_name
	context['num_payments'] = specific_transaction.num_payments
	context['monthly_amount'] = specific_transaction.monthly_amount / 100
	context['time_between_transactions'] = specific_transaction.transaction_intervals
	return render(request, 'status.html', context)


@csrf_exempt
def stripehook(request):
	body = json.loads(request.body)
	if body['type'] == "charge.succeeded":
		payer_id = body['data']['object']['customer']
		specific_transaction = transaction.objects.get(payer_payment_id=payer_id)
		recipient_id = specific_transaction.creator_bank_id
		amount = specific_transaction.monthly_amount
		if specific_transaction.active:
			creator_notification(specific_transaction)
			paid_notification(specific_transaction)
			transfer(recipient_id, amount)
			if specific_transaction.num_payments != 1:
				specific_transaction.num_payments -= 1
			else:
				specific_transaction.num_payments = 0
				cancel_pay(specific_transaction.payer_payment_id, specific_transaction.payer_subscription_id)
				specific_transaction.active = False
			specific_transaction.save()
	return HttpResponse("")
