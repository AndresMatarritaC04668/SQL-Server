use C04668

--Jose Andres Matarrita C04668
--Esteban Mora C05126

--Seccion 3 de la guia creacion de tablas-----------------------------------------------------------------------------

--Table estudiante
create table ESTUDIANTE
	(Cedula varchar(15) not null,
	 Email varchar(25),
	 NombreP varchar(15) not null,
	 Apellido1 varchar(15) not null,
	 Apellido2 varchar(15) not null,
	 Sexo char,
	 FechaNac date,
	 Direccion varchar(100),
	 Telefono varchar(15),
	 Carne varchar(10) not null,
	 Estado varchar(15) not null,
	 CONSTRAINT PKESTU primary key (Cedula));

select *
from ESTUDIANTE

--Tabla de Profesor
CREATE TABLE PROFESOR (
    Cedula VARCHAR(15) NOT NULL,
    Email VARCHAR(20) NOT NULL,
    NombreP VARCHAR(15) NOT NULL,
    Apellido1 VARCHAR(15) NOT NULL,
    Apellido2 VARCHAR(15) NOT NULL,
    Sexo CHAR(1),
    FechaNac DATE,
    Direccion VARCHAR(50),
    Telefono VARCHAR(15) ,
    Categoria VARCHAR(25),
    FechaNomb DATE,
    Titulo VARCHAR(25) NOT NULL,
    Oficina VARCHAR(25) NOT NULL,
    CONSTRAINT PKPROFE PRIMARY KEY (Cedula)
);

select *
from PROFESOR

create table ASISTENTE
	(Cedula varchar(15) not null,
	 NumHoras int NOT NULL,
	 CONSTRAINT PKASIST primary key (Cedula),
	 CONSTRAINT FKASISTCED foreign key (Cedula) references ESTUDIANTE (Cedula));

select *
from ASISTENTE

-- CARRERA (Código, Nombre, AñoCreación)
create table CARRERA 
	(Codigo varchar(15) not null,
	 Nombre varchar(60) not null,
	 annoCreacion int,
	 CONSTRAINT PKCARRE primary key (Codigo));

select *
from CARRERA



-- EMPADRONADO_EN (CedEstudiante, CodCarrera, FechaIngreso, FechaGraduación)
create table EMPADRONADO_EN
	(CedEstudiante varchar(15) not null,
	 CodCarrera varchar(15) not null,
	 FechaIngreso date,
	 FechaGraduacion date,
	 CONSTRAINT PKEMPAD primary key (CedEstudiante,CodCarrera),
	 CONSTRAINT FKEMPADCEDEST foreign key (CedEstudiante) references ESTUDIANTE(Cedula)
											on delete cascade,
	 CONSTRAINT FKEMPADCEDCOD foreign key (CodCarrera) references Carrera(Codigo));

select *
from EMPADRONADO_EN


--Tabla curso
CREATE TABLE Curso (
    Sigla CHAR(10) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Creditos INT NOT NULL,
    CONSTRAINT PKCURSO PRIMARY KEY (Sigla)
)

select *
from Curso;


-- PERTENECE_A (SiglaCurso, CodCarrera, NivelPlanEstudios)
create table PERTENECE_A
	(SiglaCurso char(10) not null,
	 CodCarrera varchar(15) not null,
	 NivelPlanEstudios int,
	 CONSTRAINT PKPERTENE primary key (SiglaCurso, CodCarrera),
	 CONSTRAINT FKPERTENESIGLA foreign key (SiglaCurso) references Curso(Sigla),
	 CONSTRAINT FKPERTENECOD  foreign key (CodCarrera) references CARRERA(Codigo));

select *
from PERTENECE_A





-- Grupo
CREATE TABLE Grupo (
    SiglaCurso CHAR(10) NOT NULL,
    NumGrupo INT NOT NULL,
    Semestre  int NOT NULL,
    Anio INT NOT NULL,
    CedProf   VARCHAR(15) CONSTRAINT TOTALPART_GRUPO_IMPARTE NOT NULL,
    Carga INT DEFAULT 0,
    CedAsist VARCHAR(15),
    CONSTRAINT PKGRUPO PRIMARY KEY (SiglaCurso,NumGrupo, Semestre, Anio),
    CONSTRAINT FK_Grupo_Curso FOREIGN KEY (SiglaCurso) REFERENCES Curso(Sigla) ON DELETE NO ACTION,
    CONSTRAINT FK_Grupo_Profesor FOREIGN KEY (CedProf) REFERENCES PROFESOR(Cedula) ON UPDATE CASCADE ,
     CONSTRAINT FK_Grupo_ASITENTE FOREIGN KEY (CedAsist) REFERENCES Asistente(Cedula),
);


create table LLEVA
	(CedEstudiante varchar(15) not null,
	 SiglaCurso char(10) not null,
	 NumGrupo int not null,
	 Semestre int NOT NULL,
	 Anno int NOT NULL,
	 Nota double precision not null,
	 CONSTRAINT NOTA_VALIDA check (Nota >= 0 and Nota <= 100),
	 primary key (CedEstudiante, SiglaCurso, NumGrupo, Semestre, Anno),
	 foreign key (CedEstudiante) references ESTUDIANTE(Cedula),
	 foreign key (SiglaCurso, NumGrupo, Semestre, Anno) references Grupo(SiglaCurso, NumGrupo, Semestre, Anio));


