/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     9/1/2024 4:35:29 PM                          */
/*==============================================================*/



/*==============================================================*/
/* Table: CATEGORIA_SERVICIO                                    */
/*==============================================================*/
create table CATEGORIA_SERVICIO (
   ID_CATEGORIA         SERIAL               not null,
   SERVICIO_PROVEDOR    VARCHAR(500)         not null,
   constraint PK_CATEGORIA_SERVICIO primary key (ID_CATEGORIA)
);

/*==============================================================*/
/* Index: CATEGORIA_SERVICIO_PK                                 */
/*==============================================================*/
create unique index CATEGORIA_SERVICIO_PK on CATEGORIA_SERVICIO (
ID_CATEGORIA
);

/*==============================================================*/
/* Table: CLIENTES                                              */
/*==============================================================*/
create table CLIENTES (
   INE_CLIENTE          CHAR(10)             not null,
   CONTACTO_CLIENTE     CHAR(10)             not null,
   NOMBRE_CLIENTE       VARCHAR(500)            not null,
   constraint PK_CLIENTES primary key (INE_CLIENTE)
);

/*==============================================================*/
/* Index: CLIENTES_PK                                           */
/*==============================================================*/
create unique index CLIENTES_PK on CLIENTES (
INE_CLIENTE
);

/*==============================================================*/
/* Table: COTIZACIONES                                          */
/*==============================================================*/
create table COTIZACIONES (
   ID_COTIZACION        SERIAL               not null,
   ID_EVENTO            INT4                 not null,
   DESCRIPCION_COTIZACION VARCHAR(1000)        not null,
   TIEMPO_CONTRATADO    TIME                 not null,
   MONTO_COTIZACION     MONEY                not null,
   ESTADO_PAGO          VARCHAR(20)          not null,
   constraint PK_COTIZACIONES primary key (ID_COTIZACION)
);

/*==============================================================*/
/* Index: COTIZACIONES_PK                                       */
/*==============================================================*/
create unique index COTIZACIONES_PK on COTIZACIONES (
ID_COTIZACION
);

/*==============================================================*/
/* Index: TIENE_FK                                              */
/*==============================================================*/
create  index TIENE_FK on COTIZACIONES (
ID_EVENTO
);

/*==============================================================*/
/* Table: EVENTOS                                               */
/*==============================================================*/
create table EVENTOS (
   ID_EVENTO            SERIAL               not null,
   INE_CLIENTE          CHAR(10)             not null,
   NOMBRE_EVENTO        VARCHAR(500)         not null,
   FECHA_EVENTO         DATE                 not null,
   LUGAR_EVENTO         VARCHAR(500)         not null,
   AFORO_LUGAR_EVENTO   INT4                 not null,
   NUMERO_INVITADOS     INT4                 not null,
   TEMATICA_EVENTO      VARCHAR(500)         not null,
   constraint PK_EVENTOS primary key (ID_EVENTO)
);

/*==============================================================*/
/* Index: EVENTOS_PK                                            */
/*==============================================================*/
create unique index EVENTOS_PK on EVENTOS (
ID_EVENTO
);

/*==============================================================*/
/* Index: ORGANIZADO_FK                                         */
/*==============================================================*/
create  index ORGANIZADO_FK on EVENTOS (
INE_CLIENTE
);

/*==============================================================*/
/* Table: PROPORCIONA                                           */
/*==============================================================*/
create table PROPORCIONA (
   ID_PROVEEDOR         INT4                 not null,
   ID_COTIZACION        INT4                 not null,
   constraint PK_PROPORCIONA primary key (ID_PROVEEDOR, ID_COTIZACION)
);

/*==============================================================*/
/* Index: PROPORCIONA_PK                                        */
/*==============================================================*/
create unique index PROPORCIONA_PK on PROPORCIONA (
ID_PROVEEDOR,
ID_COTIZACION
);

/*==============================================================*/
/* Index: PROPORCIONA2_FK                                       */
/*==============================================================*/
create  index PROPORCIONA2_FK on PROPORCIONA (
ID_COTIZACION
);

/*==============================================================*/
/* Index: PROPORCIONA_FK                                        */
/*==============================================================*/
create  index PROPORCIONA_FK on PROPORCIONA (
ID_PROVEEDOR
);

/*==============================================================*/
/* Table: PROVEEDORES                                           */
/*==============================================================*/
create table PROVEEDORES (
   ID_PROVEEDOR         SERIAL               not null,
   ID_CATEGORIA         INT4                 not null,
   NOMBRE_PROVEEDOR     VARCHAR(500)         not null,
   constraint PK_PROVEEDORES primary key (ID_PROVEEDOR)
);

/*==============================================================*/
/* Index: PROVEEDORES_PK                                        */
/*==============================================================*/
create unique index PROVEEDORES_PK on PROVEEDORES (
ID_PROVEEDOR
);

/*==============================================================*/
/* Index: CLASIFICA_FK                                          */
/*==============================================================*/
create  index CLASIFICA_FK on PROVEEDORES (
ID_CATEGORIA
);

alter table COTIZACIONES
   add constraint FK_COTIZACI_TIENE_EVENTOS foreign key (ID_EVENTO)
      references EVENTOS (ID_EVENTO)
      on delete restrict on update restrict;

alter table EVENTOS
   add constraint FK_EVENTOS_ORGANIZAD_CLIENTES foreign key (INE_CLIENTE)
      references CLIENTES (INE_CLIENTE)
      on delete restrict on update restrict;

alter table PROPORCIONA
   add constraint FK_PROPORCI_PROPORCIO_PROVEEDO foreign key (ID_PROVEEDOR)
      references PROVEEDORES (ID_PROVEEDOR)
      on delete restrict on update restrict;

alter table PROPORCIONA
   add constraint FK_PROPORCI_PROPORCIO_COTIZACI foreign key (ID_COTIZACION)
      references COTIZACIONES (ID_COTIZACION)
      on delete restrict on update restrict;

alter table PROVEEDORES
   add constraint FK_PROVEEDO_CLASIFICA_CATEGORI foreign key (ID_CATEGORIA)
      references CATEGORIA_SERVICIO (ID_CATEGORIA)
      on delete restrict on update restrict;

