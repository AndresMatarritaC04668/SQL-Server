use C04668

/*
Andres Matarrita Miranda C04668
Esteban Mora Garcia C05126

1. Programe un disparador que implemente la siguiente restricción de negocio:
“Un estudiante no puede matricular más de 18 créditos por semestre”.
El sistema no debe permitir inserciones que generen una carga mayor a 18 créditos para un estudiante en un semestre.
Asuma que solo se inserta una tupla de Lleva a la vez. Hint: use la función almacenada creada en el Lab 4.
Pruebe el comportamiento del disparador en las siguientes condiciones:

i. Al insertar una tupla de la tabla Lleva que no sobrepasa el límite de 18 créditos para un estudiante en un semestre.
ii. Al insertar una tupla de la tabla Lleva que sobrepasa el límite de 18 créditos para un estudiante en un semestre.

*/

go 
CREATE TRIGGER trg_Lleva_MaxCreditos ON LLEVA
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CedEstudiante VARCHAR(20), @Semestre VARCHAR(1), @Año INT, @CargaCreditos INT , @CreditosActual int , @siglaCurso CHAR(10)

    SELECT @CedEstudiante = CedEstudiante, @Semestre = Semestre, @Año = Anno ,  @siglaCurso = SiglaCurso
    FROM inserted

	Select @CreditosActual = Creditos
	from Curso
	Where  Curso.Sigla = @siglaCurso

    SET @CargaCreditos = dbo.CreditosMatriculadosPorSemestre(@CedEstudiante, @Semestre, @Año)

    IF @CargaCreditos is null
	BEGIN
	     SET @CargaCreditos = 0
    END

    IF  @CreditosActual  is null
	BEGIN
	     SET  @CreditosActual  = 0
    END

    IF @CargaCreditos + @CreditosActual  > 18
    BEGIN
        PRINT 'Un estudiante no puede matricular más de 18 créditos por semestre.'     
    END

    ELSE
    BEGIN
        -- Realizar la inserción original
        INSERT INTO LLEVA (CedEstudiante, SiglaCurso, NumGrupo, Semestre, Anno, Nota)
        SELECT CedEstudiante, SiglaCurso, NumGrupo, Semestre, Anno, Nota
        FROM inserted
    END
END

go

select * from LLEVA

INSERT INTO LLEVA (CedEstudiante, SiglaCurso, NumGrupo, Semestre, Anno, Nota)
VALUES
    ('123456789', 'HA', 1, 3, 2022, 90),
   ('123456789', 'FA', 1, 3, 2022, 90),
   ('123456789', 'AA', 1, 3, 2022, 90);

	
Select * from Curso

Select * from LLEVA

SELECT dbo. CreditosMatriculadosPorSemestre('123456789', 3, 2022) AS 'creditos_semestrales'



/*

2. Analice si el disparador que programó en el ejercicio anterior funciona bien cuando se
insertan varias tuplas de la tabla Lleva a la vez (en un mismo comando SQL). Si su
disparador no maneja bien este caso, modifíquelo para que permita la inserción de varias
tuplas a la vez (considere usar cursores). Si su disparador maneja bien este caso, entonces
explique por qué funciona y además ofrezca evidencia de ello.
CI-0127, Bases de Datos, ECCI, UCR 2
En cualquier caso, pruebe el comportamiento del disparador en las siguientes condiciones:


i. Al insertar dos o más tuplas de la tabla Lleva que juntas no sobrepasan el límite de
18 créditos para un estudiante en un semestre.

ii. Al insertar dos o más tuplas de la tabla Lleva que juntas sobrepasan el límite de 18 
créditos para un estudiante en un semestre.

*/


go
CREATE TRIGGER trg_Lleva_MaxCreditos ON LLEVA
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CedEstudiante VARCHAR(20), @Semestre VARCHAR(1), @Año INT, @CargaCreditos INT, @CreditosActual INT, @siglaCurso CHAR(10)

    -- Cursor para recorrer las filas en "inserted"
    DECLARE cursorLleva CURSOR FOR
    SELECT CedEstudiante, Semestre, Anno, SiglaCurso
    FROM inserted

    OPEN cursorLleva

    -- Variables para almacenar los valores de cada tupla
    FETCH NEXT FROM cursorLleva INTO @CedEstudiante, @Semestre, @Año, @siglaCurso

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Obtener los valores necesarios para la validación
        SELECT @CreditosActual = Creditos
        FROM Curso
        WHERE Sigla = @siglaCurso

        SET @CargaCreditos = dbo.CreditosMatriculadosPorSemestre(@CedEstudiante, @Semestre, @Año)

        -- Validar la suma de créditos
        IF @CargaCreditos IS NULL
        BEGIN
            SET @CargaCreditos = 0
        END

        IF @CreditosActual IS NULL
        BEGIN
            SET @CreditosActual = 0
        END

        IF @CargaCreditos + @CreditosActual > 18
        BEGIN
            PRINT 'Un estudiante no puede matricular más de 18 créditos por semestre.'
        END
        ELSE
        BEGIN
            -- Realizar la inserción original para la tupla actual
            INSERT INTO LLEVA (CedEstudiante, SiglaCurso, NumGrupo, Semestre, Anno, Nota)
            SELECT CedEstudiante, SiglaCurso, NumGrupo, Semestre, Anno, Nota
            FROM inserted
           WHERE CedEstudiante = @CedEstudiante
            AND SiglaCurso = @siglaCurso
            AND Semestre = @Semestre
            AND Anno = @Año

        END

        FETCH NEXT FROM cursorLleva INTO @CedEstudiante, @Semestre, @Año, @siglaCurso
    END

    CLOSE cursorLleva
    DEALLOCATE cursorLleva
END

go

/*
3. Construya una vista virtual llamada “EstudiantesPorGrupo” que provea la siguiente información sobre cada grupo: 
(i) su sigla, número de grupo, semestre, año, y (ii) la cantidad de estudiantes matriculados en él. 
El atributo CantEstud es un atributo derivado de la entidad Grupo, según el diagrama ER (Figura 2),
lo que significa que no se almacena sino que se calcula. La vista permite entonces calcular el valor de dicho atributo,
contando la cantidad de estudiantes matriculados en cada grupo. 
Incluya en el reporte de laboratorio el comando SQL usado para crear la vista
*/

go

create view EstudiantesPorGrupo
as
select g.NumGrupo , g.SiglaCurso , g.Semestre , g.Anio , count(l.CedEstudiante) as CantEstu
from Grupo g , Lleva l 

where g.NumGrupo = l.NumGrupo and g.SiglaCurso = l.SiglaCurso and
                   g.Semestre = l.Semestre and g.Anio = l.Anno

group by g.NumGrupo , g.SiglaCurso , g.Semestre , g.Anio;

go

