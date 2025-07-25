from django.shortcuts import render
from .models import Employee

# Create your views here.
# New views
def employees(request):
    all_employees = Employee.objects.all()
    context = {'employees' : all_employees}
    return render(request, 'employees.html', context)