USE funcionesTarea;

CREATE TABLE Productos2 (
    productoID INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0)  -- Asegura que el stock no sea negativo
);

INSERT INTO Productos2 (nombre, precio, stock) VALUES 
		('Chocolates', 0.50, 10),
		('Queso', 1.50, 0),
		('Arroz', 0.70, 5);

DELIMITER //
CREATE FUNCTION VerificarStock(producto_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE stock INT;
    SELECT stock INTO stock
    FROM Productos
    WHERE productoID = producto_id;

    IF stock > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END //
DELIMITER ;