select *
from Grupo;



--Seccion 4 de la guia, insercion de duplas --------------------------------------------------------------------------------------------------------

-- Tuples para Tabla ESTUDIANTE
insert into ESTUDIANTE(Cedula, NombreP, Apellido1, Apellido2, Email, Sexo, FechaNac, Direccion
						, Telefono, Carne, Estado)
values ('111111111', 'Esteban', 'Mora', 'García', 'esteban@.com', 'M', '2002-01-01', 'Puriscal', '81818181', 'A1', 'activo');

insert into ESTUDIANTE(Cedula, NombreP, Apellido1, Apellido2, Email, Sexo, FechaNac, Direccion
						, Telefono, Carne, Estado)
values ('123456789', 'Andrés', 'Matarrita', 'Miranda', 'andrés@.com', 'M', '2001-02-02', 'Ciudad Colón', '7777777', 'A2', 'activo');

insert into ESTUDIANTE(Cedula, NombreP, Apellido1, Apellido2, Email, Sexo, FechaNac, Direccion
						, Telefono, Carne, Estado)
values ('117980255', 'Vanessa', 'Matamoros', 'Morales', 'morales@.com', 'F', '2000-12-20', 'Hatillo', '85659204', 'B2', 'activo');

--Tuples para Tabla PROFESOR
insert into PROFESOR(Cedula, Email, NombreP, Apellido1, Apellido2, Sexo, FechaNac, Direccion, Telefono
					, Categoria, FechaNomb, Titulo, Oficina)
values ('12121212', 'messi@.com', 'Leonel', 'Messi', 'Saborío', 'M', '1999-01-01', 'Hatillo 2', '4444444', 'interino'
			, '2023-02-06', 'Doctorado', '10');

insert into PROFESOR(Cedula, Email, NombreP, Apellido1, Apellido2, Sexo, FechaNac, Direccion, Telefono
					, Categoria, FechaNomb, Titulo, Oficina)
values ('99999999', 'ferxxo@.com', 'Feid', 'Figueres', 'Arias', 'M', '1998-01-01', 'Desamparados', '55555555', 'interino'
			, '2022-01-01', 'Doctorado', '07');

--Tuples para Tabla ASISTENTE
insert into ASISTENTE (Cedula, NumHoras)
values ('111111111', 8);

insert into ASISTENTE (Cedula, NumHoras)
values ('123456789', 10);

--Tuples para Tabla Curso
insert into Curso(Sigla, Nombre, Creditos)
values ('FA', 'Fundamentos de Arquitectura', 9);

insert into Curso(Sigla, Nombre, Creditos)
values ('HA', 'Historia de África', 2);

insert into Curso(Sigla, Nombre, Creditos)
values ('AA', 'Algebra', 5);

insert into Curso(Sigla, Nombre, Creditos)
values ('C2', 'Calculo2', 5);

--Tuples para Tabla Grupo
insert into Grupo(SiglaCurso, NumGrupo, Semestre, Anio, CedProf, Carga, CedAsist)
values ('FA', 1, 3, 2022, '99999999', 5, '111111111');

insert into Grupo(SiglaCurso, NumGrupo, Semestre, Anio, CedProf, Carga, CedAsist)
values ('HA', 2, 1, 2023, '12121212', 3, '123456789');

insert into Grupo(SiglaCurso, NumGrupo, Semestre, Anio, CedProf, Carga, CedAsist)
values ('C2', 1, 3, 2022, '12121212', 3, '123456789');

insert into Grupo(SiglaCurso, NumGrupo, Semestre, Anio, CedProf, Carga, CedAsist)
values ('AA', 1, 3, 2022, '12121212', 3, '123456789');

--Tuples para Tabla Carrera
insert into Carrera(Codigo, Nombre, annoCreacion)
values ('CA123', 'Sociología', 2000);

insert into Carrera(Codigo, Nombre, annoCreacion)
values ('YY343', 'Medicina', 1945);

--Tuples para Tabla EMPADRONADO_EN
insert into EMPADRONADO_EN (CedEstudiante, CodCarrera, FechaIngreso, FechaGraduacion)
values ('123456789', 'CA123', '2010-01-01', '2025-10-10');

insert into EMPADRONADO_EN (CedEstudiante, CodCarrera, FechaIngreso, FechaGraduacion)
values ('111111111', 'YY343', '2010-02-07', '2024-09-01');

insert into EMPADRONADO_EN (CedEstudiante, CodCarrera, FechaIngreso, FechaGraduacion)
values ('117980255', 'CA123', '2020-03-07', '2024-09-01');

--Tuples para Tabla PERTENECE_A
insert into PERTENECE_A(SiglaCurso, CodCarrera, NivelPlanEstudios)
values ('FA', 'CA123', 5);

insert into PERTENECE_A(SiglaCurso, CodCarrera, NivelPlanEstudios)
values ('HA', 'YY343', 4);


