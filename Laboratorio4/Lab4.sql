use C05126

/*
	Jose Andr�s Matarrita Miranda   C04668
	Esteban Jos� Mora Garc�a        C05126
*/

/*
	A. [33 pts.] Programe un procedimiento almacenado llamado �EmpadronarEstudiante� que
	empadrone a un estudiante en una carrera. Es decir, debe insertar una nueva tupla en la
	tabla Empadronado_En con base en los siguientes par�metros de entrada: la c�dula del
	estudiante y el c�digo de la carrera. Es posible que necesite par�metros adicionales,
	dependiendo de los campos que haya definido como not null cuando cre� la tabla. Invoque
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
	B. 34 pts.] Programe una funci�n almacenada llamada �CreditosPorSemestre� que consulte
	la cantidad de cr�ditos matriculados en un semestre por un estudiante. Los par�metros 
	de entrada son la c�dula del estudiante, el semestre y el a�o (un �semestre� se define 
	como el semestre y el a�o, por ejemplo, el I semestre del 2020, o el II semestre del 2019). 
	El resultado de la consulta debe ser la cantidad total de cr�ditos que el estudiante 
	matricul� cierto semestre. Invoque la funci�n y verifique que funciona correctamente. 
	Puede invocar la funci�n con este comando:
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
	C. [33 pts.] Programe un procedimiento almacenado llamado �ActualizarCreditos� que 
	aumente, en un porcentaje dado, los cr�ditos de los cursos cuyo nombre contenga una 
	hilera dada por par�metro. Los par�metros de entrada son la hilera a buscar (dentro del
	nombre del curso) y el porcentaje de aumento. El resultado de invocar este procedimiento 
	debe ser que el creditaje de cada curso que calce con la hilera aumente en un P% (por 
	ejemplo, en un 30%, o en un 100%). Por ejemplo: si la hilera dada por par�metro es 
	�bases�, usted debe aumentar el creditaje de todos los cursos cuyo nombre contenga la 
	palabra �bases�. Si usted defini� el atributo cr�ditos (en el Lab2) como un entero, 
	entonces redondee el resultado al entero m�s cercano. Invoque el procedimiento y 
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

