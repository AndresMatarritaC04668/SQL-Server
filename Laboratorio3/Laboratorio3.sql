use BD_Universidad;
-- Andres Matarrita Miranda C04668
-- Esteban Mora Garcia C05126
/*
 C. Escriba las siguientes consultas en SQL, tomando como referencia las Figuras 1 y 2 al final de
esta guía. En todas estas consultas es necesario unir la información de más de dos tablas. En
Microsoft SQL Server, un join de tres tablas tiene la siguiente forma general:
SELECT * FROM tabla1 t1 JOIN tabla2 t2 ON t1.a = t2.b JOIN tabla3 t3 ON t3.c = t2.c

*/


/*
  C1.Recupere el nombre y primer apellido de los asistentes, y el nombre de los cursos que
han asistido. Si un asistente ha asistido varias veces un mismo curso, el curso sólo debe
aparecer una vez en el resultado.
*/

SELECT Distinct Estudiante.NombreP as NombreAsistente , Estudiante.Apellido1 as ApellidoAsistente ,CURSO.Nombre as NombreCurso 
FROM ASISTENTE
JOIN Estudiante ON  Asistente.Cedula = Estudiante.Cedula 
JOIN GRUPO ON ASISTENTE.Cedula = GRUPO.CedAsist
JOIN CURSO ON GRUPO.SiglaCurso = CURSO.Sigla


/*
  C2. Recupere la sigla, el número de grupo, el semestre, el año y la nota de todos los cursos
que ha matriculado el estudiante ‘Cristian Matamoros’. 
*/

Select Distinct G.SiglaCurso, G.NumGrupo , G.Semestre ,  G.Anno , L.Nota
from Estudiante E
Join Lleva L ON E.Cedula = L.CedEstudiante
Join Grupo G ON L.SiglaCurso = G.SiglaCurso AND L.NumGrupo = G.NumGrupo AND L.Semestre = G.Semestre AND L.Anno = G.Anno
Where NombreP = 'Cristian' AND Apellido1 = 'Matamoros';



/*
  C3.Para los profesores que participan en proyectos de investigación, recupere el nombre
del profesor, el nombre del proyecto y el nombre de la escuela en la que trabaja.
*/

  Select Distinct  Profe.NombreP as NombreProfesor , I.Nombre as NombreProyecto , E.Nombre as NombreEscuela
  from Profesor Profe
  Join Participa_En Participa ON Profe.Cedula = Participa.CedProf
  Join Investigacion I ON Participa.NumProy = I.NumProy
  Join Trabaja_En T ON  Profe.Cedula = T.CedProf
  Join Escuela E ON T.CodEscuela = E.Codigo





  /*
   D. Escriba las siguientes consultas en SQL, tomando como referencia las Figuras 1 y 2 al final de
esta guía. Para estas consultas es necesario agrupar la información de la(s) tabla(s). En Microsoft
SQL Server, para agrupar datos se usa la cláusula GROUP BY. Algunas veces se requiere filtrar 
sobre los grupos creados, para lo cual se usa la cláusula HAVING (funciona de forma similar al 
WHERE, pero en lugar de filtrar registros, el HAVING filtra grupos después de aplicar el 
GROUP BY). También es usual combinar el agrupamiento de datos con funciones de 
agregación, tales como max, count, sum, etc

  */

  /*
  D1. Recupere la cantidad de profesores por grado académico (título). Ordene el resultado
por cantidad de profesores, de mayor a menor.
  */

  Select count(P.Cedula) as CantidadProfesores, P.Titulo
  from Profesor P
  Group by (P.Titulo)
  Order by count(P.Cedula) DESC;

  /*
    D2. Calcule el promedio de notas de cada estudiante. El reporte debe listar la cédula del 
estudiante en la primera columna y su promedio en la segunda columna, ordenado por 
cédula.
  */

  Select  L.CedEstudiante, AVG(L.Nota) as PromedioNota
  from Lleva L
  Group by (L.CedEstudiante)
  Order by L.CedEstudiante;

  /*
	D3. Para cada proyecto de investigación, obtenga el total de carga asignada al proyecto (la
suma de la carga de cada uno de sus participantes).
  */
  select i.Nombre, sum(p.Carga) as totalCarga
  from Investigacion i 
  join Participa_en p on i.NumProy = p.NumProy
  group by (i.Nombre);

  /*
    D4.Para aquellos cursos que pertenecen a más de 2 carreras, recupere la sigla del curso y la 
cantidad de carreras que tienen ese curso en su plan de estudios. 
  */

  Select P.SiglaCurso , Count(P.CodCarrera) CantidadCarreras
  from Pertenece_a P
  Group By (P.SiglaCurso)
  Having Count(*) > 2;

  /*
	D5. Para todas las facultades, recupere el nombre de la facultad y la cantidad de carreras que
posee. Si hay facultades que no poseen escuelas o carreras, deben salir en el listado con
cero en la cantidad de carreras. Ordene descendentemente por cantidad de carreras (de
la facultad que tiene más carreras la que tiene menos).
  */
  -- inge 7 ciencias 1 otro 0
  select f.nombre, count(c.Nombre) as CantidadCarreras 
  from Facultad f
  left join Escuela e on e.CodFacultad = f.Codigo
  left join Carrera c on c.CodEscuela = e.Codigo
  group by (f.nombre)
  order by count(c.Nombre) desc;

  /*
	D6. Liste la cantidad de estudiantes matriculados en cada grupo de cursos de computación
(sigla inicia con el prefijo “CI”). Se debe mostrar el número de grupo, la sigla de curso, el
semestre y el año de cada grupo, además de la cantidad de estudiantes matriculados en
él. Si hay grupos que no tienen estudiantes matriculados, deben salir en el listado con
cero en la cantidad de estudiantes. Ordene por año, luego por semestre, y finalmente
por sigla y grupo
  */
  select g.NumGrupo, g.SiglaCurso, g.Semestre, g.Anno, count(e.Cedula) as CantidadEstudiantes
  from Grupo g
  left join Lleva l on g.SiglaCurso = l.SiglaCurso
  left join Estudiante e on l.CedEstudiante = e.Cedula
  where  g.SiglaCurso like 'CI____'
  group by g.NumGrupo, g.SiglaCurso, g.Semestre, g.Anno
  order by g.Anno, g.Semestre, g.SiglaCurso, g.NumGrupo;

  /*
  D7. Liste los grupos (identificados por sigla de curso, número de grupo, semestre y año)
donde la nota mínima obtenida por los estudiantes fue mayor o igual a 70 (es decir, todos
los estudiantes aprobaron). Muestre también la nota mínima, máxima, y promedio de
cada grupo en el resultado. Ordene el resultado descendentemente por el promedio de
notas del grupo
  */
  select g.SiglaCurso, g.NumGrupo, g.Semestre, g.Anno, min(l.Nota) as notaMínima
		, max(l.Nota) as notaMáxima, avg(l.Nota) as Promedio
  from Grupo g
  join Lleva l on g.SiglaCurso = l.SiglaCurso
  group by g.SiglaCurso, g.NumGrupo, g.Semestre, g.Anno
  having min(l.Nota) >= 70
  order by avg(l.Nota) desc;

