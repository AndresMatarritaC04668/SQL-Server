Use C04668


/*
4. [50 pts] Cree uno o más disparadores que velen por el cumplimiento de la restricción
de disyunción en el ISA Persona-Profesor-Estudiante del ER de la Figura 2. En otras
palabras, se debe asegurar que una persona sólo exista en la tabla Profesor o
Estudiante, pero no en ambas. Suponga que solo se inserta una persona a la vez.
¿Qué tipo de disparador usaría: after o instead-of insert? ¿Podría usar cualquiera de
ellos en este caso o hay alguno que no funcione? Justifique su respuesta.

*/
go


--Disparador para la tabla Estudiante
CREATE TRIGGER asegurar_estudiante
ON Estudiante AFTER INSERT
AS
BEGIN
    DECLARE @num_rows INT;
    SELECT @num_rows = COUNT(*) FROM Profesor WHERE Cedula = (SELECT Cedula FROM INSERTED);
    IF @num_rows > 0
    BEGIN
        DELETE FROM Estudiante WHERE Cedula = (SELECT Cedula FROM INSERTED);
        Print 'La cédula ya existe en la tabla Profesor'
    END
END;
go


go
--Disparador para la tabla Profesor
CREATE TRIGGER asegurar_Profesor
ON Profesor AFTER INSERT
AS
BEGIN
    DECLARE @num_rows INT;
    SELECT @num_rows = COUNT(*) FROM Estudiante WHERE Cedula = (SELECT Cedula FROM INSERTED);
    IF @num_rows > 0
    BEGIN
        DELETE FROM Profesor WHERE Cedula = (SELECT Cedula FROM INSERTED);
        Print 'La cédula ya existe en la tabla Estudiante'
    END
END;

go

select * from ESTUDIANTE
select * from Profesor

insert into ESTUDIANTE(Cedula, NombreP, Apellido1, Apellido2, Email, Sexo, FechaNac, Direccion
						, Telefono, Carne, Estado)
values ('99999999', 'Vanessa', 'Matamoros', 'Morales', 'morales@.com', 'F', '2000-12-20', 'Hatillo', '85659204', 'B2', 'activo');

insert into PROFESOR(Cedula, Email, NombreP, Apellido1, Apellido2, Sexo, FechaNac, Direccion, Telefono
					, Categoria, FechaNomb, Titulo, Oficina)
values ('111111111', 'ferxxo@.com', 'Feid', 'Figueres', 'Arias', 'M', '1998-01-01', 'Desamparados', '55555555', 'interino'
			, '2022-01-01', 'Doctorado', '07');



----------------------------------------------------------------------------------------------------------------------------------------



GO

CREATE TRIGGER eliminar_Tuplas_Empadronado_En_i
ON Carrera iNSTEAD OF  DELETE
AS
BEGIN
    DELETE FROM EMPADRONADO_EN WHERE CodCarrera IN (SELECT Codigo FROM DELETED);  
    DELETE FROM Carrera WHERE Codigo IN (SELECT Codigo FROM DELETED);
END;


GO

DROP TRIGGER eliminar_Tuplas_Empadronado_En_i

select * from empadronado_en

select * from carrera

Delete from CARRERA where CARRERA.Codigo = 'CA123';






