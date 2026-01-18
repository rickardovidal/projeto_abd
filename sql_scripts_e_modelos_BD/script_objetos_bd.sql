-- ============================================================
-- ÍNDICE DO DOCUMENTO
-- ============================================================
-- Para navegar, selecionar o texto da secção e Ctrl+F 
--
-- [SEC-01] SEQUENCES
-- [SEC-02] PROCEDIMENTOS DE INSERÇÃO (INSERT)
-- [SEC-03] PROCEDIMENTOS DE ATUALIZAÇÃO (UPDATE)
-- [SEC-04] PROCEDIMENTOS DE ELIMINAÇÃO (DELETE)
-- [SEC-05] TRIGGERS E FUNÇÕES DE TRIGGER
-- [SEC-06] POPULAÇÃO DA BASE DE DADOS (call dos procedures)
-- [SEC-07] VIEWS
-- ============================================================

-- [SEC-01] SEQUENCES
CREATE SEQUENCE acordos_subsistemas_seq START 1 INCREMENT 1;
CREATE SEQUENCE alergias_seq START 1 INCREMENT 1;
CREATE SEQUENCE pacientes_seq START 1 INCREMENT 1;
CREATE SEQUENCE tipos_utilizadores_seq START 1 INCREMENT 1;
CREATE SEQUENCE utilizadores_seq START 1 INCREMENT 1;
CREATE SEQUENCE medicos_seq START 1 INCREMENT 1;
CREATE SEQUENCE gabinetes_seq START 1 INCREMENT 1;
CREATE SEQUENCE tipos_consultas_seq START 1 INCREMENT 1;
CREATE SEQUENCE estados_consultas_seq START 1 INCREMENT 1;
CREATE SEQUENCE tipos_tratamentos_consultas_seq START 1 INCREMENT 1;
CREATE SEQUENCE tipos_anestesias_seq START 1 INCREMENT 1;
CREATE SEQUENCE consultas_seq START 1 INCREMENT 1;
CREATE SEQUENCE condicoes_medicas_seq START 1 INCREMENT 1;
CREATE SEQUENCE cirurgias_anteriores_seq START 1 INCREMENT 1;
CREATE SEQUENCE doencas_dentarias_seq START 1 INCREMENT 1;
CREATE SEQUENCE habitos_vida_seq START 1 INCREMENT 1;
CREATE SEQUENCE medicamentos_seq START 1 INCREMENT 1;
CREATE SEQUENCE tratamentos_seq START 1 INCREMENT 1;
CREATE SEQUENCE fases_de_tratamento_seq START 1 INCREMENT 1;
CREATE SEQUENCE tipos_documentos_seq START 1 INCREMENT 1;
CREATE SEQUENCE documentos_seq START 1 INCREMENT 1;
CREATE SEQUENCE notificacoes_seq START 1 INCREMENT 1;
CREATE SEQUENCE exp_anestesia_seq START 1 INCREMENT 1;
CREATE SEQUENCE tipos_medicamentos_seq START 1 INCREMENT 1;
-- ============================================================


-- [SEC-02] PROCEDIMENTOS DE INSERÇÃO (INSERT)

