from django.shortcuts import render

# Create your views here.
# New views
def employees(request):
    return render(request, 'employees.html')
