from django.db import models
import uuid
import datetime

class transaction(models.Model):
    transaction_id = models.CharField(default=str(uuid.uuid4()), max_length=30)
    creator_first_name = models.CharField(max_length=30)
    creator_last_name = models.CharField(max_length=30)
    creator_email = models.EmailField()
    payer_first_name = models.CharField(max_length=30)
    payer_last_name = models.CharField(max_length=30)
    payer_email = models.EmailField()
    monthly_amount = models.IntegerField()
    num_payments = models.IntegerField()
    transaction_intervals = models.IntegerField()
    reason = models.CharField(max_length=1000, default="reasons not specified")
    
    creator_bank_id = models.CharField(max_length=30)
    payer_payment_id = models.CharField(max_length=30, default="0")
    payer_subscription_id = models.CharField(max_length=30, default="0")
    active = models.BooleanField(default=True)
