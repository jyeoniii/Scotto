from django import forms
from .models import Post

"""
class PostForm(forms.Form):
    title = forms.CharField(validators = [min_length_validator])
    content = forms.CharField(widget = forms.Textarea)
"""
class PostForm(forms.ModelForm):
    class Meta:
        model = Post
        fields = '__all__'
        #fields = ['title','tag_set', 'content']

    
