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
