from django.urls import path
from employees import views

urlpatterns = [
    path('employees/', views.employees, name="employees"),
]
