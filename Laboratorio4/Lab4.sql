use C05126

/*
	Jose Andrés Matarrita Miranda   C04668
	Esteban José Mora García        C05126
*/

/*
	A. [33 pts.] Programe un procedimiento almacenado llamado “EmpadronarEstudiante” que
	empadrone a un estudiante en una carrera. Es decir, debe insertar una nueva tupla en la
	tabla Empadronado_En con base en los siguientes parámetros de entrada: la cédula del
	estudiante y el código de la carrera. Es posible que necesite parámetros adicionales,
	dependiendo de los campos que haya definido como not null cuando creó la tabla. Invoque
	el procedimiento y verifique que funciona correctamente. Puede invocar el procedimiento
	mediante este comando

	EXEC EmpadronarEstudiante @cod=codigo, @ced=cedula // en desorden
*/
create procedure EmpadronarEstudiante(@cod varchar(15), @ced varchar(15))
as
begin
	insert into EMPADRONADO_EN(CedEstudiante, CodCarrera, FechaIngreso, FechaGraduacion)
	values (@ced, @cod, null, null)
end;

-- Se elimina tupla de empadronado para probar el procedure
delete from Empadronado_En where CedEstudiante like '000000000'

-- Se ejecuta el procedure
EXEC EmpadronarEstudiante @cod='CA123', @ced='000000000';

-- Se muestra la tabla con el nuevo estudiante empadronado
select * from Empadronado_En

/*
	B. 34 pts.] Programe una función almacenada llamada “CreditosPorSemestre” que consulte
	la cantidad de créditos matriculados en un semestre por un estudiante. Los parámetros 
	de entrada son la cédula del estudiante, el semestre y el año (un “semestre” se define 
	como el semestre y el año, por ejemplo, el I semestre del 2020, o el II semestre del 2019). 
	El resultado de la consulta debe ser la cantidad total de créditos que el estudiante 
	matriculó cierto semestre. Invoque la función y verifique que funciona correctamente. 
	Puede invocar la función con este comando:
*/
GO
CREATE FUNCTION CreditosMatriculadosPorSemestre
(
    @cedula_estudiante VARCHAR(20),
    @semestre VARCHAR(1),
    @ano INT
)
RETURNS INT
AS
BEGIN
    DECLARE @creditos INT
    
    SELECT @creditos = SUM(Creditos)
    FROM LLEVA L
    INNER JOIN GRUPO G ON L.SiglaCurso = G.SiglaCurso AND L.NumGrupo = G.NumGrupo
    INNER JOIN CURSO C ON G.SiglaCurso = C.Sigla
    WHERE L.CedEstudiante = @cedula_estudiante AND G.Semestre = @semestre AND G.anio = @ano
    
    RETURN @creditos
END

GO

SELECT dbo. CreditosMatriculadosPorSemestre('123456789', 3, 2022) AS 'creditos_semestrales';

select * from LLEVA


/*
	C. [33 pts.] Programe un procedimiento almacenado llamado “ActualizarCreditos” que 
	aumente, en un porcentaje dado, los créditos de los cursos cuyo nombre contenga una 
	hilera dada por parámetro. Los parámetros de entrada son la hilera a buscar (dentro del
	nombre del curso) y el porcentaje de aumento. El resultado de invocar este procedimiento 
	debe ser que el creditaje de cada curso que calce con la hilera aumente en un P% (por 
	ejemplo, en un 30%, o en un 100%). Por ejemplo: si la hilera dada por parámetro es 
	“bases”, usted debe aumentar el creditaje de todos los cursos cuyo nombre contenga la 
	palabra “bases”. Si usted definió el atributo créditos (en el Lab2) como un entero, 
	entonces redondee el resultado al entero más cercano. Invoque el procedimiento y 
	verifique que funcione correctamente.
*/

create procedure ActualizarCreditos (@cursoPalabra as varchar(50), @porcentajeAumento as int)
as
begin
	update Curso
	set Creditos = round ((Creditos + ((Creditos * @porcentajeAumento)/100)), 0)
	where Nombre Like @cursoPalabra + '%'
end;

EXEC ActualizarCreditos @cursoPalabra='Historia', @porcentajeAumento='50';

select * from Curso;

