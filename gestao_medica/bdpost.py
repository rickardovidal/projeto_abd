from django.db import connections

def insere_medicamento_bd(nome, observacoes):
    cur = connections["default"].cursor()
    cur.execute("call inserir_medicamentos (%s,%s)", (nome, observacoes))
    connections["default"].commit()
    cur.close()

def insere_condicoes_medicas(nome, observacoes, estado):
    cur = connections["default"].cursor()
    cur.execute("call inserir_condicoes_medicas (%s,%s,%s)",
                (nome, observacoes, estado))
    connections["default"].commit()
    cur.close()

def apaga_medicamento(id_medicamento):
    cur = connections["default"].cursor()
    cur.execute("call eliminar_medicamentos(%s)", (id_medicamento,))
    connections["default"].commit()
    cur.close()

def apaga_condicoes_medicas(id_condicoes_medicas):
    cur = connections["default"].cursor()
    cur.execute("call eliminar_condicoes_medicas(%s)", (id_condicoes_medicas,))
    connections["default"].commit()
    cur.close()

def altera_medicamento(id_medicamento, nome, observacoes):
      cur = connections["default"].cursor()
      cur.execute(
          "call atualizar_medicamentos(%s::integer, %s::varchar, %s::varchar)",
          (id_medicamento, nome, observacoes)
      )
      connections["default"].commit()
      cur.close()


def altera_condicao_medica(id_condicoes_medicas, nome, observacoes, estado):
    cur = connections["default"].cursor()
    cur.execute(
        "call atualizar_condicoes_medicas(%s,%s,%s,%s)",
        (id_condicoes_medicas, nome, observacoes, estado)
    )
    connections["default"].commit()
    cur.close()




#Usa a ligação default configurada no settings.py (escola_bd).
#Executa call insere_curso(...) com os parâmetros recebidos