from django.shortcuts import render

# Existing home view
def home(request):
    return render(request, 'home.html')

# New views
def contact(request):
    return render(request, 'contact.html')

def services(request):
    return render(request, 'services.html')