CREATE OR REPLACE PROCEDURE inserir_acordo_subsistema(
    p_nome IN varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM ACORDOS_SUBSISTEMAS 
    WHERE NOME = p_nome;

    IF v_existe = 0 THEN
        INSERT INTO ACORDOS_SUBSISTEMAS (ID_ACORDOS_SUBSISTEMAS, NOME)
        VALUES (nextval('acordos_subsistemas_seq'), p_nome);
    
        RAISE NOTICE 'O acordo "%" já existe na base de dados.', p_nome;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_alergia(
    p_nome IN varchar,
    p_observacoes IN varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM ALERGIAS 
    WHERE NOME = p_nome;

    IF v_existe = 0 THEN
        INSERT INTO ALERGIAS (ID_ALERGIAS, NOME, OBSERVACOES)
        VALUES (nextval('alergias_seq'), p_nome, p_observacoes);
    ELSE
        RAISE NOTICE 'A alergia "%" já existe.', p_nome;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_paciente(
    p_id_titular_paciente IN integer,
    p_id_acordos_subsistemas IN integer,
    p_nome IN varchar,
    p_nif IN varchar,
    p_data_nascimento IN date,
    p_genero IN varchar,
    p_numero_utente IN varchar,
    p_estado_civil IN varchar,
    p_profissao IN varchar,
    p_contacto_pessoal IN varchar,
    p_contacto_secundario IN varchar,
    p_morada IN varchar,
    p_codigo_postal IN varchar,
    p_localidade IN varchar,
    p_dependente_por_idade IN integer
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM PACIENTES 
    WHERE (p_nif IS NOT NULL AND NIF = p_nif)
       OR (p_nif IS NULL AND NOME = p_nome AND DATADENASCIMENTO = p_data_nascimento);

    IF v_existe = 0 THEN
        INSERT INTO PACIENTES (
            ID_PACIENTES, 
            ID_TITULAR_PACIENTE, 
            ID_ACORDOS_SUBSISTEMAS, 
            NOME, 
            NIF, 
            DATADENASCIMENTO, 
            GENERO, 
            NUMERODEUTENTE, 
            ESTADOCIVIL, 
            PROFISSAO, 
            CONTACTOPESSOAL, 
            CONTACTOSECUNDARIO, 
            MORADA, 
            CODIGOPOSTAL, 
            LOCALIDADE, 
            DEPENDENTEPORIDADE
        )
        VALUES (
            nextval('pacientes_seq'),
            p_id_titular_paciente, 
            p_id_acordos_subsistemas, 
            p_nome, 
            p_nif, 
            p_data_nascimento, 
            p_genero, 
            p_numero_utente, 
            p_estado_civil, 
            p_profissao, 
            p_contacto_pessoal, 
            p_contacto_secundario, 
            p_morada, 
            p_codigo_postal, 
            p_localidade, 
            p_dependente_por_idade
        );
    ELSE
        RAISE NOTICE 'O paciente "%" (ou com o mesmo NIF) já se encontra registado.', p_nome;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_tipo_utilizador(
    p_designacao varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM TIPOS_UTILIZADORES 
    WHERE DESIGNACAO = p_designacao;

    IF v_existe = 0 THEN
        INSERT INTO TIPOS_UTILIZADORES (ID_TIPOS_UTILIZADORES, DESIGNACAO)
        VALUES (nextval('tipos_utilizadores_seq'), p_designacao);
    ELSE
        RAISE NOTICE 'O tipo de utilizador "%" já existe.', p_designacao;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_utilizador(
    p_id_tipo_utilizador integer,
    p_username varchar,
    p_password varchar,
    p_email varchar,
    p_estado boolean
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM UTILIZADORES 
    WHERE USERNAME = p_username;

    IF v_existe = 0 THEN
        INSERT INTO UTILIZADORES (
            ID_UTILIZADORES, ID_TIPOS_UTILIZADORES, USERNAME, PASSWORD, EMAIL, ESTADO
        )
        VALUES (
            nextval('utilizadores_seq'), p_id_tipo_utilizador, p_username, p_password, p_email, p_estado
        );
    ELSE
        RAISE NOTICE 'O username "%" já está em uso.', p_username;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_medico(
    p_id_utilizador integer,
    p_nome varchar,
    p_especialidade varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM MEDICOS 
    WHERE ID_UTILIZADORES = p_id_utilizador;

    IF v_existe = 0 THEN
        INSERT INTO MEDICOS (ID_MEDICOS, ID_UTILIZADORES, NOME, ESPECIALIDADE)
        VALUES (nextval('medicos_seq'), p_id_utilizador, p_nome, p_especialidade);
    ELSE
        RAISE NOTICE 'Já existe um registo de médico associado ao utilizador %.', p_id_utilizador;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_gabinete(
    p_designacao varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM GABINETES 
    WHERE DESIGNACAO = p_designacao;

    IF v_existe = 0 THEN
        INSERT INTO GABINETES (ID_GABINETES, DESIGNACAO)
        VALUES (nextval('gabinetes_seq'), p_designacao);
    ELSE
        RAISE NOTICE 'O gabinete "%" já existe.', p_designacao;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_tipo_consulta(
    p_designacao varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM TIPOS_CONSULTA 
    WHERE DESIGNACAO = p_designacao;

    IF v_existe = 0 THEN
        INSERT INTO TIPOS_CONSULTA (ID_TIPO_CONSULTA, DESIGNACAO)
        VALUES (nextval('tipos_consultas_seq'), p_designacao);
    ELSE
        RAISE NOTICE 'O tipo de consulta "%" já existe.', p_designacao;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_estado_consulta(
    p_designacao varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM ESTADOS_CONSULTAS 
    WHERE DESIGNACAO = p_designacao;

    IF v_existe = 0 THEN
        INSERT INTO ESTADOS_CONSULTAS (ID_ESTADOS_CONSULTAS, DESIGNACAO)
        VALUES (nextval('estados_consultas_seq'), p_designacao);
    ELSE
        RAISE NOTICE 'O estado de consulta "%" já existe.', p_designacao;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_tipo_tratamento_consulta(
    p_designacao varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM TIPOS_TRATAMENTOS_CONSULTAS 
    WHERE DESIGNACAO = p_designacao;

    IF v_existe = 0 THEN
        INSERT INTO TIPOS_TRATAMENTOS_CONSULTAS (ID_TIPO_TRATAMENTOS_CONSULTAS, DESIGNACAO)
        VALUES (nextval('tipos_tratamentos_consultas_seq'), p_designacao);
    ELSE
        RAISE NOTICE 'O tipo de tratamento "%" já existe.', p_designacao;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_tipo_anestesia(
    p_designacao varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM TIPOS_ANESTESIAS 
    WHERE DESIGNACAO = p_designacao;

    IF v_existe = 0 THEN
        INSERT INTO TIPOS_ANESTESIAS (ID_TIPOS_ANESTESIAS, DESIGNACAO)
        VALUES (nextval('tipos_anestesias_seq'), p_designacao);
    ELSE
        RAISE NOTICE 'O tipo de anestesia "%" já existe.', p_designacao;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_consulta(
    p_id_gabinete integer,
    p_id_tratamento integer,
    p_id_medico integer,
    p_id_tipo_anestesia integer,
    p_id_estado_consulta integer,
    p_id_tipo_tratamento_consulta integer,
    p_id_paciente integer,
    p_id_tipo_consulta integer,
    p_datafase date,
    p_hora time,
    p_duracaoprevista integer
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM CONSULTAS 
    WHERE ID_MEDICOS = p_id_medico 
      AND DATAFASE = p_datafase 
      AND HORA = p_hora;

    IF v_existe = 0 THEN
        INSERT INTO CONSULTAS (
            ID_CONSULTAS, ID_GABINETES, ID_TRATAMENTOS, ID_MEDICOS, 
            ID_TIPOS_ANESTESIAS, ID_ESTADOS_CONSULTAS, ID_TIPO_TRATAMENTOS_CONSULTAS, 
            ID_PACIENTES, ID_TIPO_CONSULTA, DATAFASE, HORA, DURACAOPREVISTA
        )
        VALUES (
            nextval('consultas_seq'), p_id_gabinete, p_id_tratamento, p_id_medico, 
            p_id_tipo_anestesia, p_id_estado_consulta, p_id_tipo_tratamento_consulta, 
            p_id_paciente, p_id_tipo_consulta, p_datafase, p_hora, p_duracaoprevista
        );
    ELSE
        RAISE NOTICE 'O médico selecionado já possui uma consulta agendada para essa data e hora.';
    END IF;
END;
$$;

-- 2. Criar o procedimento com o nome novo
CREATE OR REPLACE PROCEDURE inserir_condicoes_medicas(
    p_nome varchar,
    p_observacoes varchar,
    p_estado boolean
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM CONDICOES_MEDICAS 
    WHERE NOME = p_nome;

    IF v_existe = 0 THEN
        INSERT INTO CONDICOES_MEDICAS (ID_CONDICOES_MEDICAS, NOME, OBSERVACOES, ESTADO)
        VALUES (nextval('condicoes_medicas_seq'), p_nome, p_observacoes, p_estado);
    ELSE
        RAISE NOTICE 'A condição médica "%" já existe.', p_nome;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_cirurgia_anterior(
    p_id_paciente integer,
    p_nome varchar,
    p_data date,
    p_hospital varchar,
    p_observacoes varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM CIRURGIAS_ANTERIORES 
    WHERE ID_PACIENTES = p_id_paciente AND NOME = p_nome AND DATAFASE = p_data;

    IF v_existe = 0 THEN
        INSERT INTO CIRURGIAS_ANTERIORES (
            ID_CIRURGIAS_ANTERIORES, ID_PACIENTES, NOME, DATAFASE, HOSPITAL, OBSERVACOES
        )
        VALUES (
            nextval('cirurgias_anteriores_seq'), p_id_paciente, p_nome, p_data, p_hospital, p_observacoes
        );
    ELSE
        RAISE NOTICE 'Esta cirurgia já está registada para este paciente nessa data.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_doenca_dentaria(
    p_nome varchar,
    p_descricao text
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM DOENCAS_DENTARIAS 
    WHERE NOME = p_nome;

    IF v_existe = 0 THEN
        INSERT INTO DOENCAS_DENTARIAS (ID_DOENCAS_DENTARIAS, NOME, DESCRICAO)
        VALUES (nextval('doencas_dentarias_seq'), p_nome, p_descricao);
    ELSE
        RAISE NOTICE 'A doença dentária "%" já existe.', p_nome;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_habito_vida(
    p_id_paciente integer,
    p_designacao varchar,
    p_observacoes varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM HABITOS_VIDA 
    WHERE ID_PACIENTES = p_id_paciente AND DESIGNACAO = p_designacao;

    IF v_existe = 0 THEN
        INSERT INTO HABITOS_VIDA (ID_HABITOS_VIDA, ID_PACIENTES, DESIGNACAO, OBSERVACOES)
        VALUES (nextval('habitos_vida_seq'), p_id_paciente, p_designacao, p_observacoes);
    ELSE
        RAISE NOTICE 'O hábito "%" já está registado para este paciente.', p_designacao;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_medicamentos(
    p_id_tipo_medicamento integer,
    p_nome varchar,
    p_observacoes varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM MEDICAMENTOS 
    WHERE NOME = p_nome;

    IF v_existe = 0 THEN
        INSERT INTO MEDICAMENTOS (ID_MEDICAMENTO, ID_TIPOS_MEDICAMENTOS, NOME, OBSERVACOES)
        VALUES (nextval('medicamentos_seq'), p_id_tipo_medicamento, p_nome, p_observacoes);
    ELSE
        RAISE NOTICE 'O medicamento "%" já existe.', p_nome;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_tratamento(
    p_id_paciente integer,
    p_nome varchar,
    p_estado boolean,
    p_numero_fases integer,
    p_data_inicio date,
    p_data_final date,
    p_descricao text,
    p_pos_tratamento varchar,
    p_num_consultas_fase integer,
    p_duracao_prevista integer
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM TRATAMENTOS 
    WHERE ID_PACIENTES = p_id_paciente AND NOME = p_nome AND DATAINICIO = p_data_inicio;

    IF v_existe = 0 THEN
        INSERT INTO TRATAMENTOS (
            ID_TRATAMENTOS, ID_PACIENTES, NOME, ESTADO, NUMERODEFASES, 
            DATAFINAL, DATAINICIO, DESCRICAO, POSTRATAMENTO, 
            NUMEROCONSULTASPORFASE, DURACAOPREVISTA
        )
        VALUES (
            nextval('tratamentos_seq'), p_id_paciente, p_nome, p_estado, p_numero_fases, 
            p_data_final, p_data_inicio, p_descricao, p_pos_tratamento, 
            p_num_consultas_fase, p_duracao_prevista
        );
    ELSE
        RAISE NOTICE 'Já existe um tratamento "%" iniciado nesta data para este paciente.', p_nome;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_fase_tratamento(
    p_id_tratamento integer,
    p_id_medico integer,
    p_nome varchar,
    p_data_fase date,
    p_estado boolean,
    p_observacoes varchar,
    p_anestesia boolean,
    p_numero_fase integer
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM FASES_DE_TRATAMENTO 
    WHERE ID_TRATAMENTOS = p_id_tratamento AND NUMEROFASE = p_numero_fase;

    IF v_existe = 0 THEN
        INSERT INTO FASES_DE_TRATAMENTO (
            ID_FASES_DE_TRATAMENTO, ID_TRATAMENTOS, ID_MEDICOS, NOME, 
            DATAFASE, ESTADO, OBSERVACOES, ANESTESIA, NUMEROFASE
        )
        VALUES (
            nextval('fases_de_tratamento_seq'), p_id_tratamento, p_id_medico, p_nome, 
            p_data_fase, p_estado, p_observacoes, p_anestesia, p_numero_fase
        );
    ELSE
        RAISE NOTICE 'A fase número % já está definida para este tratamento.', p_numero_fase;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_tipo_documento(
    p_designacao varchar,
    p_extensao varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM TIPOS_DOCUMENTOS 
    WHERE DESIGNACAO = p_designacao;

    IF v_existe = 0 THEN
        INSERT INTO TIPOS_DOCUMENTOS (ID_TIPOS_DOCUMENTOS, DESIGNACAO, EXTENCAO)
        VALUES (nextval('tipos_documentos_seq'), p_designacao, p_extensao);
    ELSE
        RAISE NOTICE 'O tipo de documento "%" já existe.', p_designacao;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_documento(
    p_id_tipo_documento integer,
    p_id_paciente integer,
    p_id_medico integer,
    p_nome varchar,
    p_caminho_ficheiro varchar,
    p_tamanho_bytes integer,
    p_data_upload timestamp,
    p_data_geracao timestamp,
    p_ativo boolean,
    p_observacoes varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM DOCUMENTOS 
    WHERE NOME = p_nome AND ID_PACIENTES = p_id_paciente AND DATA_UPLOAD = p_data_upload;

    IF v_existe = 0 THEN
        INSERT INTO DOCUMENTOS (
            ID_DOCUMENTOS, ID_TIPOS_DOCUMENTOS, ID_PACIENTES, ID_MEDICOS, 
            NOME, CAMINHO_FICHEIRO, TAMANHO_BYTES, DATA_UPLOAD, 
            DATA_GERACAO, ATIVO, OBSERVACOES
        )
        VALUES (
            nextval('documentos_seq'), p_id_tipo_documento, p_id_paciente, p_id_medico, 
            p_nome, p_caminho_ficheiro, p_tamanho_bytes, p_data_upload, 
            p_data_geracao, p_ativo, p_observacoes
        );
    ELSE
        RAISE NOTICE 'Este documento já parece estar registado para o paciente.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_notificacao(
    p_descricao text
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM NOTIFICACOES 
    WHERE DESCRICAO = p_descricao;

    IF v_existe = 0 THEN
        INSERT INTO NOTIFICACOES (ID_NOTIFICACAO, DESCRICAO)
        VALUES (nextval('notificacoes_seq'), p_descricao);
    ELSE
        RAISE NOTICE 'Esta notificação já existe no sistema.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_exp_anestesia(
    p_id_paciente integer,
    p_id_tipo_anestesia integer,
    p_observacoes varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM EXP_ANESTESIA 
    WHERE ID_PACIENTES = p_id_paciente AND ID_TIPOS_ANESTESIAS = p_id_tipo_anestesia;

    IF v_existe = 0 THEN
        INSERT INTO EXP_ANESTESIA (ID_EXP_ANESTESIA, ID_PACIENTES, ID_TIPOS_ANESTESIAS, OBSERVACOES)
        VALUES (nextval('exp_anestesia_seq'), p_id_paciente, p_id_tipo_anestesia, p_observacoes);
    ELSE
        RAISE NOTICE 'Já existe um registo desta anestesia para este paciente.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE associar_alergia_paciente(
    p_id_paciente integer,
    p_id_alergia integer
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM ALERGIAS_PACIENTES 
    WHERE ID_PACIENTES = p_id_paciente AND ID_ALERGIAS = p_id_alergia;

    IF v_existe = 0 THEN
        INSERT INTO ALERGIAS_PACIENTES (ID_PACIENTES, ID_ALERGIAS)
        VALUES (p_id_paciente, p_id_alergia);
    ELSE
        RAISE NOTICE 'O paciente já possui esta alergia registada.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE associar_condicao_paciente(
    p_id_paciente integer,
    p_id_condicao integer
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM CONDICOES_MEDICAS_PACIENTES 
    WHERE ID_PACIENTES = p_id_paciente AND ID_CONDICOES_MEDICAS = p_id_condicao;

    IF v_existe = 0 THEN
        INSERT INTO CONDICOES_MEDICAS_PACIENTES (ID_PACIENTES, ID_CONDICOES_MEDICAS)
        VALUES (p_id_paciente, p_id_condicao);
    ELSE
        RAISE NOTICE 'Esta condição médica já está associada ao paciente.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE associar_doenca_dentaria_paciente(
    p_id_paciente integer,
    p_id_doenca integer
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM DOENCAS_DENTARIAS_PACIENTES 
    WHERE ID_PACIENTES = p_id_paciente AND ID_DOENCAS_DENTARIAS = p_id_doenca;

    IF v_existe = 0 THEN
        INSERT INTO DOENCAS_DENTARIAS_PACIENTES (ID_PACIENTES, ID_DOENCAS_DENTARIAS)
        VALUES (p_id_paciente, p_id_doenca);
    ELSE
        RAISE NOTICE 'Esta doença dentária já está registada no paciente.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE associar_medicamento_paciente(
    p_id_paciente integer,
    p_id_medicamento integer
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM MEDICAMENTOS_PACIENTES 
    WHERE ID_PACIENTES = p_id_paciente AND ID_MEDICAMENTO = p_id_medicamento;

    IF v_existe = 0 THEN
        INSERT INTO MEDICAMENTOS_PACIENTES (ID_PACIENTES, ID_MEDICAMENTO)
        VALUES (p_id_paciente, p_id_medicamento);
    ELSE
        RAISE NOTICE 'Este medicamento já está associado ao paciente.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE associar_utilizador_paciente(
    p_id_paciente integer,
    p_id_utilizador integer
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM UTILIZADORES_PACIENTES 
    WHERE ID_PACIENTES = p_id_paciente AND ID_UTILIZADORES = p_id_utilizador;

    IF v_existe = 0 THEN
        INSERT INTO UTILIZADORES_PACIENTES (ID_PACIENTES, ID_UTILIZADORES)
        VALUES (p_id_paciente, p_id_utilizador);
    ELSE
        RAISE NOTICE 'Este utilizador já está associado ao paciente.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE associar_notificacao_utilizador(
    p_id_utilizador integer,
    p_id_notificacao integer
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM NOTIFICACOES_UTILIZADORES 
    WHERE ID_UTILIZADORES = p_id_utilizador AND ID_NOTIFICACAO = p_id_notificacao;

    IF v_existe = 0 THEN
        INSERT INTO NOTIFICACOES_UTILIZADORES (ID_UTILIZADORES, ID_NOTIFICACAO)
        VALUES (p_id_utilizador, p_id_notificacao);
    ELSE
        RAISE NOTICE 'Esta notificação já foi enviada/associada a este utilizador.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_tipo_medicamento(
    p_designacao varchar
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM TIPOS_MEDICAMENTOS 
    WHERE DESIGNACAO = p_designacao;

    IF v_existe = 0 THEN
        INSERT INTO TIPOS_MEDICAMENTOS (ID_TIPOS_MEDICAMENTOS, DESIGNACAO)
        VALUES (nextval('tipos_medicamentos_seq'), p_designacao);
    ELSE
        RAISE NOTICE 'O tipo de medicamento "%" já existe.', p_designacao;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE inserir_consentimento_rgpd(
    p_id_documento integer,
    p_recolha_tratamento boolean,
    p_dados_pessoais_clinicos boolean,
    p_publicacao_redes_sociais boolean,
    p_armazenamento_historico boolean,
    p_fotografias_cientificas boolean,
    p_fotografias_internas boolean,
    p_todos_consentimentos boolean,
    p_data_atualizacao timestamp
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_existe integer;
BEGIN
    SELECT count(*) INTO v_existe 
    FROM DOCUMENTOS_CONSENTIMENTO_RGPD 
    WHERE ID_DOCUMENTO = p_id_documento;

    IF v_existe = 0 THEN
        INSERT INTO DOCUMENTOS_CONSENTIMENTO_RGPD (
            ID_DOCUMENTO, RECOLHA_TRATAMENTO, DADOS_PESSOAIS_CLINICOS, 
            PUBLICACAO_REDES_SOCIAIS, ARMAZENAMENTO_HISTORICO, 
            FOTOGRAFIAS_CIENTIFICAS, FOTOGRAFIAS_INTERNAS, 
            TODOS_CONSENTIMENTOS, DATA_ATUALIZACAO
        )
        VALUES (
            p_id_documento, p_recolha_tratamento, p_dados_pessoais_clinicos, 
            p_publicacao_redes_sociais, p_armazenamento_historico, 
            p_fotografias_cientificas, p_fotografias_internas, 
            p_todos_consentimentos, p_data_atualizacao
        );
    ELSE
        RAISE NOTICE 'Já existe registo de RGPD para o documento %.', p_id_documento;
    END IF;
END;
$$;
-- ============================================================


-- [SEC-03] PROCEDIMENTOS DE ATUALIZAÇÃO (UPDATE)

CREATE OR REPLACE PROCEDURE alterar_acordo_subsistema(
    p_id_acordos_subsistemas IN integer,
    p_nome IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE ACORDOS_SUBSISTEMAS
    SET NOME = p_nome
    WHERE ID_ACORDOS_SUBSISTEMAS = p_id_acordos_subsistemas;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_alergia(
    p_id_alergias IN integer,
    p_nome IN varchar,
    p_observacoes IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE ALERGIAS
    SET NOME = p_nome,
        OBSERVACOES = p_observacoes
    WHERE ID_ALERGIAS = p_id_alergias;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_paciente(
    p_id_pacientes IN integer,
    p_id_titular_paciente IN integer,
    p_id_acordos_subsistemas IN integer,
    p_nome IN varchar,
    p_nif IN varchar,
    p_data_nascimento IN date,
    p_genero IN varchar,
    p_numero_utente IN varchar,
    p_estado_civil IN varchar,
    p_profissao IN varchar,
    p_contacto_pessoal IN varchar,
    p_contacto_secundario IN varchar,
    p_morada IN varchar,
    p_codigo_postal IN varchar,
    p_localidade IN varchar,
    p_dependente_por_idade IN integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE PACIENTES
    SET ID_TITULAR_PACIENTE = p_id_titular_paciente,
        ID_ACORDOS_SUBSISTEMAS = p_id_acordos_subsistemas,
        NOME = p_nome,
        NIF = p_nif,
        DATADENASCIMENTO = p_data_nascimento,
        GENERO = p_genero,
        NUMERODEUTENTE = p_numero_utente,
        ESTADOCIVIL = p_estado_civil,
        PROFISSAO = p_profissao,
        CONTACTOPESSOAL = p_contacto_pessoal,
        CONTACTOSECUNDARIO = p_contacto_secundario,
        MORADA = p_morada,
        CODIGOPOSTAL = p_codigo_postal,
        LOCALIDADE = p_localidade,
        DEPENDENTEPORIDADE = p_dependente_por_idade
    WHERE ID_PACIENTES = p_id_pacientes;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_tipo_utilizador(
    p_id_tipos_utilizadores IN integer,
    p_designacao IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE TIPOS_UTILIZADORES
    SET DESIGNACAO = p_designacao
    WHERE ID_TIPOS_UTILIZADORES = p_id_tipos_utilizadores;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_utilizador(
    p_id_utilizadores IN integer,
    p_id_tipo_utilizador IN integer,
    p_username IN varchar,
    p_password IN varchar,
    p_email IN varchar,
    p_estado IN boolean
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE UTILIZADORES
    SET ID_TIPOS_UTILIZADORES = p_id_tipo_utilizador,
        USERNAME = p_username,
        PASSWORD = p_password,
        EMAIL = p_email,
        ESTADO = p_estado
    WHERE ID_UTILIZADORES = p_id_utilizadores;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_medico(
    p_id_medicos IN integer,
    p_id_utilizador IN integer,
    p_nome IN varchar,
    p_especialidade IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE MEDICOS
    SET ID_UTILIZADORES = p_id_utilizador,
        NOME = p_nome,
        ESPECIALIDADE = p_especialidade
    WHERE ID_MEDICOS = p_id_medicos;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_gabinete(
    p_id_gabinetes IN integer,
    p_designacao IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE GABINETES
    SET DESIGNACAO = p_designacao
    WHERE ID_GABINETES = p_id_gabinetes;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_tipo_consulta(
    p_id_tipo_consulta IN integer,
    p_designacao IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE TIPOS_CONSULTA
    SET DESIGNACAO = p_designacao
    WHERE ID_TIPO_CONSULTA = p_id_tipo_consulta;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_estado_consulta(
    p_id_estados_consultas IN integer,
    p_designacao IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE ESTADOS_CONSULTAS
    SET DESIGNACAO = p_designacao
    WHERE ID_ESTADOS_CONSULTAS = p_id_estados_consultas;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_tipo_tratamento_consulta(
    p_id_tipo_tratamentos_consultas IN integer,
    p_designacao IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE TIPOS_TRATAMENTOS_CONSULTAS
    SET DESIGNACAO = p_designacao
    WHERE ID_TIPO_TRATAMENTOS_CONSULTAS = p_id_tipo_tratamentos_consultas;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_tipo_anestesia(
    p_id_tipos_anestesias IN integer,
    p_designacao IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE TIPOS_ANESTESIAS
    SET DESIGNACAO = p_designacao
    WHERE ID_TIPOS_ANESTESIAS = p_id_tipos_anestesias;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_consulta(
    p_id_consultas IN integer,
    p_id_gabinete IN integer,
    p_id_tratamento IN integer,
    p_id_medico IN integer,
    p_id_tipo_anestesia IN integer,
    p_id_estado_consulta IN integer,
    p_id_tipo_tratamento_consulta IN integer,
    p_id_paciente IN integer,
    p_id_tipo_consulta IN integer,
    p_datafase IN date,
    p_hora IN time,
    p_duracaoprevista IN integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE CONSULTAS
    SET ID_GABINETES = p_id_gabinete,
        ID_TRATAMENTOS = p_id_tratamento,
        ID_MEDICOS = p_id_medico,
        ID_TIPOS_ANESTESIAS = p_id_tipo_anestesia,
        ID_ESTADOS_CONSULTAS = p_id_estado_consulta,
        ID_TIPO_TRATAMENTOS_CONSULTAS = p_id_tipo_tratamento_consulta,
        ID_PACIENTES = p_id_paciente,
        ID_TIPO_CONSULTA = p_id_tipo_consulta,
        DATAFASE = p_datafase,
        HORA = p_hora,
        DURACAOPREVISTA = p_duracaoprevista
    WHERE ID_CONSULTAS = p_id_consultas;
END;
$$;

CREATE OR REPLACE PROCEDURE atualizar_condicoes_medicas(
    p_id_condicoes_medicas IN integer,
    p_nome IN varchar,
    p_observacoes IN varchar,
    p_estado IN boolean
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE CONDICOES_MEDICAS
    SET NOME = p_nome,
        OBSERVACOES = p_observacoes,
        ESTADO = p_estado
    WHERE ID_CONDICOES_MEDICAS = p_id_condicoes_medicas;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_cirurgia_anterior(
    p_id_cirurgias_anteriores IN integer,
    p_id_paciente IN integer,
    p_nome IN varchar,
    p_data IN date,
    p_hospital IN varchar,
    p_observacoes IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE CIRURGIAS_ANTERIORES
    SET ID_PACIENTES = p_id_paciente,
        NOME = p_nome,
        DATAFASE = p_data,
        HOSPITAL = p_hospital,
        OBSERVACOES = p_observacoes
    WHERE ID_CIRURGIAS_ANTERIORES = p_id_cirurgias_anteriores;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_doenca_dentaria(
    p_id_doencas_dentarias IN integer,
    p_nome IN varchar,
    p_descricao IN text
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE DOENCAS_DENTARIAS
    SET NOME = p_nome,
        DESCRICAO = p_descricao
    WHERE ID_DOENCAS_DENTARIAS = p_id_doencas_dentarias;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_habito_vida(
    p_id_habitos_vida IN integer,
    p_id_paciente IN integer,
    p_designacao IN varchar,
    p_observacoes IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE HABITOS_VIDA
    SET ID_PACIENTES = p_id_paciente,
        DESIGNACAO = p_designacao,
        OBSERVACOES = p_observacoes
    WHERE ID_HABITOS_VIDA = p_id_habitos_vida;
END;
$$;

CREATE OR REPLACE PROCEDURE atualizar_medicamentos(
    p_id_medicamento IN integer,
    p_id_tipo_medicamento IN integer,
    p_nome IN varchar,
    p_observacoes IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE MEDICAMENTOS
    SET ID_TIPOS_MEDICAMENTOS = p_id_tipo_medicamento,
        NOME = p_nome,
        OBSERVACOES = p_observacoes
    WHERE ID_MEDICAMENTO = p_id_medicamento;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_tratamento(
    p_id_tratamentos IN integer,
    p_id_paciente IN integer,
    p_nome IN varchar,
    p_estado IN boolean,
    p_numero_fases IN integer,
    p_data_inicio IN date,
    p_data_final IN date,
    p_descricao IN text,
    p_pos_tratamento IN varchar,
    p_num_consultas_fase IN integer,
    p_duracao_prevista IN integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE TRATAMENTOS
    SET ID_PACIENTES = p_id_paciente,
        NOME = p_nome,
        ESTADO = p_estado,
        NUMERODEFASES = p_numero_fases,
        DATAINICIO = p_data_inicio,
        DATAFINAL = p_data_final,
        DESCRICAO = p_descricao,
        POSTRATAMENTO = p_pos_tratamento,
        NUMEROCONSULTASPORFASE = p_num_consultas_fase,
        DURACAOPREVISTA = p_duracao_prevista
    WHERE ID_TRATAMENTOS = p_id_tratamentos;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_fase_tratamento(
    p_id_fases_de_tratamento IN integer,
    p_id_tratamento IN integer,
    p_id_medico IN integer,
    p_nome IN varchar,
    p_data_fase IN date,
    p_estado IN boolean,
    p_observacoes IN varchar,
    p_anestesia IN boolean,
    p_numero_fase IN integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE FASES_DE_TRATAMENTO
    SET ID_TRATAMENTOS = p_id_tratamento,
        ID_MEDICOS = p_id_medico,
        NOME = p_nome,
        DATAFASE = p_data_fase,
        ESTADO = p_estado,
        OBSERVACOES = p_observacoes,
        ANESTESIA = p_anestesia,
        NUMEROFASE = p_numero_fase
    WHERE ID_FASES_DE_TRATAMENTO = p_id_fases_de_tratamento;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_tipo_documento(
    p_id_tipos_documentos IN integer,
    p_designacao IN varchar,
    p_extensao IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE TIPOS_DOCUMENTOS
    SET DESIGNACAO = p_designacao,
        EXTENCAO = p_extensao
    WHERE ID_TIPOS_DOCUMENTOS = p_id_tipos_documentos;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_documento(
    p_id_documentos IN integer,
    p_id_tipo_documento IN integer,
    p_id_paciente IN integer,
    p_id_medico IN integer,
    p_nome IN varchar,
    p_caminho_ficheiro IN varchar,
    p_tamanho_bytes IN integer,
    p_data_upload IN timestamp,
    p_data_geracao IN timestamp,
    p_ativo IN boolean,
    p_observacoes IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE DOCUMENTOS
    SET ID_TIPOS_DOCUMENTOS = p_id_tipo_documento,
        ID_PACIENTES = p_id_paciente,
        ID_MEDICOS = p_id_medico,
        NOME = p_nome,
        CAMINHO_FICHEIRO = p_caminho_ficheiro,
        TAMANHO_BYTES = p_tamanho_bytes,
        DATA_UPLOAD = p_data_upload,
        DATA_GERACAO = p_data_geracao,
        ATIVO = p_ativo,
        OBSERVACOES = p_observacoes
    WHERE ID_DOCUMENTOS = p_id_documentos;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_notificacao(
    p_id_notificacao IN integer,
    p_descricao IN text
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE NOTIFICACOES
    SET DESCRICAO = p_descricao
    WHERE ID_NOTIFICACAO = p_id_notificacao;
END;
$$;
CREATE OR REPLACE PROCEDURE alterar_exp_anestesia(
    p_id_exp_anestesia IN integer,
    p_id_paciente IN integer,
    p_id_tipo_anestesia IN integer,
    p_observacoes IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE EXP_ANESTESIA
    SET ID_PACIENTES = p_id_paciente,
        ID_TIPOS_ANESTESIAS = p_id_tipo_anestesia,
        OBSERVACOES = p_observacoes
    WHERE ID_EXP_ANESTESIA = p_id_exp_anestesia;
END;
$$;


CREATE OR REPLACE PROCEDURE alterar_tipo_medicamento(
    p_id_tipos_medicamentos IN integer,
    p_designacao IN varchar
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE TIPOS_MEDICAMENTOS
    SET DESIGNACAO = p_designacao
    WHERE ID_TIPOS_MEDICAMENTOS = p_id_tipos_medicamentos;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_consentimento_rgpd(
    p_id_documento IN integer,
    p_recolha_tratamento IN boolean,
    p_dados_pessoais_clinicos IN boolean,
    p_publicacao_redes_sociais IN boolean,
    p_armazenamento_historico IN boolean,
    p_fotografias_cientificas IN boolean,
    p_fotografias_internas IN boolean,
    p_todos_consentimentos IN boolean,
    p_data_atualizacao IN timestamp
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE DOCUMENTOS_CONSENTIMENTO_RGPD
    SET RECOLHA_TRATAMENTO = p_recolha_tratamento,
        DADOS_PESSOAIS_CLINICOS = p_dados_pessoais_clinicos,
        PUBLICACAO_REDES_SOCIAIS = p_publicacao_redes_sociais,
        ARMAZENAMENTO_HISTORICO = p_armazenamento_historico,
        FOTOGRAFIAS_CIENTIFICAS = p_fotografias_cientificas,
        FOTOGRAFIAS_INTERNAS = p_fotografias_internas,
        TODOS_CONSENTIMENTOS = p_todos_consentimentos,
        DATA_ATUALIZACAO = p_data_atualizacao
    WHERE ID_DOCUMENTO = p_id_documento;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_alergias_pacientes(
    p_id_paciente_antigo IN integer,
    p_id_alergia_antiga IN integer,
    p_id_paciente_novo IN integer,
    p_id_alergia_nova IN integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE ALERGIAS_PACIENTES
    SET ID_PACIENTES = p_id_paciente_novo,
        ID_ALERGIAS = p_id_alergia_nova
    WHERE ID_PACIENTES = p_id_paciente_antigo 
      AND ID_ALERGIAS = p_id_alergia_antiga;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_condicoes_medicas_pacientes(
    p_id_paciente_antigo IN integer,
    p_id_condicao_antiga IN integer,
    p_id_paciente_novo IN integer,
    p_id_condicao_nova IN integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE CONDICOES_MEDICAS_PACIENTES
    SET ID_PACIENTES = p_id_paciente_novo,
        ID_CONDICOES_MEDICAS = p_id_condicao_nova
    WHERE ID_PACIENTES = p_id_paciente_antigo 
      AND ID_CONDICOES_MEDICAS = p_id_condicao_antiga;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_doencas_dentarias_pacientes(
    p_id_paciente_antigo IN integer,
    p_id_doenca_antiga IN integer,
    p_id_paciente_novo IN integer,
    p_id_doenca_nova IN integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE DOENCAS_DENTARIAS_PACIENTES
    SET ID_PACIENTES = p_id_paciente_novo,
        ID_DOENCAS_DENTARIAS = p_id_doenca_nova
    WHERE ID_PACIENTES = p_id_paciente_antigo 
      AND ID_DOENCAS_DENTARIAS = p_id_doenca_antiga;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_medicamentos_pacientes(
    p_id_paciente_antigo IN integer,
    p_id_medicamento_antigo IN integer,
    p_id_paciente_novo IN integer,
    p_id_medicamento_novo IN integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE MEDICAMENTOS_PACIENTES
    SET ID_PACIENTES = p_id_paciente_novo,
        ID_MEDICAMENTO = p_id_medicamento_novo
    WHERE ID_PACIENTES = p_id_paciente_antigo 
      AND ID_MEDICAMENTO = p_id_medicamento_antigo;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_utilizadores_pacientes(
    p_id_paciente_antigo IN integer,
    p_id_utilizador_antigo IN integer,
    p_id_paciente_novo IN integer,
    p_id_utilizador_novo IN integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE UTILIZADORES_PACIENTES
    SET ID_PACIENTES = p_id_paciente_novo,
        ID_UTILIZADORES = p_id_utilizador_novo
    WHERE ID_PACIENTES = p_id_paciente_antigo 
      AND ID_UTILIZADORES = p_id_utilizador_antigo;
END;
$$;

CREATE OR REPLACE PROCEDURE alterar_notificacoes_utilizadores(
    p_id_utilizador_antigo IN integer,
    p_id_notificacao_antiga IN integer,
    p_id_utilizador_novo IN integer,
    p_id_notificacao_nova IN integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    UPDATE NOTIFICACOES_UTILIZADORES
    SET ID_UTILIZADORES = p_id_utilizador_novo,
        ID_NOTIFICACAO = p_id_notificacao_nova
    WHERE ID_UTILIZADORES = p_id_utilizador_antigo 
      AND ID_NOTIFICACAO = p_id_notificacao_antiga;
END;
$$;
-- ============================================================


-- [SEC-04] PROCEDIMENTOS DE ELIMINAÇÃO (DELETE)
CREATE OR REPLACE PROCEDURE eliminar_acordo_subsistema(
    p_id_acordos_subsistemas integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM ACORDOS_SUBSISTEMAS 
    WHERE ID_ACORDOS_SUBSISTEMAS = p_id_acordos_subsistemas;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_alergia(
    p_id_alergias integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM ALERGIAS 
    WHERE ID_ALERGIAS = p_id_alergias;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_paciente(
    p_id_pacientes integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM PACIENTES 
    WHERE ID_PACIENTES = p_id_pacientes;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_tipo_utilizador(
    p_id_tipos_utilizadores integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM TIPOS_UTILIZADORES 
    WHERE ID_TIPOS_UTILIZADORES = p_id_tipos_utilizadores;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_utilizador(
    p_id_utilizadores integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM UTILIZADORES 
    WHERE ID_UTILIZADORES = p_id_utilizadores;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_medico(
    p_id_medicos integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM MEDICOS 
    WHERE ID_MEDICOS = p_id_medicos;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_gabinete(
    p_id_gabinetes integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM GABINETES 
    WHERE ID_GABINETES = p_id_gabinetes;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_tipo_consulta(
    p_id_tipo_consulta integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM TIPOS_CONSULTA 
    WHERE ID_TIPO_CONSULTA = p_id_tipo_consulta;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_estado_consulta(
    p_id_estados_consultas integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM ESTADOS_CONSULTAS 
    WHERE ID_ESTADOS_CONSULTAS = p_id_estados_consultas;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_tipo_tratamento_consulta(
    p_id_tipo_tratamentos_consultas integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM TIPOS_TRATAMENTOS_CONSULTAS 
    WHERE ID_TIPO_TRATAMENTOS_CONSULTAS = p_id_tipo_tratamentos_consultas;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_tipo_anestesia(
    p_id_tipos_anestesias integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM TIPOS_ANESTESIAS 
    WHERE ID_TIPOS_ANESTESIAS = p_id_tipos_anestesias;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_consulta(
    p_id_consultas integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM CONSULTAS 
    WHERE ID_CONSULTAS = p_id_consultas;
END;
$$;


CREATE OR REPLACE PROCEDURE eliminar_condicoes_medicas(
    p_id_condicoes_medicas integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM CONDICOES_MEDICAS 
    WHERE ID_CONDICOES_MEDICAS = p_id_condicoes_medicas;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_cirurgia_anterior(
    p_id_cirurgias_anteriores integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM CIRURGIAS_ANTERIORES 
    WHERE ID_CIRURGIAS_ANTERIORES = p_id_cirurgias_anteriores;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_doenca_dentaria(
    p_id_doencas_dentarias integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM DOENCAS_DENTARIAS 
    WHERE ID_DOENCAS_DENTARIAS = p_id_doencas_dentarias;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_habito_vida(
    p_id_habitos_vida integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM HABITOS_VIDA 
    WHERE ID_HABITOS_VIDA = p_id_habitos_vida;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_medicamentos(
    p_id_medicamento integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM MEDICAMENTOS 
    WHERE ID_MEDICAMENTO = p_id_medicamento;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_tratamento(
    p_id_tratamentos integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM TRATAMENTOS 
    WHERE ID_TRATAMENTOS = p_id_tratamentos;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_fase_tratamento(
    p_id_fases_de_tratamento integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM FASES_DE_TRATAMENTO 
    WHERE ID_FASES_DE_TRATAMENTO = p_id_fases_de_tratamento;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_tipo_documento(
    p_id_tipos_documentos integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM TIPOS_DOCUMENTOS 
    WHERE ID_TIPOS_DOCUMENTOS = p_id_tipos_documentos;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_documento(
    p_id_documentos integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM DOCUMENTOS 
    WHERE ID_DOCUMENTOS = p_id_documentos;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_notificacao(
    p_id_notificacao integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM NOTIFICACOES 
    WHERE ID_NOTIFICACAO = p_id_notificacao;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_exp_anestesia(
    p_id_exp_anestesia integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM EXP_ANESTESIA 
    WHERE ID_EXP_ANESTESIA = p_id_exp_anestesia;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_tipo_medicamento(
    p_id_tipos_medicamentos integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM TIPOS_MEDICAMENTOS 
    WHERE ID_TIPOS_MEDICAMENTOS = p_id_tipos_medicamentos;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_consentimento_rgpd(
    p_id_documento integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM DOCUMENTOS_CONSENTIMENTO_RGPD 
    WHERE ID_DOCUMENTO = p_id_documento;
END;
$$;

CREATE OR REPLACE PROCEDURE desassociar_alergia_paciente(
    p_id_paciente integer,
    p_id_alergia integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM ALERGIAS_PACIENTES 
    WHERE ID_PACIENTES = p_id_paciente 
      AND ID_ALERGIAS = p_id_alergia;
END;
$$;

CREATE OR REPLACE PROCEDURE desassociar_condicao_paciente(
    p_id_paciente integer,
    p_id_condicao integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM CONDICOES_MEDICAS_PACIENTES 
    WHERE ID_PACIENTES = p_id_paciente 
      AND ID_CONDICOES_MEDICAS = p_id_condicao;
END;
$$;

CREATE OR REPLACE PROCEDURE desassociar_doenca_dentaria_paciente(
    p_id_paciente integer,
    p_id_doenca integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM DOENCAS_DENTARIAS_PACIENTES 
    WHERE ID_PACIENTES = p_id_paciente 
      AND ID_DOENCAS_DENTARIAS = p_id_doenca;
END;
$$;

CREATE OR REPLACE PROCEDURE desassociar_medicamento_paciente(
    p_id_paciente integer,
    p_id_medicamento integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM MEDICAMENTOS_PACIENTES 
    WHERE ID_PACIENTES = p_id_paciente 
      AND ID_MEDICAMENTO = p_id_medicamento;
END;
$$;

CREATE OR REPLACE PROCEDURE desassociar_utilizador_paciente(
    p_id_paciente integer,
    p_id_utilizador integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM UTILIZADORES_PACIENTES 
    WHERE ID_PACIENTES = p_id_paciente 
      AND ID_UTILIZADORES = p_id_utilizador;
END;
$$;

CREATE OR REPLACE PROCEDURE desassociar_notificacao_utilizador(
    p_id_utilizador integer,
    p_id_notificacao integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    DELETE FROM NOTIFICACOES_UTILIZADORES 
    WHERE ID_UTILIZADORES = p_id_utilizador 
      AND ID_NOTIFICACAO = p_id_notificacao;
END;
$$;
-- ============================================================


-- [SEC-05] TRIGGERS E FUNÇÕES DE TRIGGER
CREATE TABLE CONSULTAS_AUDIT(
    operation               char(1)     NOT NULL,
    stamp                   timestamp   NOT NULL,
    userid                  text        NOT NULL,
    --todos os addos
    ID_CONSULTAS            integer     NOT NULL,
    ID_GABINETES            integer,
    ID_TRATAMENTOS          integer,
    ID_MEDICOS              integer,
    ID_TIPOS_ANESTESIAS     integer,
    ID_ESTADOS_CONSULTAS    integer,
    ID_TIPO_TRATAMENTOS_CONSULTAS integer,
    ID_PACIENTES            integer,
    ID_TIPO_CONSULTA        integer,
    DATAFASE                date,
    HORA                    time,
    DURACAOPREVISTA         integer
);


CREATE OR REPLACE FUNCTION process_consultas_audit() RETURNS TRIGGER AS $consultas_audit$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO CONSULTAS_AUDIT SELECT 'D', now(), user, OLD.*;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO CONSULTAS_AUDIT SELECT 'U', now(), user, NEW.*;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO CONSULTAS_AUDIT SELECT 'I', now(), user, NEW.*;
    END IF;
    RETURN NULL;
END;
$consultas_audit$ LANGUAGE plpgsql;

CREATE TRIGGER consultas_audit
    AFTER INSERT OR UPDATE OR DELETE ON CONSULTAS
    FOR EACH ROW 
    EXECUTE FUNCTION process_consultas_audit();






CREATE OR REPLACE FUNCTION validar_documento() RETURNS trigger AS $validar_documento$
BEGIN
    IF NEW.NOME IS NULL THEN
        RAISE EXCEPTION 'Tem de especificar o nome do documento';
    END IF;
    IF NEW.TAMANHO_BYTES <= 0 THEN
        RAISE EXCEPTION 'O tamanho do documento tem de ser positivo';
    END IF;
    RETURN NEW;
END;
$validar_documento$ LANGUAGE plpgsql;

CREATE TRIGGER validar_documento BEFORE INSERT OR UPDATE ON DOCUMENTOS
    FOR EACH ROW 
    EXECUTE FUNCTION validar_documento();





CREATE TABLE PACIENTES_AUDIT(
    operation           char(1)     NOT NULL,
    stamp               timestamp   NOT NULL,
    userid              text        NOT NULL,
    --todos os dados
    ID_PACIENTES        integer     NOT NULL,
    ID_TITULAR_PACIENTE integer,
    ID_ACORDOS_SUBSISTEMAS integer,
    NOME                varchar(120),
    NIF                 varchar(15),
    DATADENASCIMENTO    date,
    GENERO              varchar(20),
    NUMERODEUTENTE      varchar(30),
    ESTADOCIVIL         varchar(20),
    PROFISSAO           varchar(100),
    CONTACTOPESSOAL     varchar(15),
    CONTACTOSECUNDARIO  varchar(15),
    MORADA              varchar(200),
    CODIGOPOSTAL        varchar(20),
    LOCALIDADE          varchar(100),
    DEPENDENTEPORIDADE  integer
);


CREATE OR REPLACE FUNCTION process_pacientes_audit() RETURNS TRIGGER AS $pacientes_audit$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO PACIENTES_AUDIT SELECT 'D', now(), user, OLD.*;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO PACIENTES_AUDIT SELECT 'U', now(), user, NEW.*;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO PACIENTES_AUDIT SELECT 'I', now(), user, NEW.*;
    END IF;
    RETURN NULL;
END;
$pacientes_audit$ LANGUAGE plpgsql;

CREATE TRIGGER pacientes_audit
    AFTER INSERT OR UPDATE OR DELETE ON PACIENTES
    FOR EACH ROW 
    EXECUTE FUNCTION process_pacientes_audit();
-- ============================================================



-- [SEC-06] POPULAÇÃO DA BASE DE DADOS (call dos procedures)

-- ACORDOS_SUBSISTEMAS
CALL inserir_acordo_subsistema('ADSE');
CALL inserir_acordo_subsistema('Medicare');
CALL inserir_acordo_subsistema('Multicare');


-- ALERGIAS
CALL inserir_alergia('Penicilina', 'Reação alérgica grave a antibióticos do grupo das penicilinas');
CALL inserir_alergia('Látex', 'Alergia ao látex presente em luvas médicas');
CALL inserir_alergia('Anestésicos Locais', 'Sensibilidade a lidocaína e derivados');


-- TIPOS_UTILIZADORES
CALL inserir_tipo_utilizador('Gestor');
CALL inserir_tipo_utilizador('Paciente');
CALL inserir_tipo_utilizador('Médico');


-- UTILIZADORES
CALL inserir_utilizador(1, 'admin@clinica.pt', 'admin123', 'admin@clinica.pt', true);
CALL inserir_utilizador(2, 'antonio.ferreira@email.pt', 'paciente123', 'antonio.ferreira@email.pt', true);
CALL inserir_utilizador(3, 'diogocalcadaa@email.pt', 'calcada123', 'diogocalcadaa@email.pt', true);


-- MEDICOS
CALL inserir_medico(3, 'Dr. Diogo Calcada', 'Implantologia');



-- GABINETES
CALL inserir_gabinete('Gabinete 1');
CALL inserir_gabinete('Gabinete 2');
CALL inserir_gabinete('Sala de Cirurgia');


-- TIPOS_CONSULTA
CALL inserir_tipo_consulta('Consulta de Rotina');
CALL inserir_tipo_consulta('Consulta de Urgência');
CALL inserir_tipo_consulta('Consulta de Acompanhamento');


-- ESTADOS_CONSULTAS
CALL inserir_estado_consulta('Agendada');
CALL inserir_estado_consulta('Concluída');
CALL inserir_estado_consulta('Cancelada');


-- TIPOS_TRATAMENTOS_CONSULTAS
CALL inserir_tipo_tratamento_consulta('Limpeza Dentária');
CALL inserir_tipo_tratamento_consulta('Extração');
CALL inserir_tipo_tratamento_consulta('Restauração');


-- TIPOS_ANESTESIAS
CALL inserir_tipo_anestesia('Anestesia Local');
CALL inserir_tipo_anestesia('Sedação Consciente');
CALL inserir_tipo_anestesia('Anestesia Geral');


-- TIPOS_MEDICAMENTOS
CALL inserir_tipo_medicamento('Doenças Gerais');
CALL inserir_tipo_medicamento('Doenças Dentárias');



-- CONDICOES_MEDICAS
CALL inserir_condicoes_medicas('Diabetes Tipo 2', 'Paciente com diabetes controlada com medicação oral', true);
CALL inserir_condicoes_medicas('Hipertensão Arterial', 'Pressão arterial elevada requer monitorização', true);
CALL inserir_condicoes_medicas('Asma', 'Asma brônquica com crises ocasionais', true);


-- DOENCAS_DENTARIAS
CALL inserir_doenca_dentaria('Cárie Dentária', 'Destruição progressiva do esmalte dentário causada por bactérias');
CALL inserir_doenca_dentaria('Periodontite', 'Inflamação grave das gengivas que afeta o osso de suporte dos dentes');
CALL inserir_doenca_dentaria('Gengivite', 'Inflamação das gengivas com sangramento e vermelhidão');


-- MEDICAMENTOS
CALL inserir_medicamentos(1, 'Paracetamol 1g', 'Tomar de 8 em 8 horas se dor');
CALL inserir_medicamentos(2, 'Amoxicilina 500mg', 'Antibiótico de largo espetro');
CALL inserir_medicamentos(1, 'Ibuprofeno 400mg', 'Anti-inflamatório não esteroide');


-- TIPOS_DOCUMENTOS
CALL inserir_tipo_documento('Consentimento RGPD', 'pdf');
CALL inserir_tipo_documento('Declaração de Presença', 'pdf');
CALL inserir_tipo_documento('Fotografia Clínica', 'jpg');



-- NOTIFICACOES
CALL inserir_notificacao('A sua consulta está agendada para amanhã às 10:00');
CALL inserir_notificacao('Lembrete: Consulta de acompanhamento em 7 dias');
CALL inserir_notificacao('O seu tratamento foi concluído com sucesso');


-- PACIENTES
CALL inserir_paciente(
    NULL,                           -- p_id_titular_paciente
    1,                              -- p_id_acordos_subsistemas
    'António Manuel Ferreira',      -- p_nome
    '123456789',                    -- p_nif
    '1985-03-15',                   -- p_data_nascimento
    'Masculino',                    -- p_genero
    '123456789012',                 -- p_numero_utente
    'Casado',                       -- p_estado_civil
    'Engenheiro',                   -- p_profissao
    '912345678',                    -- p_contacto_pessoal
    '213456789',                    -- p_contacto_secundario
    'Rua das Flores, 123',          -- p_morada
    '1000-001',                     -- p_codigo_postal
    'Lisboa',                       -- p_localidade
    0                               -- p_dependente_por_idade
);

CALL inserir_paciente(
    NULL,                           -- p_id_titular_paciente
    2,                              -- p_id_acordos_subsistemas
    'Maria José Oliveira',          -- p_nome
    '987654321',                    -- p_nif
    '1990-07-22',                   -- p_data_nascimento
    'Feminino',                     -- p_genero
    '987654321098',                 -- p_numero_utente
    'Solteira',                     -- p_estado_civil
    'Professora',                   -- p_profissao
    '936789012',                    -- p_contacto_pessoal
    '226789012',                    -- p_contacto_secundario
    'Av. da Liberdade, 456',        -- p_morada
    '4000-002',                     -- p_codigo_postal
    'Porto',                        -- p_localidade
    0                               -- p_dependente_por_idade
);

CALL inserir_paciente(
    1,                              -- p_id_titular_paciente (dependente do paciente 1)
    1,                              -- p_id_acordos_subsistemas
    'João Pedro Ferreira',          -- p_nome
    NULL,                           -- p_nif (menor sem NIF)
    '2015-11-10',                   -- p_data_nascimento
    'Masculino',                    -- p_genero
    '111222333444',                 -- p_numero_utente
    'Solteiro',                     -- p_estado_civil
    'Estudante',                    -- p_profissao
    '912345678',                    -- p_contacto_pessoal
    '213456789',                    -- p_contacto_secundario
    'Rua das Flores, 123',          -- p_morada
    '1000-001',                     -- p_codigo_postal
    'Lisboa',                       -- p_localidade
    1                               -- p_dependente_por_idade
);


-- TRATAMENTOS
CALL inserir_tratamento(
    1,                                      -- p_id_paciente
    'Tratamento Ortodôntico',               -- p_nome
    true,                                   -- p_estado
    12,                                     -- p_numero_fases
    '2025-01-15',                           -- p_data_inicio
    '2026-01-15',                           -- p_data_final
    'Colocação de aparelho fixo para correção de mordida',  -- p_descricao
    'Uso de contenção durante 6 meses',     -- p_pos_tratamento
    1,                                      -- p_num_consultas_fase
    60                                      -- p_duracao_prevista
);

CALL inserir_tratamento(
    2,                                      -- p_id_paciente
    'Implante Dentário',                    -- p_nome
    true,                                   -- p_estado
    3,                                      -- p_numero_fases
    '2025-02-01',                           -- p_data_inicio
    '2025-06-01',                           -- p_data_final
    'Colocação de implante no dente 36',    -- p_descricao
    'Evitar alimentos duros durante 2 semanas',  -- p_pos_tratamento
    2,                                      -- p_num_consultas_fase
    90                                      -- p_duracao_prevista
);

CALL inserir_tratamento(
    3,                                      -- p_id_paciente
    'Tratamento de Cáries',                 -- p_nome
    true,                                   -- p_estado
    2,                                      -- p_numero_fases
    '2025-01-20',                           -- p_data_inicio
    '2025-02-20',                           -- p_data_final
    'Restauração de múltiplas cáries',      -- p_descricao
    'Escovagem 3x ao dia',                  -- p_pos_tratamento
    1,                                      -- p_num_consultas_fase
    45                                      -- p_duracao_prevista
);


-- FASES_DE_TRATAMENTO
CALL inserir_fase_tratamento(
    1,                              -- p_id_tratamento
    1,                              -- p_id_medico
    'Colocação de brackets',        -- p_nome
    '2025-01-15',                   -- p_data_fase
    true,                           -- p_estado
    'Fase inicial do tratamento',   -- p_observacoes
    true,                           -- p_anestesia
    1                               -- p_numero_fase
);

CALL inserir_fase_tratamento(
    2,                              -- p_id_tratamento
    1,                              -- p_id_medico
    'Cirurgia de Implante',         -- p_nome
    '2025-02-01',                   -- p_data_fase
    true,                           -- p_estado
    'Colocação do pino de titânio', -- p_observacoes
    true,                           -- p_anestesia
    1                               -- p_numero_fase
);

CALL inserir_fase_tratamento(
    3,                              -- p_id_tratamento
    1,                              -- p_id_medico
    'Restauração Quadrante 1',      -- p_nome
    '2025-01-20',                   -- p_data_fase
    true,                           -- p_estado
    'Restauração de 2 dentes',      -- p_observacoes
    true,                           -- p_anestesia
    1                               -- p_numero_fase
);


-- CONSULTAS
CALL inserir_consulta(
    1,                  -- p_id_gabinete
    1,                  -- p_id_tratamento
    1,                  -- p_id_medico
    1,                  -- p_id_tipo_anestesia
    1,                  -- p_id_estado_consulta
    1,                  -- p_id_tipo_tratamento_consulta
    1,                  -- p_id_paciente
    1,                  -- p_id_tipo_consulta
    '2025-01-20',       -- p_datafase
    '09:00:00',         -- p_hora
    60                  -- p_duracaoprevista
);

CALL inserir_consulta(
    2,                  -- p_id_gabinete
    2,                  -- p_id_tratamento
    1,                  -- p_id_medico
    2,                  -- p_id_tipo_anestesia
    1,                  -- p_id_estado_consulta
    2,                  -- p_id_tipo_tratamento_consulta
    2,                  -- p_id_paciente
    1,                  -- p_id_tipo_consulta
    '2025-01-21',       -- p_datafase
    '10:30:00',         -- p_hora
    90                  -- p_duracaoprevista
);

CALL inserir_consulta(
    1,                  -- p_id_gabinete
    3,                  -- p_id_tratamento
    1,                  -- p_id_medico
    1,                  -- p_id_tipo_anestesia
    1,                  -- p_id_estado_consulta
    3,                  -- p_id_tipo_tratamento_consulta
    3,                  -- p_id_paciente
    3,                  -- p_id_tipo_consulta
    '2025-01-22',       -- p_datafase
    '14:00:00',         -- p_hora
    45                  -- p_duracaoprevista
);


-- CIRURGIAS_ANTERIORES
CALL inserir_cirurgia_anterior(
    1,                                  -- p_id_paciente
    'Apendicectomia',                   -- p_nome
    '2010-05-20',                       -- p_data
    'Hospital de Santa Maria',          -- p_hospital
    'Cirurgia realizada sem complicações'  -- p_observacoes
);

CALL inserir_cirurgia_anterior(
    2,                                  -- p_id_paciente
    'Extração de Siso',                 -- p_nome
    '2018-08-15',                       -- p_data
    'Clínica Dentária Sorrisos',        -- p_hospital
    'Extração dos 4 sisos inclusos'     -- p_observacoes
);

CALL inserir_cirurgia_anterior(
    1,                                  -- p_id_paciente
    'Rinoplastia',                      -- p_nome
    '2015-03-10',                       -- p_data
    'Hospital da Luz',                  -- p_hospital
    'Correção de desvio do septo'       -- p_observacoes
);


-- HABITOS_VIDA
CALL inserir_habito_vida(1, 'Fumador', 'Fuma cerca de 10 cigarros por dia há 15 anos');
CALL inserir_habito_vida(2, 'Consumo de Álcool', 'Consumo moderado ao fim de semana');
CALL inserir_habito_vida(1, 'Bruxismo', 'Range os dentes durante o sono');


-- DOCUMENTOS
CALL inserir_documento(
    1,                                      -- p_id_tipo_documento
    1,                                      -- p_id_paciente
    1,                                      -- p_id_medico
    'RaioX_Panoramico_2025.jpg',           -- p_nome
    '/documentos/paciente1/raiox_2025.jpg', -- p_caminho_ficheiro
    2048576,                                -- p_tamanho_bytes
    '2025-01-15 10:30:00',                  -- p_data_upload
    '2025-01-15 10:00:00',                  -- p_data_geracao
    true,                                   -- p_ativo
    'Raio-X panorâmico inicial'             -- p_observacoes
);

CALL inserir_documento(
    2,                                      -- p_id_tipo_documento
    2,                                      -- p_id_paciente
    1,                                      -- p_id_medico
    'Relatorio_Implante.pdf',               -- p_nome
    '/documentos/paciente2/relatorio.pdf',  -- p_caminho_ficheiro
    512000,                                 -- p_tamanho_bytes
    '2025-02-01 14:00:00',                  -- p_data_upload
    '2025-02-01 13:30:00',                  -- p_data_geracao
    true,                                   -- p_ativo
    'Relatório pré-operatório'              -- p_observacoes
);

CALL inserir_documento(
    3,                                      -- p_id_tipo_documento
    3,                                      -- p_id_paciente
    1,                                      -- p_id_medico
    'Consentimento_Tratamento.pdf',         -- p_nome
    '/documentos/paciente3/consent.pdf',    -- p_caminho_ficheiro
    256000,                                 -- p_tamanho_bytes
    '2025-01-20 08:00:00',                  -- p_data_upload
    '2025-01-20 07:45:00',                  -- p_data_geracao
    true,                                   -- p_ativo
    'Consentimento assinado pelo responsável' -- p_observacoes
);


-- EXP_ANESTESIA
CALL inserir_exp_anestesia(1, 1, 'Boa tolerância a anestesia local com lidocaína');
CALL inserir_exp_anestesia(2, 2, 'Experiência com sedação consciente sem intercorrências');
CALL inserir_exp_anestesia(1, 3, 'Anestesia geral realizada em cirurgia anterior');


-- ALERGIAS_PACIENTES (associação)
CALL associar_alergia_paciente(1, 1);
CALL associar_alergia_paciente(2, 2);
CALL associar_alergia_paciente(1, 2);


-- CONDICOES_MEDICAS_PACIENTES (associação)
CALL associar_condicao_paciente(1, 1);
CALL associar_condicao_paciente(2, 2);
CALL associar_condicao_paciente(1, 3);


-- DOENCAS_DENTARIAS_PACIENTES (associação)
CALL associar_doenca_dentaria_paciente(1, 1);
CALL associar_doenca_dentaria_paciente(2, 2);
CALL associar_doenca_dentaria_paciente(3, 1);


-- MEDICAMENTOS_PACIENTES (associação)
CALL associar_medicamento_paciente(1, 1);
CALL associar_medicamento_paciente(2, 2);
CALL associar_medicamento_paciente(1, 2);


-- UTILIZADORES_PACIENTES (associação)
CALL associar_utilizador_paciente(1, 2);
CALL associar_utilizador_paciente(2, 3);
CALL associar_utilizador_paciente(3, 2);


-- NOTIFICACOES_UTILIZADORES (associação)
CALL associar_notificacao_utilizador(2, 1);
CALL associar_notificacao_utilizador(3, 2);
CALL associar_notificacao_utilizador(2, 3);


-- DOCUMENTOS_CONSENTIMENTO_RGPD
CALL inserir_consentimento_rgpd(
    1,                          -- p_id_documento
    true,                       -- p_recolha_tratamento
    true,                       -- p_dados_pessoais_clinicos
    false,                      -- p_publicacao_redes_sociais
    true,                       -- p_armazenamento_historico
    false,                      -- p_fotografias_cientificas
    true,                       -- p_fotografias_internas
    false,                      -- p_todos_consentimentos
    '2025-01-15 10:30:00'       -- p_data_atualizacao
);

CALL inserir_consentimento_rgpd(
    2,                          -- p_id_documento
    true,                       -- p_recolha_tratamento
    true,                       -- p_dados_pessoais_clinicos
    true,                       -- p_publicacao_redes_sociais
    true,                       -- p_armazenamento_historico
    true,                       -- p_fotografias_cientificas
    true,                       -- p_fotografias_internas
    true,                       -- p_todos_consentimentos
    '2025-02-01 14:00:00'       -- p_data_atualizacao
);

CALL inserir_consentimento_rgpd(
    3,                          -- p_id_documento
    true,                       -- p_recolha_tratamento
    true,                       -- p_dados_pessoais_clinicos
    false,                      -- p_publicacao_redes_sociais
    true,                       -- p_armazenamento_historico
    false,                      -- p_fotografias_cientificas
    false,                      -- p_fotografias_internas
    false,                      -- p_todos_consentimentos
    '2025-01-20 08:00:00'       -- p_data_atualizacao
);
-- ============================================================



-- [SEC-07] VIEWS
 CREATE OR REPLACE VIEW vista_medicamentos AS
  SELECT id_medicamento, nome, observacoes
  FROM medicamentos;

  CREATE OR REPLACE VIEW vista_condicoes_medicas AS
  SELECT id_condicoes_medicas, nome, observacoes, estado
  FROM condicoes_medicas;

--SUBINDEXAÇÃO DAS SECÇÕES DAS VIEWS

-- SECÇÃO 1: VIEWS DE TABELAS PRINCIPAIS
-- SECÇÃO 2: VIEWS DE TABELAS DE ASSOCIAÇÃO (N:M)
-- SECÇÃO 3: VIEWS PARA ANÁLISE E RELATÓRIOS
-- SECÇÃO 4: VIEWS NOVAS (tabelas que não tinham view)



-- SECÇÃO 1: VIEWS DE TABELAS PRINCIPAIS
-- View de medicamentos
-- View de pacientes 
CREATE OR REPLACE VIEW vista_pacientes AS
SELECT
    p.ID_PACIENTES,
    p.ID_TITULAR_PACIENTE,
    p.ID_ACORDOS_SUBSISTEMAS,
    p.NOME,
    p.NIF,
    p.DATADENASCIMENTO,
    p.GENERO,
    p.NUMERODEUTENTE,
    p.ESTADOCIVIL,
    p.PROFISSAO,
    p.CONTACTOPESSOAL,
    p.CONTACTOSECUNDARIO,
    p.MORADA,
    p.CODIGOPOSTAL,
    p.LOCALIDADE,
    p.DEPENDENTEPORIDADE
FROM PACIENTES p;

-- View de utilizadores
CREATE OR REPLACE VIEW vista_utilizadores AS
SELECT
    u.ID_UTILIZADORES,
    u.ID_TIPOS_UTILIZADORES,
    u.USERNAME,
    u.ESTADO,
    tu.DESIGNACAO AS TIPO_UTILIZADOR
FROM UTILIZADORES u
LEFT JOIN TIPOS_UTILIZADORES tu ON u.ID_TIPOS_UTILIZADORES = tu.ID_TIPOS_UTILIZADORES;
--Para cada utilizador, vai à tabela TIPOS_UTILIZADORES e procura o tipo que tem o mesmo ID. 
--Se encontrar, traz a designação do tipo (ex: 'Administrador', 'Médico', 'Rececionista'). 
--Se não encontrar, deixa NULL mas mostra na mesma o utilizador.


-- View de médicos com informação de contacto
CREATE OR REPLACE VIEW vista_medicos AS
SELECT
    m.ID_MEDICOS,
    m.ID_UTILIZADORES,
    m.NOME AS NOME_MEDICO,
    m.ESPECIALIDADE,
    u.USERNAME,
    u.ESTADO
FROM MEDICOS m
INNER JOIN UTILIZADORES u ON m.ID_UTILIZADORES = u.ID_UTILIZADORES;
--Para cada médico, vai à tabela UTILIZADORES e procura o utilizador que tem o mesmo ID. 
--Apenas mostra médicos que TÊM utilizador associado. 
--Se um médico não tiver utilizador (o que não devia acontecer), esse médico não aparece na view.


-- View de consultas
CREATE OR REPLACE VIEW vista_consultas AS
SELECT
    c.ID_CONSULTAS,
    c.ID_TIPO_CONSULTA,
    c.ID_GABINETES,
    c.ID_TRATAMENTOS,
    c.ID_MEDICOS,
    c.ID_TIPOS_ANESTESIAS,
    c.ID_ESTADOS_CONSULTAS,
    c.ID_TIPO_TRATAMENTOS_CONSULTAS,
    c.ID_PACIENTES,
    c.DATAFASE,
    c.HORA,
    p.NOME AS NOME_PACIENTE,
    m.NOME AS NOME_MEDICO,
    tc.DESIGNACAO AS TIPO_CONSULTA,
    ec.DESIGNACAO AS ESTADO_CONSULTA,
    g.DESIGNACAO AS GABINETE,
    t.NOME AS TRATAMENTO,
    ta.DESIGNACAO AS TIPO_ANESTESIA,
    ttc.DESIGNACAO AS TIPO_TRATAMENTO_CONSULTA
FROM CONSULTAS c
LEFT JOIN PACIENTES p ON c.ID_PACIENTES = p.ID_PACIENTES --Para cada consulta, vai à tabela PACIENTES e procura o paciente que tem o mesmo ID. Se encontrar, traz o nome do paciente. Se não encontrar, deixa NULL mas mostra na mesma a consulta.
LEFT JOIN MEDICOS m ON c.ID_MEDICOS = m.ID_MEDICOS --Para cada consulta, vai à tabela MEDICOS e procura o médico que tem o mesmo ID. Se encontrar, traz o nome do médico. Se não encontrar, deixa NULL mas mostra na mesma a consulta.
LEFT JOIN TIPOS_CONSULTA tc ON c.ID_TIPO_CONSULTA = tc.ID_TIPO_CONSULTA --Para cada consulta, vai à tabela TIPOS_CONSULTA e procura o tipo que tem o mesmo ID. Se encontrar, traz a designação do tipo (ex: 'Consulta de Rotina', 'Urgência'). Se não encontrar, deixa NULL mas mostra na mesma a consulta.
LEFT JOIN ESTADOS_CONSULTAS ec ON c.ID_ESTADOS_CONSULTAS = ec.ID_ESTADOS_CONSULTAS --Para cada consulta, vai à tabela ESTADOS_CONSULTAS e procura o estado que tem o mesmo ID. Se encontrar, traz a designação do estado (ex: 'Agendada', 'Concluída', 'Cancelada'). Se não encontrar, deixa NULL mas mostra na mesma a consulta.
LEFT JOIN GABINETES g ON c.ID_GABINETES = g.ID_GABINETES --Para cada consulta, vai à tabela GABINETES e procura o gabinete que tem o mesmo ID. Se encontrar, traz a designação do gabinete (ex: 'Gabinete 1', 'Sala de Cirurgia'). Se não encontrar, deixa NULL mas mostra na mesma a consulta.
LEFT JOIN TRATAMENTOS t ON c.ID_TRATAMENTOS = t.ID_TRATAMENTOS --Para cada consulta, vai à tabela TRATAMENTOS e procura o tratamento que tem o mesmo ID. Se encontrar, traz o nome do tratamento (ex: 'Implante Dentário', 'Branqueamento'). Se não encontrar (consulta não está ligada a tratamento), deixa NULL mas mostra na mesma a consulta.
LEFT JOIN TIPOS_ANESTESIAS ta ON c.ID_TIPOS_ANESTESIAS = ta.ID_TIPOS_ANESTESIAS --Para cada consulta, vai à tabela TIPOS_ANESTESIAS e procura o tipo de anestesia que tem o mesmo ID. Se encontrar, traz a designação (ex: 'Local', 'Geral', 'Sedação'). Se não encontrar (consulta sem anestesia), deixa NULL mas mostra na mesma a consulta.
LEFT JOIN TIPOS_TRATAMENTOS_CONSULTAS ttc ON c.ID_TIPO_TRATAMENTOS_CONSULTAS = ttc.ID_TIPO_TRATAMENTOS_CONSULTAS; --Para cada consulta, vai à tabela TIPOS_TRATAMENTOS_CONSULTAS e procura o tipo de tratamento da consulta que tem o mesmo ID. Se encontrar, traz a designação. Se não encontrar, deixa NULL mas mostra na mesma a consulta
--Mostra TODAS as consultas existentes. Para cada consulta, tenta buscar informação adicional em 8 tabelas diferentes 
--(paciente, médico, tipo, estado, gabinete, tratamento, anestesia, tipo de tratamento). 
--Se alguma dessas informações não existir ou não estiver preenchida, mostra NULL nessa coluna específica, 
--mas nunca esconde a consulta.



-- View de tratamentos
CREATE OR REPLACE VIEW vista_tratamentos AS
SELECT
    t.ID_TRATAMENTOS,
    t.ID_PACIENTES,
    t.NOME,
    t.ESTADO,
    t.NUMERODEFASES,
    t.DATAFINAL,
    t.DATAINICIO,
    t.DESCRICAO,
    t.POSTRATAMENTO,
    t.NUMEROCONSULTASPORFASE,
    t.DURACAOPREVISTA,
    p.NOME AS NOME_PACIENTE
FROM TRATAMENTOS t
LEFT JOIN PACIENTES p ON t.ID_PACIENTES = p.ID_PACIENTES;
--Para cada tratamento, vai à tabela PACIENTES e procura o paciente que tem o mesmo ID. 
--Se encontrar, traz o nome do paciente. 
--Se não encontrar (tratamento sem paciente associado, o que seria estranho mas possível), deixa NULL mas mostra na mesma o tratamento.

-- Acordos e subsistemas de saúde
CREATE OR REPLACE VIEW vista_acordos_subsistemas AS
SELECT
    a.ID_ACORDOS_SUBSISTEMAS,
    a.NOME
FROM ACORDOS_SUBSISTEMAS a;

-- Vista de alergias
CREATE OR REPLACE VIEW vista_alergias AS
SELECT
    a.ID_ALERGIAS,
    a.NOME,
    a.OBSERVACOES
FROM ALERGIAS a;

-- Histórico de cirurgias anteriores
CREATE OR REPLACE VIEW vista_cirurgias_anteriores AS
SELECT
    ca.ID_CIRURGIAS_ANTERIORES,
    ca.ID_PACIENTES,
    ca.NOME,
    ca.DATAFASE,
    ca.HOSPITAL,
    ca.OBSERVACOES,
    p.NOME AS NOME_PACIENTE
FROM CIRURGIAS_ANTERIORES ca
LEFT JOIN PACIENTES p ON ca.ID_PACIENTES = p.ID_PACIENTES;
--Para cada cirurgia anterior, vai à tabela PACIENTES e procura o paciente que tem o mesmo ID. 
--Se encontrar, traz o nome do paciente. 
--Se não encontrar (cirurgia registada sem paciente associado), deixa NULL mas mostra na mesma a cirurgia.


-- Doenças dentárias
CREATE OR REPLACE VIEW vista_doencas_dentarias AS
SELECT
    dd.ID_DOENCAS_DENTARIAS,
    dd.NOME,
    dd.DESCRICAO
FROM DOENCAS_DENTARIAS dd;

-- Gabinetes da clínica
CREATE OR REPLACE VIEW vista_gabinetes AS
SELECT
    g.ID_GABINETES,
    g.DESIGNACAO
FROM GABINETES g;

-- Vista de hábitos de vida dos pacientes
CREATE OR REPLACE VIEW vista_habitos_vida AS
SELECT
    hv.ID_HABITOS_VIDA,
    hv.ID_PACIENTES,
    hv.DESIGNACAO,
    hv.OBSERVACOES,
    p.NOME AS NOME_PACIENTE
FROM HABITOS_VIDA hv
LEFT JOIN PACIENTES p ON hv.ID_PACIENTES = p.ID_PACIENTES;
--Para cada hábito de vida, vai à tabela PACIENTES e procura o paciente que tem o mesmo ID. 
--Se encontrar, traz o nome do paciente. 
--Se não encontrar (hábito registado sem paciente associado), deixa NULL mas mostra na mesma o hábito.

-- Tipos de consultas disponíveis 
CREATE OR REPLACE VIEW vista_tipos_consulta AS
SELECT
    tc.ID_TIPO_CONSULTA,
    tc.DESIGNACAO
FROM TIPOS_CONSULTA tc;

-- Estados das consultas
CREATE OR REPLACE VIEW vista_estados_consultas AS
SELECT
    ec.ID_ESTADOS_CONSULTAS,
    ec.DESIGNACAO
FROM ESTADOS_CONSULTAS ec;

-- Tipos de anestesia
CREATE OR REPLACE VIEW vista_tipos_anestesias AS
SELECT
    ta.ID_TIPOS_ANESTESIAS,
    ta.DESIGNACAO
FROM TIPOS_ANESTESIAS ta;

-- Tipos de documentos
CREATE OR REPLACE VIEW vista_tipos_documentos AS
SELECT
    td.ID_TIPOS_DOCUMENTOS,
    td.DESIGNACAO,
    td.EXTENCAO
FROM TIPOS_DOCUMENTOS td;

-- Vista de documentos
CREATE OR REPLACE VIEW vista_documentos AS
SELECT
    d.ID_DOCUMENTOS,
    d.ID_TIPOS_DOCUMENTOS,
    d.ID_PACIENTES,
    d.ID_MEDICOS,
    d.NOME,
    d.CAMINHO_FICHEIRO,
    d.TAMANHO_BYTES,
    d.DATA_UPLOAD,
    d.DATA_GERACAO,
    d.ATIVO,
    d.OBSERVACOES,
    td.DESIGNACAO AS TIPO_DOCUMENTO,
    p.NOME AS NOME_PACIENTE,
    m.NOME AS NOME_MEDICO
FROM DOCUMENTOS d
LEFT JOIN TIPOS_DOCUMENTOS td ON d.ID_TIPOS_DOCUMENTOS = td.ID_TIPOS_DOCUMENTOS --Para cada documento, vai à tabela TIPOS_DOCUMENTOS e procura o tipo que tem o mesmo ID. Se encontrar, traz a designação do tipo (ex: 'Raio-X', 'Receita', 'Orçamento', 'PDF'). Se não encontrar, deixa NULL mas mostra na mesma o documento.
LEFT JOIN PACIENTES p ON d.ID_PACIENTES = p.ID_PACIENTES --Para cada documento, vai à tabela PACIENTES e procura o paciente que tem o mesmo ID. Se encontrar, traz o nome do paciente. Se não encontrar (documento não é de um paciente específico), deixa NULL mas mostra na mesma o documento.
LEFT JOIN MEDICOS m ON d.ID_MEDICOS = m.ID_MEDICOS; --Para cada documento, vai à tabela MEDICOS e procura o médico que tem o mesmo ID. Se encontrar, traz o nome do médico que gerou/enviou o documento. Se não encontrar (documento não foi criado por um médico específico), deixa NULL mas mostra na mesma o documento.

-- Notificações do sistema
CREATE OR REPLACE VIEW vista_notificacoes AS
SELECT
    n.ID_NOTIFICACAO,
    n.DESCRICAO
FROM NOTIFICACOES n;

-- Fases de tratamento
CREATE OR REPLACE VIEW vista_fases_de_tratamento AS
SELECT
    ft.ID_FASES_DE_TRATAMENTO,
    ft.ID_TRATAMENTOS,
    ft.ID_MEDICOS,
    ft.NOME,
    ft.DATAFASE,
    ft.ESTADO,
    ft.OBSERVACOES,
    ft.ANESTESIA,
    ft.NUMEROFASE,
    t.NOME AS NOME_TRATAMENTO,
    m.NOME AS NOME_MEDICO
FROM FASES_DE_TRATAMENTO ft
LEFT JOIN TRATAMENTOS t ON ft.ID_TRATAMENTOS = t.ID_TRATAMENTOS 
LEFT JOIN MEDICOS m ON ft.ID_MEDICOS = m.ID_MEDICOS;

-- Tipos de tratamentos de consultas
CREATE OR REPLACE VIEW vista_tipos_tratamentos_consultas AS
SELECT
    ttc.ID_TIPO_TRATAMENTOS_CONSULTAS,
    ttc.DESIGNACAO
FROM TIPOS_TRATAMENTOS_CONSULTAS ttc;

-- Tipos de utilizadores do sistema
CREATE OR REPLACE VIEW vista_tipos_utilizadores AS
SELECT
    tu.ID_TIPOS_UTILIZADORES,
    tu.DESIGNACAO
FROM TIPOS_UTILIZADORES tu;

-- Experiências com anestesia
CREATE OR REPLACE VIEW vista_exp_anestesia AS
SELECT
    ea.ID_EXP_ANESTESIA,
    ea.ID_PACIENTES,
    ea.ID_TIPOS_ANESTESIAS,
    ea.OBSERVACOES,
    p.NOME AS NOME_PACIENTE,
    ta.DESIGNACAO AS TIPO_ANESTESIA
FROM EXP_ANESTESIA ea
LEFT JOIN PACIENTES p ON ea.ID_PACIENTES = p.ID_PACIENTES
LEFT JOIN TIPOS_ANESTESIAS ta ON ea.ID_TIPOS_ANESTESIAS = ta.ID_TIPOS_ANESTESIAS;


-- SECÇÃO 2: VIEWS DE TABELAS DE ASSOCIAÇÃO (N:M)
-- Alergias de pacientes
CREATE OR REPLACE VIEW vista_alergias_pacientes AS
SELECT
    ap.ID_PACIENTES,
    ap.ID_ALERGIAS,
    p.NOME AS NOME_PACIENTE,
    a.NOME AS NOME_ALERGIA,
    a.OBSERVACOES
FROM ALERGIAS_PACIENTES ap
INNER JOIN PACIENTES p ON ap.ID_PACIENTES = p.ID_PACIENTES
INNER JOIN ALERGIAS a ON ap.ID_ALERGIAS = a.ID_ALERGIAS;

-- Medicamentos por paciente
CREATE OR REPLACE VIEW vista_medicamentos_pacientes AS
SELECT
    mp.ID_PACIENTES,
    mp.ID_MEDICAMENTO,
    p.NOME AS NOME_PACIENTE,
    m.NOME AS NOME_MEDICAMENTO,
    m.OBSERVACOES
FROM MEDICAMENTOS_PACIENTES mp
INNER JOIN PACIENTES p ON mp.ID_PACIENTES = p.ID_PACIENTES
INNER JOIN MEDICAMENTOS m ON mp.ID_MEDICAMENTO = m.ID_MEDICAMENTO;

-- Condições médicas de pacientes
CREATE OR REPLACE VIEW vista_condicoes_medicas_pacientes AS
SELECT
    cmp.ID_PACIENTES,
    cmp.ID_CONDICOES_MEDICAS,
    p.NOME AS NOME_PACIENTE,
    cm.NOME AS NOME_CONDICAO,
    cm.OBSERVACOES,
    cm.ESTADO
FROM CONDICOES_MEDICAS_PACIENTES cmp
INNER JOIN PACIENTES p ON cmp.ID_PACIENTES = p.ID_PACIENTES
INNER JOIN CONDICOES_MEDICAS cm ON cmp.ID_CONDICOES_MEDICAS = cm.ID_CONDICOES_MEDICAS;

-- Doenças dentárias por paciente
CREATE OR REPLACE VIEW vista_doencas_dentarias_pacientes AS
SELECT
    ddp.ID_PACIENTES,
    ddp.ID_DOENCAS_DENTARIAS,
    p.NOME AS NOME_PACIENTE,
    dd.NOME AS NOME_DOENCA,
    dd.DESCRICAO
FROM DOENCAS_DENTARIAS_PACIENTES ddp
INNER JOIN PACIENTES p ON ddp.ID_PACIENTES = p.ID_PACIENTES
INNER JOIN DOENCAS_DENTARIAS dd ON ddp.ID_DOENCAS_DENTARIAS = dd.ID_DOENCAS_DENTARIAS;

-- Relação utilizadores e pacientes
CREATE OR REPLACE VIEW vista_utilizadores_pacientes AS
SELECT
    up.ID_PACIENTES,
    up.ID_UTILIZADORES,
    p.NOME AS NOME_PACIENTE,
    u.USERNAME AS USERNAME_UTILIZADOR,
    u.EMAIL,
    u.ESTADO,
    tu.DESIGNACAO AS TIPO_UTILIZADOR
FROM UTILIZADORES_PACIENTES up
INNER JOIN PACIENTES p ON up.ID_PACIENTES = p.ID_PACIENTES
INNER JOIN UTILIZADORES u ON up.ID_UTILIZADORES = u.ID_UTILIZADORES
LEFT JOIN TIPOS_UTILIZADORES tu ON u.ID_TIPOS_UTILIZADORES = tu.ID_TIPOS_UTILIZADORES;

-- Notificações por utilizador
CREATE OR REPLACE VIEW vista_notificacoes_utilizadores AS
SELECT
    nu.ID_UTILIZADORES,
    nu.ID_NOTIFICACAO,
    u.USERNAME AS USERNAME_UTILIZADOR,
    n.DESCRICAO
FROM NOTIFICACOES_UTILIZADORES nu
INNER JOIN UTILIZADORES u ON nu.ID_UTILIZADORES = u.ID_UTILIZADORES
INNER JOIN NOTIFICACOES n ON nu.ID_NOTIFICACAO = n.ID_NOTIFICACAO;


-- SECÇÃO 3: VIEWS PARA ANÁLISE E RELATÓRIOS
-- Consultas agendadas 
-- Útil para a agenda diária
CREATE OR REPLACE VIEW vista_consultas_agendadas AS
SELECT
    c.ID_CONSULTAS,
    c.DATAFASE,
    c.HORA,
    p.NOME AS NOME_PACIENTE,
    p.CONTACTOPESSOAL,
    m.NOME AS NOME_MEDICO,
    tc.DESIGNACAO AS TIPO_CONSULTA,
    g.DESIGNACAO AS GABINETE
FROM CONSULTAS c
INNER JOIN PACIENTES p ON c.ID_PACIENTES = p.ID_PACIENTES
INNER JOIN MEDICOS m ON c.ID_MEDICOS = m.ID_MEDICOS
INNER JOIN TIPOS_CONSULTA tc ON c.ID_TIPO_CONSULTA = tc.ID_TIPO_CONSULTA
INNER JOIN ESTADOS_CONSULTAS ec ON c.ID_ESTADOS_CONSULTAS = ec.ID_ESTADOS_CONSULTAS
INNER JOIN GABINETES g ON c.ID_GABINETES = g.ID_GABINETES
WHERE ec.DESIGNACAO = 'Agendada';

-- Tratamentos ativos
CREATE OR REPLACE VIEW vista_tratamentos_ativos AS
SELECT
    t.ID_TRATAMENTOS,
    t.NOME,
    t.DESCRICAO,
    t.DATAINICIO,
    t.NUMERODEFASES,
    p.NOME AS NOME_PACIENTE,
    p.CONTACTOPESSOAL
FROM TRATAMENTOS t
INNER JOIN PACIENTES p ON t.ID_PACIENTES = p.ID_PACIENTES
WHERE t.DATAFINAL IS NULL OR t.ESTADO = TRUE;

-- Histórico completo do paciente com agregações
-- Esta view mostra um resumo de toda a informação médica de cada paciente
CREATE OR REPLACE VIEW vista_historico_paciente AS
SELECT
    p.ID_PACIENTES,
    p.NOME AS NOME_PACIENTE,
    p.DATADENASCIMENTO,
    p.GENERO,
    p.CONTACTOPESSOAL,
    p.NIF,
    COUNT(DISTINCT c.ID_CONSULTAS) AS TOTAL_CONSULTAS,
    COUNT(DISTINCT t.ID_TRATAMENTOS) AS TOTAL_TRATAMENTOS,
    COUNT(DISTINCT ap.ID_ALERGIAS) AS TOTAL_ALERGIAS,
    COUNT(DISTINCT mp.ID_MEDICAMENTO) AS TOTAL_MEDICAMENTOS,
    COUNT(DISTINCT cmp.ID_CONDICOES_MEDICAS) AS TOTAL_CONDICOES_MEDICAS,
    COUNT(DISTINCT ddp.ID_DOENCAS_DENTARIAS) AS TOTAL_DOENCAS_DENTARIAS
FROM PACIENTES p
LEFT JOIN CONSULTAS c ON p.ID_PACIENTES = c.ID_PACIENTES
LEFT JOIN TRATAMENTOS t ON p.ID_PACIENTES = t.ID_PACIENTES
LEFT JOIN ALERGIAS_PACIENTES ap ON p.ID_PACIENTES = ap.ID_PACIENTES
LEFT JOIN MEDICAMENTOS_PACIENTES mp ON p.ID_PACIENTES = mp.ID_PACIENTES
LEFT JOIN CONDICOES_MEDICAS_PACIENTES cmp ON p.ID_PACIENTES = cmp.ID_PACIENTES
LEFT JOIN DOENCAS_DENTARIAS_PACIENTES ddp ON p.ID_PACIENTES = ddp.ID_PACIENTES
GROUP BY p.ID_PACIENTES, p.NOME, p.DATADENASCIMENTO, p.GENERO, p.CONTACTOPESSOAL, p.NIF;


--SECÇÃO 4: VIEWS NOVAS (tabelas que não tinham view)
-- Tipos de medicamentos (NOVA VIEW)
CREATE OR REPLACE VIEW vista_tipos_medicamentos AS
SELECT
    tm.ID_TIPOS_MEDICAMENTOS,
    tm.DESIGNACAO
FROM TIPOS_MEDICAMENTOS tm;

-- Documentos de consentimento RGPD (NOVA VIEW)
-- Útil para relatórios de conformidade RGPD
CREATE OR REPLACE VIEW vista_documentos_consentimento_rgpd AS
SELECT
    dc.ID_DOCUMENTO,
    dc.RECOLHA_TRATAMENTO,
    dc.DADOS_PESSOAIS_CLINICOS,
    dc.PUBLICACAO_REDES_SOCIAIS,
    dc.ARMAZENAMENTO_HISTORICO,
    dc.FOTOGRAFIAS_CIENTIFICAS,
    dc.FOTOGRAFIAS_INTERNAS,
    dc.TODOS_CONSENTIMENTOS,
    dc.DATA_ATUALIZACAO
FROM DOCUMENTOS_CONSENTIMENTO_RGPD dc;