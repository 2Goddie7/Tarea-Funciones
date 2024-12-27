USE funcionesTarea;

CREATE TABLE cuentas(
	cuenta_id INT PRIMARY KEY AUTO_INCREMENT,
    saldo DECIMAL(10,2) CHECK(saldo>=0));
    
CREATE TABLE transacciones(
	transaccionID INT PRIMARY KEY AUTO_INCREMENT,
    tipo_transaccion ENUM('deposito','retiro'));

DELIMITER //
CREATE FUNCTION CalcularSaldo(id_cuenta INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
	DECLARE saldo DECIMAL(10,2);
    
    SELECT SUM(CASE
		WHEN tipo_transaccion = 'deposito' THEN monto
        WHEN tipo_transaccion = 'retiro' THEN -monto
        ELSE 0
    END) INTO saldo
    FROM transacciones
    WHERE cuenta_id = id_cuenta;
    
    RETURN saldo;
END //
DELIMITER ;