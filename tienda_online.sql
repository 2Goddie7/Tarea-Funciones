CREATE DATABASE tienda_online;
USE tienda_online;
-- CREACION DE LA TABLA CLIENTES CON LAS RESTRICCIONES DEL PUNTO 2
CREATE TABLE clientes(
    clienteID INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    telefono VARCHAR(10),
    fechaRegistro DATE
);
-- CREACION DE LA TABLA PRODUCTOS CON LAS RESTRICCIONES DEL PUNTO 2
CREATE TABLE productos(
    productoID INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    precio DECIMAL(10,2) NOT NULL CHECK (precio > 0),
    stock INT NOT NULL CHECK (stock >= 0),
    descripcion VARCHAR(120)
);
-- CREACION DE LA TABLA PEDIDOS CON LAS RESTRICCIONES DEL PUNTO 2
CREATE TABLE pedidos (
    pedidoID INT PRIMARY KEY AUTO_INCREMENT,
    clienteID INT NOT NULL,
    FOREIGN KEY (clienteID) REFERENCES clientes(clienteID),
    fechaPedido DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0)
);
-- CREACION DE LA TABLA DETALLEPEDIDOS CON LAS RESTRICCIONES DEL PUNTO 2
CREATE TABLE detallePedidos(
    detalleID INT PRIMARY KEY AUTO_INCREMENT,
    pedidoID INT NOT NULL,
    FOREIGN KEY (pedidoID) REFERENCES pedidos(pedidoID),
    productoID INT NOT NULL,
    FOREIGN KEY (productoID) REFERENCES productos(productoID),
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precioUnitario DECIMAL(10,2) NOT NULL CHECK (precioUnitario > 0));
-- CREACION DE LA FUNCION PARA OBTENER EL NMBRE COMPLETO DE UN CLIENTE POR SU ID
DELIMITER //
CREATE FUNCTION obtenerNombreCompleto(cliente_id INT) 
RETURNS VARCHAR(160)
DETERMINISTIC
BEGIN
    DECLARE nombreCompleto VARCHAR(160);
    SELECT CONCAT(nombre, ' ', apellido) 
    INTO nombreCompleto 
    FROM clientes 
    WHERE clienteID = cliente_id;
    RETURN nombreCompleto;
END//
DELIMITER ;
-- FUNCION PARA CALCULAR EL DESCUENTO DE UN PRODUCTO
DELIMITER //
CREATE FUNCTION calcularDescuento(precio DECIMAL(10,2), descuento DECIMAL(5,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN precio - (precio * descuento / 100);
END//
DELIMITER ;
-- FUNCION PARA CALCULAR EL TOTAL DE UN PEDIDO
DELIMITER //
CREATE FUNCTION calcularTotalPedido(pedido_id INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(cantidad * precioUnitario) 
    INTO total 
    FROM detallePedidos 
    WHERE pedidoID = pedido_id;
    RETURN total;
END//
DELIMITER ;
-- FUNCION PARA VERIFICAR EL STOCK DE UN PRODUCTO
DELIMITER //
CREATE FUNCTION verificarStock(producto_id INT, cantidad INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE disponible INT;
    SELECT stock 
    INTO disponible 
    FROM productos 
    WHERE productoID = producto_id;
    RETURN disponible >= cantidad;
END//
DELIMITER ;
-- FUNCION PARA CALCULAR LA ANTIGUEDAD DE UN CLIENTE
DELIMITER //
CREATE FUNCTION calcularAntiguedadCliente(cliente_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE antiguedad INT;
    SELECT TIMESTAMPDIFF(YEAR, fechaRegistro, CURDATE()) 
    INTO antiguedad 
    FROM clientes 
    WHERE clienteID = cliente_id;
    RETURN antiguedad;
END//
DELIMITER ;

-- CONSULTAS 

SELECT obtenerNombreCompleto(1) AS nombreCompleto;

SELECT calcularDescuento(100.00, 10) AS precioConDescuento;

SELECT calcularTotalPedido(1) AS totalPedido;

SELECT verificarStock(1, 5) AS tieneSuficienteStock;
