from django.db import models
from django.conf import settings
import re
from django.forms import ValidationError
from django.urls import reverse
from django import forms

# Create your models here.
def lnglat_validator(value):
    if not re.match(r'^(\d+\.?\d*),(\d+\.?\d*)$', value) :
        raise ValidationError('Invalid lnglat type')
def min_length_validator(value):
    if(not value):
        raise forms.ValidationError('글자를 입력해 주세요.')

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

class Post(models.Model):



    title = models.CharField(max_length=100, validators = [min_length_validator]) # 길이제한있는 문자열
    content = models.TextField()            # 길이제한없는 문자열
    created_at = models.DateTimeField(auto_now_add=True) #최초 저장 시간만 저장
    updated_at = models.DateTimeField(auto_now=True)    #갱신이 될때마다 시간 저장

    author = models.CharField(max_length = 30, default = 'anonymous')



    class Meta: #class 내부의 class. default로 id의 역순 정렬
        ordering = ['-id']
    def __str__(self):      #shell 에서 제목을 보여주게 하기 위함
        return self.title

    def get_absolute_url(self):
        return reverse('home:post_detail', args = [self.id])

class Comment(models.Model):
    post =models.ForeignKey(Post,
    on_delete = models.CASCADE)
    author = models.CharField(max_length=10)
    message = models.TextField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
