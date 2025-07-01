from django.urls import path
from cyberweb import views

urlpatterns = [
    path('home/', views.home, name="home"),
]
