/*
	Laboratorio 1
	Jose Andrés Matarrita Miranda C04668
	Esteban José Mora García C05126
*/

use BD_Universidad

/*
1. Abra la aplicación SQL Server Management Studio. En la ventana de conexión debe
seleccionar las opciones ‘Database Engine’ y ‘SQL Authentication’ y escribir la dirección
IP 172.16.202.209 en el campo ‘Nombre del servidor’.
*/
Select nombre,AnnoCreacion
From Carrera;

/*
b. Recupere la cédula, el nombre completo, y la categoría de los profesores que han
impartido el curso ‘CI1221’. ¿Le salen registros repetidos? En caso de que el
resultado tenga registros duplicados, explique por qué se da esto, e indique cómo
tendría que modificar la consulta para evitar este problema?
*/

-- Si me salen registros repetidos
select Cedula, NombreP, Apellido1, Apellido2, Categoria
from Profesor join Grupo on Cedula = CedProf
where SiglaCurso like 'CI1221';

/*
  salen repetidos esto es debido a un profesor se le ha asignado el curso
  CI1221 varias veces en distintos annos
*/

select Cedula, NombreP, Apellido1, Apellido2, Categoria, Semestre, Anno
from Profesor join Grupo on Cedula = CedProf
where SiglaCurso like 'CI1221';

-- La forma de que no salan duplicados seria utilizando un selec distinct
select distinct Cedula, NombreP, Apellido1, Apellido2, Categoria
from Profesor join Grupo on Cedula = CedProf
where SiglaCurso like 'CI1221';

/*
c. Recupere el número de carné , el nombre completo, y la nota de los estudiantes
que han obtenido entre 55 y 75 de calificación en cualquier curso. Ordene el
resultado por orden descendiente de Nota.
*/
select Estudiante.Carne,NombreP,Apellido1,Apellido2,Nota
From   Estudiante join Lleva on Cedula = CedEstudiante
where nota BETWEEN 55 AND  75
order by nota;

/*
d. Recupere la sigla de los cursos que son requisito del curso ‘CI1312’.
*/
select Sigla
from Curso join Requiere_De on Sigla = SiglaCursoRequisito
where SiglaCursoRequeridor like 'CI1312';

/*
e. Recupere la nota máxima, la nota mínima y el promedio de notas obtenidas en el
curso ‘CI1221’. Esto debe hacerse en una misma consulta. Dele nombre a las
columnas del resultado mediante alias.
*/
select max(nota) as maxima ,min(nota) as minima,avg(nota) as promedio
from Lleva
where SiglaCurso Like 'CI1221';

/*
f. Recupere el nombre de las Escuelas y el nombre de todas sus Carreras, ordenadas
por nombre de Escuela y luego por nombre de Carrera.
*/
select E.Nombre, C.Nombre 
from Escuela E join Carrera C on E.Codigo = C.CodEscuela
order by E.Nombre, C.Nombre;

/*
g. Recupere la cantidad de profesores que trabajan en la Escuela de Computación e
Informática. Suponga que no conoce el código de esta escuela, solo su nombre.
*/
select count(DISTINCT CedProf) as Cantidad
from Trabaja_en
join Escuela as E
on CodEscuela = E.Codigo
where E.nombre = 'Escuela de Computación e Informática';

/*
h. Recupere la cédula de los estudiantes que no están empadronados en ninguna
carrera.
*/
select Cedula
from Estudiante
except
select CedEstudiante
from Empadronado_en;

/*
i. Recupere la sigla, el número de grupo, el semestre y el año de todos los grupos, su
asistente (indique solo la cédula del asistente) y la cantidad de horas que el
asistente tiene asignadas al grupo. Si un grupo no tiene asistente, de igual forma
debe salir en el resultado de la consulta (con el asistente y las horas de asistencia
en NULL). ¿Qué tipo de join es necesario usar aquí y por qué?
*/
select g.SiglaCurso, g.NumGrupo, g.Semestre, g.Anno, a.Cedula, a.NumHoras
from GRUPO g
left  join ASISTENTE a
on g.CedAsist = a.Cedula;

/*
Un LEFT JOIN se utiliza en este caso porque queremos que aparezcan todos los grupos, 
incluso aquellos que no tienen asignado un asistente. Si usáramos un INNER JOIN, 
solo aparecerían los grupos que tienen un asistente asignado. Al utilizar un LEFT JOIN,
se devolverán todas las filas de la tabla GRUPO, con la información correspondiente de la 
tabla ASISTENTE cuando exista una coincidencia. Si no hay una coincidencia, 
la información correspondiente de la tabla ASISTENTE aparecerá como NULL.
*/

/*
j. Recupere el nombre de los estudiantes cuyo primer apellido termina en ‘a’. ¿Cómo
cambiaría la consulta para incluir también a los estudiantes cuyo nombre inicia con
‘M’? ¿Cómo cambiaría la consulta para que solo recupere los estudiantes cuyo
primer apellido inicia con ‘M’ y termina con ‘a’?
*/

-- Estudiantes que su primer apellido termina en 'a'
select NombreP, Apellido1, Apellido2
from Estudiante
where right(Apellido1, 1) like 'a';

-- Para estudiantes que inician con 'M'
select NombreP, Apellido1, Apellido2
from Estudiante
where right(Apellido1, 1) like 'a' or left(NombreP, 1) like 'M';

-- Estudiantes que el primer apellido inicie con 'M' y termine con 'a'
select NombreP, Apellido1, Apellido2
from Estudiante
where right(Apellido1, 1) like 'a' and left(Apellido1, 1) like 'M';

/*
k. Recupere el nombre de los estudiantes cuyo nombre tiene exactamente 6
caracteres.
*/
select  NombreP as NombreEstudiante
from Estudiante
where NombreP like '______';

/*
l. Liste el nombre completo de los profesores y de los estudiantes de género
masculino (el resultado debe salir en una sola lista consolidada).
*/

(select NombreP, Apellido1, Apellido2
from Estudiante
where Sexo like 'm')
union
(select NombreP, Apellido1, Apellido2
from Profesor
where Sexo like 'm')

/*
m. Recupere el carné y nombre completo de los estudiantes para los cuales no existe
un número de teléfono registrado
*/
select carne , nombreP,Apellido1,Apellido2
from Estudiante
where Teléfono is null
