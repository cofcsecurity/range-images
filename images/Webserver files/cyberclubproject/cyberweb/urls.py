from django.urls import path
from cyberweb import views

urlpatterns = [
    path('', views.home, name="home"),
    path('contact/', views.contact, name="contact"),
    path('services/', views.services, name="services"),
]
