USE funcionesTarea;

CREATE TABLE persona(
	personaID INT PRIMARY KEY AUTO_INCREMENT,
    fecha_nacimiento DATE);

DELIMITER //
CREATE FUNCTION CalcularEdad(fecha_nacimiento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE edad INT;
    SET edad= TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
    RETURN edad;
END //

DELIMITER ;