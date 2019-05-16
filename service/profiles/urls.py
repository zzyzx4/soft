from django.urls import path
# from .cookies import home_cookies
from django.contrib.auth.views import LoginView, LogoutView
from profiles import views
urlpatterns = [
    # path('home/cookies/', home_cookies, name='home-cookies'),
    path('login/', LoginView.as_view(template_name='registration/login.html'), name="login"),
    path("logout/", LogoutView.as_view(), name="user_logout"),
    path('signup/', views.Signup.as_view(), name='signup'),
    path('activate/<str:uid>/<str:token>', views.Activate.as_view(), name='activate'),

]
