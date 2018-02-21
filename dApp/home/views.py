from django.shortcuts import render, get_object_or_404, redirect
from .models import League, Team, Post, Comment
from django.forms.models import model_to_dict
from django.http import HttpResponse,JsonResponse
from .forms import PostForm
from django.contrib import messages
# Create your views here.

def main(request):
  leagues = League.objects.all()

  return render(request, 'home/main.html', {"leagues":leagues})

def game(request, id):
  return render(request, 'home/game.html', {"gid":id})


def account(request):
    return render(request, 'home/account.html')

def get_league_list():
  league_list = League.objects.all()
  return {'leagues': league_list}

def all_json_models(request, league):
  league = league.replace("_", " ")
  current_league = League.objects.get(name=league)
  teams = Team.objects.all().filter(league=current_league)

  teams_dict = []

  for t in teams:
    teams_dict.append(model_to_dict(t))

  return JsonResponse(teams_dict, safe=False)


def post_list(request):
    qs = Post.objects.all()


    q = request.GET.get('q', '')
    if q:
        qs = qs.filter(title__icontains=q)
    return render(request, 'home/post_list.html', { 'post_list' : qs, 'q' : q} )

def post_posting(request):
    if request.method == 'POST':
        form = PostForm(request.POST, request.FILES)
        if form.is_valid():
            post = form.save()
            #messages.add_message(request, messages.INFO, '새 글이 등록되었습니다.')
            messages.info(request, '새 글이 등록되었습니다.') # 메세지 등록만 하는 코드임.
            # 소비하는 코드는 템플릿에 넣어줘야함.

            #저장을 form 내에서 안할때는 commit = False 인자로 전달.
            return redirect('post_detail', post.id)
            #return redirect(post) # get_absolute_url 이 post 내 구현 되어있음
        else:
            form.errors
    else: #Get 요청일 때
        form = PostForm()
    return render(request, 'home/post_posting.html', {'form' : form})

def post_edit(request, id):
    post = get_object_or_404(Post, id = id)
    if request.method == 'POST':
        form = PostForm(request.POST, instance = post)
        if form.is_valid():
            post.title = form.cleaned_data['title']
            post.content = form.cleaned_data['content']
            post.save()
            messages.info(request, '글이 수정되었습니다.')

            return redirect('home:post_detail', post.id)
        else:
            form.errors
    else: #Get 요청일 때
        form = PostForm(instance = post)
    return render(request, 'home/post_posting.html', {'form' : form})
def post_detail(request, id):
    """
    try:
        post = Post.objects.get(id = id)
    except Post.DoesNotExist:
        raise Http404
    """
    #아래 코드와 동일
    post = get_object_or_404(Post, id= id) # 지정 레코드가 없을 경우 404에러 발생
    return render(request, 'home/post_detail.html', {
        'post':post,
         })
