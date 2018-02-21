from django.db import models

# Create your models here.

class League(models.Model):
  name = models.CharField(max_length=64)
  
  def __str__(self):
    return self.name

class Team(models.Model):
  name = models.CharField(max_length=64)
  league = models.ForeignKey(
            League,
            on_delete = models.CASCADE,
            related_name = 'teams',
            null = False
          )

  def __str__(self):
    return self.name

class Account(models.Model):
  addr = models.CharField(max_length=42)

class Transaction(models.Model):
  sender = models.ForeignKey(
            Account,
            on_delete = models.CASCADE,
            related_name = 'txs',
            null = False
           )
  txid = models.CharField(max_length=66)
  txtype = models.CharField(max_length=6)

  league = models.CharField(max_length=64)
  teamA = models.CharField(max_length=64)
  teamB = models.CharField(max_length=64)
  startTime = models.CharField(max_length=30)

  def __str__(self):
    return self.txid
