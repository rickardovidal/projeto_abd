#Se for GET, mostra o formulário.
#Se for POST e o formulário for válido, chama o procedimento e volta à mesma página com mensagem
from .bdpost import apaga_medicamento, apaga_condicoes_medicas, altera_medicamento, altera_condicao_medica, insere_condicoes_medicas, insere_medicamento_bd
from django.shortcuts import render, redirect
from django.db import connections
from .forms import MedicamentoForm, CondicoesForm
from django.contrib import messages
from django.db import IntegrityError




def index(request):
    return render(request, 'index.html')


def inser_medicamento(request):
    msg = ''
    if request.method == 'POST':
        form =  MedicamentoForm(request.POST)
        if form.is_valid():
            nome = form.cleaned_data['nome']
            observacoes = form.cleaned_data['observacoes']
            insere_medicamento_bd(nome, observacoes)
            msg = 'Medicamento inserido com sucesso.'
            form = MedicamentoForm()
    else:
        form = MedicamentoForm()

    contexto = {
        'form': form,
        'msg': msg
    }
    return render(request, 'inser_medicamento.html', contexto)

def inser_condicao_medica(request):
    msg = ''
    if request.method == 'POST':
        form = CondicoesForm(request.POST)
        if form.is_valid():
            nome = form.cleaned_data['nome']
            observacoes = form.cleaned_data['observacoes']
            estado = form.cleaned_data['estado']
            insere_condicoes_medicas(nome, observacoes, estado)
            msg = 'Condição Médica inserida com sucesso.'
            form = CondicoesForm()
    else:
        form = CondicoesForm()

    contexto = {'form': form, 'msg': msg}
    return render(request, 'inser_condicao_medica.html', contexto)

#Cada linha é (id_aluno, numero, nome_aluno, nome_curso)

def consulta_medicamentos(request):
    cur = connections["default"].cursor()
    cur.execute("select * from vista_medicamentos")
    linhas = cur.fetchall()
    cur.close()
    contexto = {'linhas': linhas}
    return render(request, 'consulta_medicamentos.html', contexto)

def consulta_condicoes_medicas(request):
    cur = connections["default"].cursor()
    cur.execute("select * from vista_condicoes_medicas")
    linhas = cur.fetchall()
    cur.close()
    contexto = {'linhas': linhas}
    return render(request, 'consulta_condicoes_medicas.html', contexto)


def apaga_medicamento(request, id_medicamento):
    from .bdpost import apaga_medicamento as apaga_medicamento_bd
    apaga_medicamento_bd(id_medicamento)
    return redirect('consulta_medicamentos')

def apaga_condicoes_medicas(request, id_condicoes_medicas):
      from .bdpost import apaga_condicoes_medicas as apaga_condicoes_medicas_bd
      try:
          apaga_condicoes_medicas_bd(id_condicoes_medicas)
          messages.success(request, 'Condição médica eliminada com sucesso.')
      except IntegrityError:
          messages.error(request, 'Não é possível eliminar esta condição médica porque existem pacientes associados. Remova primeiro as associações.')
      return redirect('consulta_condicoes_medicas')


def altera_medicamento_view(request):
    cur = connections["default"].cursor()
    cur.execute("select id_medicamento, nome, observacoes from medicamentos")
    medicamentos = cur.fetchall()
    cur.close()

    if request.method == 'POST':
        id_medicamento = request.POST.get('id_medicamento')
        nome = request.POST.get('nome')
        observacoes = request.POST.get('observacoes')
        from .bdpost import altera_medicamento
        altera_medicamento(id_medicamento, nome, observacoes)

        cur = connections["default"].cursor()
        cur.execute("select id_medicamento, nome, observacoes from medicamentos")
        medicamentos = cur.fetchall()
        cur.close()

    contexto = {
        'lista_medicamentos': [
            {
                'id_medicamento': m[0],
                'nome': m[1],
                'observacoes': m[2]
            } for m in medicamentos
        ]
    }
    return render(request, 'altera_medicamento.html', contexto)


def altera_condicao_medica_view(request):
    cur = connections["default"].cursor()
    cur.execute("select id_condicoes_medicas, nome, observacoes, estado from condicoes_medicas")
    condicoes = cur.fetchall()
    cur.close()

    if request.method == 'POST':
        id_condicoes_medicas = request.POST.get('id_condicoes_medicas')
        nome = request.POST.get('nome')
        observacoes = request.POST.get('observacoes')
        estado = request.POST.get('estado') == 'on'
        from .bdpost import altera_condicao_medica
        altera_condicao_medica(id_condicoes_medicas, nome, observacoes, estado)

        cur = connections["default"].cursor()
        cur.execute("select id_condicoes_medicas, nome, observacoes, estado from condicoes_medicas")
        condicoes = cur.fetchall()
        cur.close()

    contexto = {
        'lista_condicoes': [
            {
                'id_condicoes_medicas': c[0],
                'nome': c[1],
                'observacoes': c[2],
                'estado': c[3]
            } for c in condicoes
        ]
    }
    return render(request, 'altera_condicao_medica.html', contexto)