--Tuples para Tabla Lleva
insert into LLEVA (CedEstudiante, SiglaCurso, NumGrupo, Semestre, Anno, Nota)
values ('111111111', 'HA', 2, 1, 2023,90);


--Tuples para Tabla Lleva
insert into LLEVA (CedEstudiante, SiglaCurso, NumGrupo, Semestre, Anno, Nota)
values ('123456789', 'FA', 1, 3, 2022,90);


--Seccion 5 de la guia -----------------------------------------------------------------------------------------------------------------

---- ON DELETE CASCADE ---------------------------------------------------------------------

/*
a. Haga una consulta sobre la tabla “referenciada” por la llave externa en cuestión, tal que muestre 
al menos la llave primaria de esta tabla. Incluya en el reporte el comando SQL de la consulta y una 
captura de pantalla con su resultado.
*/

Select * from ESTUDIANTE;


/*
 b. Haga una consulta sobre la tabla que contiene la llave externa en cuestión, tal que 
muestre al menos la llave primaria y la llave externa de esta tabla. Incluya en el reporte 
el comando SQL de la consulta y una captura de pantalla con su resultado.
*/

Select CedEstudiante,CodCarrera from EMPADRONADO_EN

/*

 Borre (o modifique, según corresponda) una tupla de la tabla “referenciada” tal que 
accione la restricción en cuestión (ON DELETE CASCADE, ON DELETE NO ACTION u ON 
UPDATE CASCADE). Incluya en el reporte de laboratorio el comando SQL ejecutado y 
una captura de pantalla del resultado mostrado en el panel Output.

*/


Delete from ESTUDIANTE
where Cedula = '117980255';


/*
  d. Repita los pasos (a) y (b) de tal manera que el efecto del paso (c) sea observable1.
  Use las mismas consultas que usó en los pasos (a) y (b) para comparar el estado de las 
  tablas antes y después del comando que acciona la restricción.
*/

--D(A)-----------------------------------------------------------------------------

Select * from ESTUDIANTE;


--D(B)-----------------------------------------------------------------------------

Select CedEstudiante,CodCarrera from EMPADRONADO_EN

---- ON DELETE NO ACTION ----

/*
a. Haga una consulta sobre la tabla “referenciada” por la llave externa en cuestión, tal que muestre 
al menos la llave primaria de esta tabla. Incluya en el reporte el comando SQL de la consulta y una 
captura de pantalla con su resultado.
*/

Select * from CURSO;


/*
 b. Haga una consulta sobre la tabla que contiene la llave externa en cuestión, tal que 
muestre al menos la llave primaria y la llave externa de esta tabla. Incluya en el reporte 
el comando SQL de la consulta y una captura de pantalla con su resultado.
*/

Select SiglaCurso from GRUPO

/*

 c.Borre (o modifique, según corresponda) una tupla de la tabla “referenciada” tal que 
accione la restricción en cuestión (ON DELETE CASCADE, ON DELETE NO ACTION u ON 
UPDATE CASCADE). Incluya en el reporte de laboratorio el comando SQL ejecutado y 
una captura de pantalla del resultado mostrado en el panel Output.

*/

delete from CURSO
where Sigla = 'FA';


/*
  d. Repita los pasos (a) y (b) de tal manera que el efecto del paso (c) sea observable1.
  Use las mismas consultas que usó en los pasos (a) y (b) para comparar el estado de las 
  tablas antes y después del comando que acciona la restricción.
*/

--D(A)-----------------------------------------------------------------------------

Select * from CURSO;


--D(B)-----------------------------------------------------------------------------

Select SiglaCurso from GRUPO


---- ON UPDATE CASCADE ----

/*
a. Haga una consulta sobre la tabla “referenciada” por la llave externa en cuestión, tal que muestre 
al menos la llave primaria de esta tabla. Incluya en el reporte el comando SQL de la consulta y una 
captura de pantalla con su resultado.
*/

Select * from PROFESOR;


/*
 b. Haga una consulta sobre la tabla que contiene la llave externa en cuestión, tal que 
muestre al menos la llave primaria y la llave externa de esta tabla. Incluya en el reporte 
el comando SQL de la consulta y una captura de pantalla con su resultado.
*/

Select SiglaCurso, CedProf from GRUPO

/*

 c.Borre (o modifique, según corresponda) una tupla de la tabla “referenciada” tal que 
accione la restricción en cuestión (ON DELETE CASCADE, ON DELETE NO ACTION u ON 
UPDATE CASCADE). Incluya en el reporte de laboratorio el comando SQL ejecutado y 
una captura de pantalla del resultado mostrado en el panel Output.

*/

update PROFESOR set Cedula='77777777'
where Cedula='99999999'


/*
  d. Repita los pasos (a) y (b) de tal manera que el efecto del paso (c) sea observable1.
  Use las mismas consultas que usó en los pasos (a) y (b) para comparar el estado de las 
  tablas antes y después del comando que acciona la restricción.
*/

--D(A)-----------------------------------------------------------------------------

Select * from PROFESOR;


--D(B)-----------------------------------------------------------------------------

Select SiglaCurso, CedProf from GRUPO