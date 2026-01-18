/*==============================================================*/
/* DBMS name:      PostgreSQL 14.x                              */
/* Created on:     16/01/2026 11:56:31                          */
/*==============================================================*/


/*==============================================================*/
/* Table: ACORDOS_SUBSISTEMAS                                   */
/*==============================================================*/
create table ACORDOS_SUBSISTEMAS (
   ID_ACORDOS_SUBSISTEMAS integer              not null,
   NOME                 varchar(120)         not null,
   constraint PK_ACORDOS_SUBSISTEMAS primary key (ID_ACORDOS_SUBSISTEMAS)
);

/*==============================================================*/
/* Index: ACORDOS_SUBSISTEMAS_PK                                */
/*==============================================================*/
create unique index ACORDOS_SUBSISTEMAS_PK on ACORDOS_SUBSISTEMAS (
ID_ACORDOS_SUBSISTEMAS
);

/*==============================================================*/
/* Table: ALERGIAS                                              */
/*==============================================================*/
create table ALERGIAS (
   ID_ALERGIAS          integer              not null,
   NOME                 varchar(120)         not null,
   OBSERVACOES          varchar(200),
   constraint PK_ALERGIAS primary key (ID_ALERGIAS)
);

/*==============================================================*/
/* Index: ALERGIAS_PK                                           */
/*==============================================================*/
create unique index ALERGIAS_PK on ALERGIAS (
ID_ALERGIAS
);

