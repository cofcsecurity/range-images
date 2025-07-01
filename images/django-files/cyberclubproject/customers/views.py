from django.shortcuts import render

# Create your views here.
def customers(request):
    return render(request, 'customers.html')