from django import forms

class creator_form(forms.Form):
	creator_first_name = forms.CharField(required=True, label='First Name', max_length=30)
	creator_last_name = forms.CharField(required=True, label='Last Name', max_length=30)
	creator_email = forms.EmailField(required=True, label='Email')
	payer_first_name = forms.CharField(required=True, label='Payer\'s First Name', max_length=30)
	payer_last_name = forms.CharField(required=True, label='Payer\'s Last Name', max_length=30)
	payer_email = forms.EmailField(required=True, label='Recipient\'s Email')
	personal_message = forms.CharField(required=True, label='Personal Message', max_length=1000)
	monthly_amount = forms.FloatField(required=True, min_value=0.01, max_value=1000, label='Payment Amount (Dollars)')
	num_payments = forms.IntegerField(required=True, min_value=1, max_value=24, label='Number of Payments')
	transaction_intervals = forms.IntegerField(required=True, min_value=1, max_value=12, label='Time Between each Payment (Months)')
	creator_routing_number = forms.CharField(required=True, label='Bank Routing number', max_length=30)
	creator_account_number = forms.CharField(required=True, label='Bank Account number', max_length=30)

class payer_form(forms.Form):
	card_number = forms.CharField(label='Card Number', min_length=16, max_length=16)
	card_exp_year = forms.CharField(label='Expiration Year (e.g. 1984)', min_length=4, max_length=4)
	card_exp_month = forms.CharField(label='Expiration Month (e.g. 08)', min_length=2, max_length=2)
	card_cvc = forms.CharField(label='CVC (e.g. 111)', min_length=3, max_length=3)