/*==============================================================*/
/* Table: PACIENTES                                             */
/*==============================================================*/
create table PACIENTES (
   ID_PACIENTES         integer              not null,
   ID_TITULAR_PACIENTE     integer,
   ID_ACORDOS_SUBSISTEMAS integer,
   NOME                 varchar(120)         not null,
   NIF                  varchar(15),
   DATADENASCIMENTO     date                 not null,
   GENERO               varchar(20),
   NUMERODEUTENTE       varchar(30),
   ESTADOCIVIL          varchar(100),
   PROFISSAO            varchar(150),
   CONTACTOPESSOAL      varchar(15),
   CONTACTOSECUNDARIO   varchar(15),
   MORADA               varchar(100),
   CODIGOPOSTAL         varchar(15),
   LOCALIDADE           varchar(150),
   DEPENDENTEPORIDADE   integer,
   constraint PK_PACIENTES primary key (ID_PACIENTES),
   constraint FK_PACIENTE_PACIENTES_PACIENTE foreign key (ID_TITULAR_PACIENTE)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict,
   constraint FK_PACIENTE_ACORDOS_S_ACORDOS_ foreign key (ID_ACORDOS_SUBSISTEMAS)
      references ACORDOS_SUBSISTEMAS (ID_ACORDOS_SUBSISTEMAS)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Table: ALERGIAS_PACIENTES                                    */
/*==============================================================*/
create table ALERGIAS_PACIENTES (
   ID_PACIENTES         integer              not null,
   ID_ALERGIAS          integer              not null,
   constraint PK_ALERGIAS_PACIENTES primary key (ID_PACIENTES, ID_ALERGIAS),
   constraint FK_ALERGIAS_ALERGIAS__ALERGIAS foreign key (ID_ALERGIAS)
      references ALERGIAS (ID_ALERGIAS)
      on delete restrict on update restrict,
   constraint FK_ALERGIAS_ALERGIAS__PACIENTE foreign key (ID_PACIENTES)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: ALERGIAS_PACIENTES_PK                                 */
/*==============================================================*/
create unique index ALERGIAS_PACIENTES_PK on ALERGIAS_PACIENTES (
ID_PACIENTES,
ID_ALERGIAS
);

/*==============================================================*/
/* Index: ALERGIAS_PACIENTES2_FK                                */
/*==============================================================*/
create  index ALERGIAS_PACIENTES2_FK on ALERGIAS_PACIENTES (
ID_ALERGIAS
);

/*==============================================================*/
/* Index: ALERGIAS_PACIENTES_FK                                 */
/*==============================================================*/
create  index ALERGIAS_PACIENTES_FK on ALERGIAS_PACIENTES (
ID_PACIENTES
);

/*==============================================================*/
/* Table: CIRURGIAS_ANTERIORES                                  */
/*==============================================================*/
create table CIRURGIAS_ANTERIORES (
   ID_CIRURGIAS_ANTERIORES integer              not null,
   ID_PACIENTES         integer,
   NOME                 varchar(120),
   DATAFASE             date,
   HOSPITAL             varchar(120),
   OBSERVACOES          varchar(200),
   constraint PK_CIRURGIAS_ANTERIORES primary key (ID_CIRURGIAS_ANTERIORES),
   constraint FK_CIRURGIA_PACIENTES_PACIENTE foreign key (ID_PACIENTES)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: CIRURGIAS_ANTERIORES_PK                               */
/*==============================================================*/
create unique index CIRURGIAS_ANTERIORES_PK on CIRURGIAS_ANTERIORES (
ID_CIRURGIAS_ANTERIORES
);

/*==============================================================*/
/* Index: PACIENTES_CIRURGIAS_ANTERIORES_FK                     */
/*==============================================================*/
create  index PACIENTES_CIRURGIAS_ANTERIORES_FK on CIRURGIAS_ANTERIORES (
ID_PACIENTES
);

/*==============================================================*/
/* Table: CONDICOES_MEDICAS                                     */
/*==============================================================*/
create table CONDICOES_MEDICAS (
   ID_CONDICOES_MEDICAS integer              not null,
   NOME                 varchar(120)         not null,
   OBSERVACOES          varchar(200),
   ESTADO               boolean,
   constraint PK_CONDICOES_MEDICAS primary key (ID_CONDICOES_MEDICAS)
);

/*==============================================================*/
/* Index: CONDICOES_MEDICAS_PK                                  */
/*==============================================================*/
create unique index CONDICOES_MEDICAS_PK on CONDICOES_MEDICAS (
ID_CONDICOES_MEDICAS
);

/*==============================================================*/
/* Table: CONDICOES_MEDICAS_PACIENTES                           */
/*==============================================================*/
create table CONDICOES_MEDICAS_PACIENTES (
   ID_PACIENTES         integer              not null,
   ID_CONDICOES_MEDICAS integer              not null,
   constraint PK_CONDICOES_MEDICAS_PACIENTES primary key (ID_PACIENTES, ID_CONDICOES_MEDICAS),
   constraint FK_CONDICOE_CONDICOES_CONDICOE foreign key (ID_CONDICOES_MEDICAS)
      references CONDICOES_MEDICAS (ID_CONDICOES_MEDICAS)
      on delete restrict on update restrict,
   constraint FK_CONDICOE_CONDICOES_PACIENTE foreign key (ID_PACIENTES)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: CONDICOES_MEDICAS_PACIENTES_PK                        */
/*==============================================================*/
create unique index CONDICOES_MEDICAS_PACIENTES_PK on CONDICOES_MEDICAS_PACIENTES (
ID_PACIENTES,
ID_CONDICOES_MEDICAS
);

/*==============================================================*/
/* Index: CONDICOES_MEDICAS_PACIENTES2_FK                       */
/*==============================================================*/
create  index CONDICOES_MEDICAS_PACIENTES2_FK on CONDICOES_MEDICAS_PACIENTES (
ID_CONDICOES_MEDICAS
);

/*==============================================================*/
/* Index: CONDICOES_MEDICAS_PACIENTES_FK                        */
/*==============================================================*/
create  index CONDICOES_MEDICAS_PACIENTES_FK on CONDICOES_MEDICAS_PACIENTES (
ID_PACIENTES
);

/*==============================================================*/
/* Table: GABINETES                                             */
/*==============================================================*/
create table GABINETES (
   ID_GABINETES         integer              not null,
   DESIGNACAO           varchar(200)         not null,
   constraint PK_GABINETES primary key (ID_GABINETES)
);

/*==============================================================*/
/* Table: TRATAMENTOS                                           */
/*==============================================================*/
create table TRATAMENTOS (
   ID_TRATAMENTOS       integer              not null,
   ID_PACIENTES         integer,
   NOME                 varchar(120)         not null,
   ESTADO               boolean              not null,
   NUMERODEFASES        integer              not null,
   DATAFINAL            date,
   DATAINICIO           date                 not null,
   DESCRICAO            text                 not null,
   POSTRATAMENTO        varchar(200),
   NUMEROCONSULTASPORFASE integer              not null,
   DURACAOPREVISTA      integer,
   constraint PK_TRATAMENTOS primary key (ID_TRATAMENTOS),
   constraint FK_TRATAMEN_PACIENTES_PACIENTE foreign key (ID_PACIENTES)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Table: TIPOS_UTILIZADORES                                    */
/*==============================================================*/
create table TIPOS_UTILIZADORES (
   ID_TIPOS_UTILIZADORES integer              not null,
   DESIGNACAO           varchar(200)         not null,
   constraint PK_TIPOS_UTILIZADORES primary key (ID_TIPOS_UTILIZADORES)
);

/*==============================================================*/
/* Table: UTILIZADORES                                          */
/*==============================================================*/
create table UTILIZADORES (
   ID_UTILIZADORES      integer              not null,
   ID_TIPOS_UTILIZADORES integer,
   USERNAME             varchar(200)         not null,
   PASSWORD             varchar(200)         not null,
   EMAIL                varchar(150)         not null,
   ESTADO               boolean              not null,
   constraint PK_UTILIZADORES primary key (ID_UTILIZADORES),
   constraint FK_UTILIZAD_TIPOS_UTI_TIPOS_UT foreign key (ID_TIPOS_UTILIZADORES)
      references TIPOS_UTILIZADORES (ID_TIPOS_UTILIZADORES)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Table: MEDICOS                                               */
/*==============================================================*/
create table MEDICOS (
   ID_MEDICOS           integer              not null,
   ID_UTILIZADORES      integer,
   NOME                 varchar(120)         not null,
   ESPECIALIDADE        varchar(120),
   constraint PK_MEDICOS primary key (ID_MEDICOS),
   constraint FK_MEDICOS_UTILIZADO_UTILIZAD foreign key (ID_UTILIZADORES)
      references UTILIZADORES (ID_UTILIZADORES)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Table: TIPOS_ANESTESIAS                                      */
/*==============================================================*/
create table TIPOS_ANESTESIAS (
   ID_TIPOS_ANESTESIAS  integer              not null,
   DESIGNACAO           varchar(200)         not null,
   constraint PK_TIPOS_ANESTESIAS primary key (ID_TIPOS_ANESTESIAS)
);

/*==============================================================*/
/* Table: ESTADOS_CONSULTAS                                     */
/*==============================================================*/
create table ESTADOS_CONSULTAS (
   ID_ESTADOS_CONSULTAS integer              not null,
   DESIGNACAO           varchar(200)         not null,
   constraint PK_ESTADOS_CONSULTAS primary key (ID_ESTADOS_CONSULTAS)
);

/*==============================================================*/
/* Table: TIPOS_TRATAMENTOS_CONSULTAS                           */
/*==============================================================*/
create table TIPOS_TRATAMENTOS_CONSULTAS (
   ID_TIPO_TRATAMENTOS_CONSULTAS integer              not null,
   DESIGNACAO           varchar(200)         not null,
   constraint PK_TIPOS_TRATAMENTOS_CONSULTAS primary key (ID_TIPO_TRATAMENTOS_CONSULTAS)
);

/*==============================================================*/
/* Table: TIPOS_CONSULTA                                        */
/*==============================================================*/
create table TIPOS_CONSULTA (
   ID_TIPO_CONSULTA     integer              not null,
   DESIGNACAO           varchar(200)         not null,
   constraint PK_TIPOS_CONSULTA primary key (ID_TIPO_CONSULTA)
);

/*==============================================================*/
/* Table: CONSULTAS                                             */
/*==============================================================*/
create table CONSULTAS (
   ID_CONSULTAS         integer              not null,
   ID_GABINETES         integer,
   ID_TRATAMENTOS       integer,
   ID_MEDICOS           integer,
   ID_TIPOS_ANESTESIAS  integer,
   ID_ESTADOS_CONSULTAS integer,
   ID_TIPO_TRATAMENTOS_CONSULTAS integer,
   ID_PACIENTES         integer,
   ID_TIPO_CONSULTA     integer,
   DATAFASE             date                 not null,
   HORA                 time                 not null,
   DURACAOPREVISTA      integer              not null,
   constraint PK_CONSULTAS primary key (ID_CONSULTAS),
   constraint FK_CONSULTA_GABINETES_GABINETE foreign key (ID_GABINETES)
      references GABINETES (ID_GABINETES)
      on delete restrict on update restrict,
   constraint FK_CONSULTA_TRATAMENT_TRATAMEN foreign key (ID_TRATAMENTOS)
      references TRATAMENTOS (ID_TRATAMENTOS)
      on delete restrict on update restrict,
   constraint FK_CONSULTA_CONSULTAS_MEDICOS foreign key (ID_MEDICOS)
      references MEDICOS (ID_MEDICOS)
      on delete restrict on update restrict,
   constraint FK_CONSULTA_TIPOS_ANE_TIPOS_AN foreign key (ID_TIPOS_ANESTESIAS)
      references TIPOS_ANESTESIAS (ID_TIPOS_ANESTESIAS)
      on delete restrict on update restrict,
   constraint FK_CONSULTA_ESTADOS_C_ESTADOS_ foreign key (ID_ESTADOS_CONSULTAS)
      references ESTADOS_CONSULTAS (ID_ESTADOS_CONSULTAS)
      on delete restrict on update restrict,
   constraint FK_CONSULTA_TIPO_TRAT_TIPOS_TR foreign key (ID_TIPO_TRATAMENTOS_CONSULTAS)
      references TIPOS_TRATAMENTOS_CONSULTAS (ID_TIPO_TRATAMENTOS_CONSULTAS)
      on delete restrict on update restrict,
   constraint FK_CONSULTA_PACIENTES_PACIENTE foreign key (ID_PACIENTES)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict,
   constraint FK_CONSULTA_RELATIONS_TIPOS_CO foreign key (ID_TIPO_CONSULTA)
      references TIPOS_CONSULTA (ID_TIPO_CONSULTA)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: CONSULTAS_PK                                          */
/*==============================================================*/
create unique index CONSULTAS_PK on CONSULTAS (
ID_CONSULTAS
);

/*==============================================================*/
/* Index: GABINETES_CONSULTAS_FK                                */
/*==============================================================*/
create  index GABINETES_CONSULTAS_FK on CONSULTAS (
ID_GABINETES
);

/*==============================================================*/
/* Index: TRATAMENTOS_CONSULTAS_FK                              */
/*==============================================================*/
create  index TRATAMENTOS_CONSULTAS_FK on CONSULTAS (
ID_TRATAMENTOS
);

/*==============================================================*/
/* Index: CONSULTAS_MEDICOS_FK                                  */
/*==============================================================*/
create  index CONSULTAS_MEDICOS_FK on CONSULTAS (
ID_MEDICOS
);

/*==============================================================*/
/* Index: TIPOS_ANESTESIAS_CONSULTAS_FK                         */
/*==============================================================*/
create  index TIPOS_ANESTESIAS_CONSULTAS_FK on CONSULTAS (
ID_TIPOS_ANESTESIAS
);

/*==============================================================*/
/* Index: ESTADOS_CONSULTAS_CONSULTAS_FK                        */
/*==============================================================*/
create  index ESTADOS_CONSULTAS_CONSULTAS_FK on CONSULTAS (
ID_ESTADOS_CONSULTAS
);

/*==============================================================*/
/* Index: TIPO_TRATAMENTOS_CONSULTAS_CONSULTAS_FK               */
/*==============================================================*/
create  index TIPO_TRATAMENTOS_CONSULTAS_CONSULTAS_FK on CONSULTAS (
ID_TIPO_TRATAMENTOS_CONSULTAS
);

/*==============================================================*/
/* Index: PACIENTES_CONSULTAS_FK                                */
/*==============================================================*/
create  index PACIENTES_CONSULTAS_FK on CONSULTAS (
ID_PACIENTES
);

/*==============================================================*/
/* Index: RELATIONSHIP_30_FK                                    */
/*==============================================================*/
create  index RELATIONSHIP_30_FK on CONSULTAS (
ID_TIPO_CONSULTA
);

/*==============================================================*/
/* Table: TIPOS_DOCUMENTOS                                      */
/*==============================================================*/
create table TIPOS_DOCUMENTOS (
   ID_TIPOS_DOCUMENTOS integer              not null,
   DESIGNACAO           varchar(200)         not null,
   EXTENCAO             varchar(6)           not null,
   constraint PK_TIPOS_DOCUMENTOS primary key (ID_TIPOS_DOCUMENTOS)
);

/*==============================================================*/
/* Table: DOCUMENTOS                                            */
/*==============================================================*/
create table DOCUMENTOS (
   ID_DOCUMENTOS        integer              not null,
   ID_TIPOS_DOCUMENTOS integer,
   ID_PACIENTES         integer,
   ID_MEDICOS           integer,
   NOME                 varchar(120)         not null,
   CAMINHO_FICHEIRO     varchar(250)         not null,
   TAMANHO_BYTES        integer              not null,
   DATA_UPLOAD          timestamp            not null,
   DATA_GERACAO         timestamp,
   ATIVO                boolean              not null,
   OBSERVACOES          varchar(200),
   constraint PK_DOCUMENTOS primary key (ID_DOCUMENTOS),
   constraint FK_DOCUMENT_TIPOS_DOC_TIPOS_DO foreign key (ID_TIPOS_DOCUMENTOS)
      references TIPOS_DOCUMENTOS (ID_TIPOS_DOCUMENTOS)
      on delete restrict on update restrict,
   constraint FK_DOCUMENT_RELATIONS_PACIENTE foreign key (ID_PACIENTES)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict,
   constraint FK_DOCUMENT_MEDICOS_D_MEDICOS foreign key (ID_MEDICOS)
      references MEDICOS (ID_MEDICOS)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: DOCUMENTOS_PK                                         */
/*==============================================================*/
create unique index DOCUMENTOS_PK on DOCUMENTOS (
ID_DOCUMENTOS
);

/*==============================================================*/
/* Index: TIPOS_DOCUMENTOS_DOCUMENTOS_FK                        */
/*==============================================================*/
create  index TIPOS_DOCUMENTOS_DOCUMENTOS_FK on DOCUMENTOS (
ID_TIPOS_DOCUMENTOS
);

/*==============================================================*/
/* Index: RELATIONSHIP_33_FK                                    */
/*==============================================================*/
create  index RELATIONSHIP_33_FK on DOCUMENTOS (
ID_PACIENTES
);

/*==============================================================*/
/* Index: MEDICOS_DOCUMENTOS_FK                                 */
/*==============================================================*/
create  index MEDICOS_DOCUMENTOS_FK on DOCUMENTOS (
ID_MEDICOS
);

/*==============================================================*/
/* Table: DOCUMENTOS_CONSENTIMENTO_RGPD                         */
/*==============================================================*/
create table DOCUMENTOS_CONSENTIMENTO_RGPD (
   ID_DOCUMENTO         integer              not null,
   RECOLHA_TRATAMENTO   boolean,
   DADOS_PESSOAIS_CLINICOS boolean,
   PUBLICACAO_REDES_SOCIAIS boolean,
   ARMAZENAMENTO_HISTORICO boolean,
   FOTOGRAFIAS_CIENTIFICAS boolean,
   FOTOGRAFIAS_INTERNAS boolean,
   TODOS_CONSENTIMENTOS boolean,
   DATA_ATUALIZACAO     timestamp,
   constraint PK_DOCUMENTOS_CONSENTIMENTO_RG primary key (ID_DOCUMENTO)
);

/*==============================================================*/
/* Index: DOCUMENTOS_CONSENTIMENTO_RGPD_PK                      */
/*==============================================================*/
create unique index DOCUMENTOS_CONSENTIMENTO_RGPD_PK on DOCUMENTOS_CONSENTIMENTO_RGPD (
ID_DOCUMENTO
);

/*==============================================================*/
/* Table: DOENCAS_DENTARIAS                                     */
/*==============================================================*/
create table DOENCAS_DENTARIAS (
   ID_DOENCAS_DENTARIAS integer              not null,
   NOME                 varchar(120)         not null,
   DESCRICAO            text,
   constraint PK_DOENCAS_DENTARIAS primary key (ID_DOENCAS_DENTARIAS)
);

/*==============================================================*/
/* Index: DOENCAS_DENTARIAS_PK                                  */
/*==============================================================*/
create unique index DOENCAS_DENTARIAS_PK on DOENCAS_DENTARIAS (
ID_DOENCAS_DENTARIAS
);

/*==============================================================*/
/* Table: DOENCAS_DENTARIAS_PACIENTES                           */
/*==============================================================*/
create table DOENCAS_DENTARIAS_PACIENTES (
   ID_PACIENTES         integer              not null,
   ID_DOENCAS_DENTARIAS integer              not null,
   constraint PK_DOENCAS_DENTARIAS_PACIENTES primary key (ID_PACIENTES, ID_DOENCAS_DENTARIAS),
   constraint FK_DOENCAS__DOENCAS_D_DOENCAS_ foreign key (ID_DOENCAS_DENTARIAS)
      references DOENCAS_DENTARIAS (ID_DOENCAS_DENTARIAS)
      on delete restrict on update restrict,
   constraint FK_DOENCAS__DOENCAS_D_PACIENTE foreign key (ID_PACIENTES)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: DOENCAS_DENTARIAS_PACIENTES_PK                        */
/*==============================================================*/
create unique index DOENCAS_DENTARIAS_PACIENTES_PK on DOENCAS_DENTARIAS_PACIENTES (
ID_PACIENTES,
ID_DOENCAS_DENTARIAS
);

/*==============================================================*/
/* Index: DOENCAS_DENTARIAS_PACIENTES2_FK                       */
/*==============================================================*/
create  index DOENCAS_DENTARIAS_PACIENTES2_FK on DOENCAS_DENTARIAS_PACIENTES (
ID_DOENCAS_DENTARIAS
);

/*==============================================================*/
/* Index: DOENCAS_DENTARIAS_PACIENTES_FK                        */
/*==============================================================*/
create  index DOENCAS_DENTARIAS_PACIENTES_FK on DOENCAS_DENTARIAS_PACIENTES (
ID_PACIENTES
);

/*==============================================================*/
/* Index: ESTADOS_CONSULTAS_PK                                  */
/*==============================================================*/
create unique index ESTADOS_CONSULTAS_PK on ESTADOS_CONSULTAS (
ID_ESTADOS_CONSULTAS
);

/*==============================================================*/
/* Table: EXP_ANESTESIA                                         */
/*==============================================================*/
create table EXP_ANESTESIA (
   ID_EXP_ANESTESIA     integer              not null,
   ID_PACIENTES         integer,
   ID_TIPOS_ANESTESIAS  integer,
   OBSERVACOES          varchar(200),
   constraint PK_EXP_ANESTESIA primary key (ID_EXP_ANESTESIA),
   constraint FK_EXP_ANES_PACIENTES_PACIENTE foreign key (ID_PACIENTES)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict,
   constraint FK_EXP_ANES_TIPOS_ANE_TIPOS_AN foreign key (ID_TIPOS_ANESTESIAS)
      references TIPOS_ANESTESIAS (ID_TIPOS_ANESTESIAS)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: EXP_ANESTESIA_PK                                      */
/*==============================================================*/
create unique index EXP_ANESTESIA_PK on EXP_ANESTESIA (
ID_EXP_ANESTESIA
);

/*==============================================================*/
/* Index: PACIENTES_EXP_ANESTESIA_FK                            */
/*==============================================================*/
create  index PACIENTES_EXP_ANESTESIA_FK on EXP_ANESTESIA (
ID_PACIENTES
);

/*==============================================================*/
/* Index: TIPOS_ANESTESIAS_EXP_ANESTESIA_FK                     */
/*==============================================================*/
create  index TIPOS_ANESTESIAS_EXP_ANESTESIA_FK on EXP_ANESTESIA (
ID_TIPOS_ANESTESIAS
);

/*==============================================================*/
/* Table: FASES_DE_TRATAMENTO                                   */
/*==============================================================*/
create table FASES_DE_TRATAMENTO (
   ID_FASES_DE_TRATAMENTO integer              not null,
   ID_TRATAMENTOS       integer,
   ID_MEDICOS           integer,
   NOME                 varchar(120)         not null,
   DATAFASE             date                 not null,
   ESTADO               boolean              not null,
   OBSERVACOES          varchar(200),
   ANESTESIA            boolean,
   NUMEROFASE           integer              not null,
   constraint PK_FASES_DE_TRATAMENTO primary key (ID_FASES_DE_TRATAMENTO),
   constraint FK_FASES_DE_TRATAMENT_TRATAMEN foreign key (ID_TRATAMENTOS)
      references TRATAMENTOS (ID_TRATAMENTOS)
      on delete restrict on update restrict,
   constraint FK_FASES_DE_MEDICOS_F_MEDICOS foreign key (ID_MEDICOS)
      references MEDICOS (ID_MEDICOS)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: FASES_DE_TRATAMENTO_PK                                */
/*==============================================================*/
create unique index FASES_DE_TRATAMENTO_PK on FASES_DE_TRATAMENTO (
ID_FASES_DE_TRATAMENTO
);

/*==============================================================*/
/* Index: TRATAMENTOS_FASE_DE_TRATAMENTO_FK                     */
/*==============================================================*/
create  index TRATAMENTOS_FASE_DE_TRATAMENTO_FK on FASES_DE_TRATAMENTO (
ID_TRATAMENTOS
);

/*==============================================================*/
/* Index: MEDICOS_FASES_DE_TRATAMENTO_FK                        */
/*==============================================================*/
create  index MEDICOS_FASES_DE_TRATAMENTO_FK on FASES_DE_TRATAMENTO (
ID_MEDICOS
);

/*==============================================================*/
/* Index: GABINETES_PK                                          */
/*==============================================================*/
create unique index GABINETES_PK on GABINETES (
ID_GABINETES
);

/*==============================================================*/
/* Table: HABITOS_VIDA                                          */
/*==============================================================*/
create table HABITOS_VIDA (
   ID_HABITOS_VIDA      integer              not null,
   ID_PACIENTES         integer,
   DESIGNACAO           varchar(200)         not null,
   OBSERVACOES          varchar(200),
   constraint PK_HABITOS_VIDA primary key (ID_HABITOS_VIDA),
   constraint FK_HABITOS__PACIENTES_PACIENTE foreign key (ID_PACIENTES)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: HABITOS_VIDA_PK                                       */
/*==============================================================*/
create unique index HABITOS_VIDA_PK on HABITOS_VIDA (
ID_HABITOS_VIDA
);

/*==============================================================*/
/* Index: PACIENTES_HABITOS_VIDA_FK                             */
/*==============================================================*/
create  index PACIENTES_HABITOS_VIDA_FK on HABITOS_VIDA (
ID_PACIENTES
);

/*==============================================================*/
/* Table: TIPOS_MEDICAMENTOS                                    */
/*==============================================================*/
create table TIPOS_MEDICAMENTOS (
   ID_TIPOS_MEDICAMENTOS integer              not null,
   DESIGNACAO           varchar(200)         not null,
   constraint PK_TIPOS_MEDICAMENTOS primary key (ID_TIPOS_MEDICAMENTOS)
);

/*==============================================================*/
/* Table: MEDICAMENTOS                                          */
/*==============================================================*/
create table MEDICAMENTOS (
   ID_MEDICAMENTO       integer              not null,
   ID_TIPOS_MEDICAMENTOS integer,
   NOME                 varchar(120)         not null,
   OBSERVACOES          varchar(200),
   constraint PK_MEDICAMENTOS primary key (ID_MEDICAMENTO),
   constraint FK_MEDICAME_RELATIONS_TIPOS_ME foreign key (ID_TIPOS_MEDICAMENTOS)
      references TIPOS_MEDICAMENTOS (ID_TIPOS_MEDICAMENTOS)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: MEDICAMENTOS_PK                                       */
/*==============================================================*/
create unique index MEDICAMENTOS_PK on MEDICAMENTOS (
ID_MEDICAMENTO
);

/*==============================================================*/
/* Index: RELATIONSHIP_29_FK                                    */
/*==============================================================*/
create  index RELATIONSHIP_29_FK on MEDICAMENTOS (
ID_TIPOS_MEDICAMENTOS
);

/*==============================================================*/
/* Table: MEDICAMENTOS_PACIENTES                                */
/*==============================================================*/
create table MEDICAMENTOS_PACIENTES (
   ID_PACIENTES         integer              not null,
   ID_MEDICAMENTO       integer              not null,
   constraint PK_MEDICAMENTOS_PACIENTES primary key (ID_PACIENTES, ID_MEDICAMENTO),
   constraint FK_MEDICAME_MEDICAMEN_MEDICAME foreign key (ID_MEDICAMENTO)
      references MEDICAMENTOS (ID_MEDICAMENTO)
      on delete restrict on update restrict,
   constraint FK_MEDICAME_MEDICAMEN_PACIENTE foreign key (ID_PACIENTES)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: MEDICAMENTOS_PACIENTES_PK                             */
/*==============================================================*/
create unique index MEDICAMENTOS_PACIENTES_PK on MEDICAMENTOS_PACIENTES (
ID_PACIENTES,
ID_MEDICAMENTO
);

/*==============================================================*/
/* Index: MEDICAMENTOS_PACIENTES2_FK                            */
/*==============================================================*/
create  index MEDICAMENTOS_PACIENTES2_FK on MEDICAMENTOS_PACIENTES (
ID_MEDICAMENTO
);

/*==============================================================*/
/* Index: MEDICAMENTOS_PACIENTES_FK                             */
/*==============================================================*/
create  index MEDICAMENTOS_PACIENTES_FK on MEDICAMENTOS_PACIENTES (
ID_PACIENTES
);

/*==============================================================*/
/* Index: MEDICOS_PK                                            */
/*==============================================================*/
create unique index MEDICOS_PK on MEDICOS (
ID_MEDICOS
);

/*==============================================================*/
/* Index: UTILIZADORES_MEDICOS_FK                               */
/*==============================================================*/
create  index UTILIZADORES_MEDICOS_FK on MEDICOS (
ID_UTILIZADORES
);

/*==============================================================*/
/* Table: NOTIFICACOES                                          */
/*==============================================================*/
create table NOTIFICACOES (
   ID_NOTIFICACAO       integer              not null,
   DESCRICAO            text                 not null,
   constraint PK_NOTIFICACOES primary key (ID_NOTIFICACAO)
);

/*==============================================================*/
/* Index: NOTIFICACOES_PK                                       */
/*==============================================================*/
create unique index NOTIFICACOES_PK on NOTIFICACOES (
ID_NOTIFICACAO
);

/*==============================================================*/
/* Table: NOTIFICACOES_UTILIZADORES                             */
/*==============================================================*/
create table NOTIFICACOES_UTILIZADORES (
   ID_UTILIZADORES      integer              not null,
   ID_NOTIFICACAO       integer              not null,
   constraint PK_NOTIFICACOES_UTILIZADORES primary key (ID_UTILIZADORES, ID_NOTIFICACAO),
   constraint FK_NOTIFICA_NOTIFICAC_NOTIFICA foreign key (ID_NOTIFICACAO)
      references NOTIFICACOES (ID_NOTIFICACAO)
      on delete restrict on update restrict,
   constraint FK_NOTIFICA_NOTIFICAC_UTILIZAD foreign key (ID_UTILIZADORES)
      references UTILIZADORES (ID_UTILIZADORES)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: NOTIFICACOES_UTILIZADORES_PK                          */
/*==============================================================*/
create unique index NOTIFICACOES_UTILIZADORES_PK on NOTIFICACOES_UTILIZADORES (
ID_UTILIZADORES,
ID_NOTIFICACAO
);

/*==============================================================*/
/* Index: NOTIFICACOES_UTILIZADORES2_FK                         */
/*==============================================================*/
create  index NOTIFICACOES_UTILIZADORES2_FK on NOTIFICACOES_UTILIZADORES (
ID_NOTIFICACAO
);

/*==============================================================*/
/* Index: NOTIFICACOES_UTILIZADORES_FK                          */
/*==============================================================*/
create  index NOTIFICACOES_UTILIZADORES_FK on NOTIFICACOES_UTILIZADORES (
ID_UTILIZADORES
);

/*==============================================================*/
/* Index: PACIENTES_PK                                          */
/*==============================================================*/
create unique index PACIENTES_PK on PACIENTES (
ID_PACIENTES
);

/*==============================================================*/
/* Index: PACIENTES_DEPENDENTES_FK                              */
/*==============================================================*/
create  index PACIENTES_DEPENDENTES_FK on PACIENTES (
ID_TITULAR_PACIENTE
);

/*==============================================================*/
/* Index: ACORDOS_SUBSISTEMAS_PACIENTES_FK                      */
/*==============================================================*/
create  index ACORDOS_SUBSISTEMAS_PACIENTES_FK on PACIENTES (
ID_ACORDOS_SUBSISTEMAS
);

/*==============================================================*/
/* Index: TIPOS_ANESTESIAS_PK                                   */
/*==============================================================*/
create unique index TIPOS_ANESTESIAS_PK on TIPOS_ANESTESIAS (
ID_TIPOS_ANESTESIAS
);

/*==============================================================*/
/* Index: TIPOS_CONSULTA_PK                                     */
/*==============================================================*/
create unique index TIPOS_CONSULTA_PK on TIPOS_CONSULTA (
ID_TIPO_CONSULTA
);

/*==============================================================*/
/* Index: TIPOS_DOCUMENTOS_PK                                   */
/*==============================================================*/
create unique index TIPOS_DOCUMENTOS_PK on TIPOS_DOCUMENTOS (
ID_TIPOS_DOCUMENTOS
);

/*==============================================================*/
/* Index: TIPOS_MEDICAMENTOS_PK                                 */
/*==============================================================*/
create unique index TIPOS_MEDICAMENTOS_PK on TIPOS_MEDICAMENTOS (
ID_TIPOS_MEDICAMENTOS
);

/*==============================================================*/
/* Index: TIPOS_TRATAMENTOS_CONSULTAS_PK                        */
/*==============================================================*/
create unique index TIPOS_TRATAMENTOS_CONSULTAS_PK on TIPOS_TRATAMENTOS_CONSULTAS (
ID_TIPO_TRATAMENTOS_CONSULTAS
);

/*==============================================================*/
/* Index: TIPOS_UTILIZADORES_PK                                 */
/*==============================================================*/
create unique index TIPOS_UTILIZADORES_PK on TIPOS_UTILIZADORES (
ID_TIPOS_UTILIZADORES
);

/*==============================================================*/
/* Index: TRATAMENTOS_PK                                        */
/*==============================================================*/
create unique index TRATAMENTOS_PK on TRATAMENTOS (
ID_TRATAMENTOS
);

/*==============================================================*/
/* Index: PACIENTES_TRATAMENTOS_FK                              */
/*==============================================================*/
create  index PACIENTES_TRATAMENTOS_FK on TRATAMENTOS (
ID_PACIENTES
);

/*==============================================================*/
/* Index: UTILIZADORES_PK                                       */
/*==============================================================*/
create unique index UTILIZADORES_PK on UTILIZADORES (
ID_UTILIZADORES
);

/*==============================================================*/
/* Index: TIPOS_UTILIZADORES_UTILIZADORES_FK                    */
/*==============================================================*/
create  index TIPOS_UTILIZADORES_UTILIZADORES_FK on UTILIZADORES (
ID_TIPOS_UTILIZADORES
);

/*==============================================================*/
/* Table: UTILIZADORES_PACIENTES                                */
/*==============================================================*/
create table UTILIZADORES_PACIENTES (
   ID_PACIENTES         integer              not null,
   ID_UTILIZADORES      integer              not null,
   constraint PK_UTILIZADORES_PACIENTES primary key (ID_PACIENTES, ID_UTILIZADORES),
   constraint FK_UTILIZAD_UTILIZADO_UTILIZAD foreign key (ID_UTILIZADORES)
      references UTILIZADORES (ID_UTILIZADORES)
      on delete restrict on update restrict,
   constraint FK_UTILIZAD_UTILIZADO_PACIENTE foreign key (ID_PACIENTES)
      references PACIENTES (ID_PACIENTES)
      on delete restrict on update restrict
);

/*==============================================================*/
/* Index: UTILIZADORES_PACIENTES_PK                             */
/*==============================================================*/
create unique index UTILIZADORES_PACIENTES_PK on UTILIZADORES_PACIENTES (
ID_PACIENTES,
ID_UTILIZADORES
);

/*==============================================================*/
/* Index: UTILIZADORES_PACIENTES2_FK                            */
/*==============================================================*/
create  index UTILIZADORES_PACIENTES2_FK on UTILIZADORES_PACIENTES (
ID_UTILIZADORES
);

/*==============================================================*/
/* Index: UTILIZADORES_PACIENTES_FK                             */
/*==============================================================*/
create  index UTILIZADORES_PACIENTES_FK on UTILIZADORES_PACIENTES (
ID_PACIENTES
);