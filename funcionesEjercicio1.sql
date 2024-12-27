CREATE DATABASE funcionesTarea;
USE funcionesTarea;

CREATE TABLE ordenes (
    OrdenID INT PRIMARY KEY,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES Productos(productoID)
);

CREATE TABLE productos (
    productoID INT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    precio DECIMAL(10,2) NOT NULL
);

DELIMITER //
CREATE FUNCTION CalcularTotalOrden(id_orden INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE total DECIMAL(8, 2);
    DECLARE iva DECIMAL(8, 2);
    
    SET iva = 0.15;
    
    SELECT SUM(P.precio * O.cantidad) INTO total
    FROM ordenes o
    JOIN Productos P ON O.producto_id = P.ProductoID
    WHERE O.OrdenID = id_orden;
    
    SET total = total + (total*iva);
    
    RETURN total;
END //
DELIMITER ;