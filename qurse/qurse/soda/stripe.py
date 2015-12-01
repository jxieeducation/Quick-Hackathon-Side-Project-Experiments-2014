import requests, json
from requests.auth import HTTPBasicAuth

stripe_api_key = "sk_test_cDkJJEbpjNgxdD6gSNHGC0NM"

# Returns the customer ID of the payer
def create_pay(credit_card_number, exp_month, exp_year, cvc, amount, transaction_id, number_of_intervals):
    requests.post("https://api.stripe.com/v1/plans", data={"amount": amount, "interval": "month", "interval_count": number_of_intervals, "name":"Qurse Recurring Payment", "currency": "usd", "id": transaction_id}, auth=HTTPBasicAuth(stripe_api_key, ''))
    r = requests.post("https://api.stripe.com/v1/customers", data={"card[number]": credit_card_number, "card[exp_month]": exp_month, "card[exp_year]": exp_year, "card[cvc]": cvc, "plan": transaction_id}, auth=HTTPBasicAuth(stripe_api_key, ''))
    data = r.json()
    if("error" in data.keys()):
        return None
    return {"customer": data['id'], "subscription": data['subscriptions']['data'][0]['id']}

# Cancel subscription when number of payments is zero.
def cancel_pay(customer, subscription):
    requests.delete("https://api.stripe.com/v1/customers/" + customer + "/subscriptions/" + subscription, auth=HTTPBasicAuth(stripe_api_key, '')).json()

# Run this when you create a transaction. Stores the debtor's account and returns the debtor's ID.
def create_transaction(name, email, account, routing):
    r = requests.post("https://api.stripe.com/v1/recipients", data={"name": name, "email": email, "type": "individual", "bank_account[account_number]": account, "bank_account[country]": "US", "bank_account[routing_number": routing}, auth=HTTPBasicAuth(stripe_api_key, ''))
    data = r.json()
    if("error" in data.keys()):
        return None
    return data['id']

# Transfers money to the debtor. Recipient is the ID.
def transfer(recipient, amount):
    r = requests.post("https://api.stripe.com/v1/transfers", data={"recipient": recipient, "currency": "usd", "amount": amount}, auth=HTTPBasicAuth(stripe_api_key, ''))
