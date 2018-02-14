from home.models import League, Team

f = open('teams', 'r')
x = f.read()

res = x.strip().split('\n\n')

l = None

for i in range(len(res)):
  if i%2 == 0:  # League
    l = League.objects.create(name=res[i])
    print(l)
  else:
    teams = res[i]
    ts = res[i].strip().split("\n")
    for t in ts:
      Team.objects.create(name=t, league=l)
