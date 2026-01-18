from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('insere_medicamento/', views.inser_medicamento, name='inser_medicamento'),
    path('insere_condicao_medica/', views.inser_condicao_medica, name='inser_condicao_medica'),
    path('consulta_medicamentos/', views.consulta_medicamentos, name='consulta_medicamentos'),
    path('consulta_condicao_medica/', views.consulta_condicoes_medicas, name='consulta_condicoes_medicas'),
    path('apaga_medicamento/<int:id_medicamento>/', views.apaga_medicamento, name='apaga_medicamento'),
    path('apaga_condicao_medica/<int:id_condicoes_medicas>/', views.apaga_condicoes_medicas, name='apaga_condicoes_medicas'),
    path('altera_medicamento/', views.altera_medicamento_view, name='altera_medicamento'),
    path('altera_condicao_medica/', views.altera_condicao_medica_view, name='altera_condicao_medica'),


]
