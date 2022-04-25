-- M3 Sprint Final Grupo 3

/*mode safe requiere WHERE, entonces debemos setear: SET SQL_SAFE_UPDATES = 0;
si queremos usar DELETE por ejemplo*/

/*En root realizamos:*/
/*Eliminar DB si existe*/
DROP DATABASE IF EXISTS telovendo;
/*Creamos base de datos con su respectiva codificación*/
CREATE DATABASE telovendo DEFAULT CHARACTER SET utf8mb4;

/***
Deben crear un usuario con privilegios para crear, eliminar y modificar tablas, insertar registros.
***/
CREATE USER 'newuser'@'localhost' IDENTIFIED BY '123456';

/*GRANT CREATE, DROP, ALTER, INSERT ON telovendo.* TO 'newuser'@'localhost';*/

/*Usuario con privilegio total sobre la base de datos telovendo*/

GRANT ALL PRIVILEGES ON telovendo.* TO 'newuser'@'localhost';

FLUSH PRIVILEGES;
-- Se observa que se añade el nuevo usuario.
SELECT user FROM mysql.user;
-- DROP USER 'newuser'@'localhost';

SHOW DATABASES;
-- Usamos la base de datos creada.
USE telovendo;
-- Mostramos las tablas que posee nuestra base de datos.
SHOW TABLES FROM telovendo;

/*En newuser: realizamos */
/***
TeLoVendo recibe productos de diferentes proveedores para comercializarlos. Cada proveedor debe
informarnos el nombre del representante legal, su nombre corporativo, al menos dos teléfonos de
contacto (y el nombre de quien recibe las llamadas), la categoría de sus productos (solo nos pueden
indicar una categoría) y un correo electrónico para enviar la factura. Sabemos que la mayoría de los
proveedores son de productos electrónicos. Agregue 5 proveedores a la base de datos. En general, los
proveedores venden muchos productos.
***/

-- Creación tabla proveedor
DROP TABLE IF EXISTS telovendo.proveedor;
CREATE TABLE telovendo.proveedor(
proveedor_id  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
nombre_representante_legal VARCHAR(100) NOT NULL,
nombre_corporativo VARCHAR(100) NOT NULL,
PRIMARY KEY (proveedor_id)
) DEFAULT CHARSET=utf8mb4;
DESCRIBE telovendo.proveedor;

/*
- Nos piden al menos 2 telefonos, por lo que pudieran requerir 3,4 ... por ello separamos el contacto telefonico asociado al proveedor. 
- Que se ingresen al menos 2 telefonos se manejara a nivel de insert o interfaz
*/
-- Creación tabla contacto
DROP TABLE IF EXISTS telovendo.contacto;
CREATE TABLE telovendo.contacto(
contacto_id  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
telefono BIGINT,
receptor_llamada VARCHAR(100),
proveedor_id SMALLINT UNSIGNED NOT NULL,
PRIMARY KEY (contacto_id),
UNIQUE (proveedor_id,telefono),
CONSTRAINT contacto_ibfk_1  FOREIGN KEY (proveedor_id) REFERENCES telovendo.proveedor (proveedor_id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8mb4;
DESCRIBE telovendo.contacto;

/*datos_factura podria tener varios detalles más por ello la separamos en una tabla, para el caso del ejercicio que solo pide guardar 1 correo podria ir 
solo en la tabla proveedor y no crear la tabla datos_factura*/
-- Creación tabla datos_factura
DROP TABLE IF EXISTS telovendo.datos_factura;
CREATE TABLE telovendo.datos_factura(
datos_factura_id  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
correo_electronico VARCHAR(255) NOT NULL,
proveedor_id SMALLINT UNSIGNED NOT NULL,
PRIMARY KEY (datos_factura_id),
UNIQUE (proveedor_id), /*dejamos unique el proveedor_id para que solo exista un correo por proveedor como es solicitado en el documento del ejercicio*/
CONSTRAINT datos_factura_ibfk_1  FOREIGN KEY (proveedor_id) REFERENCES telovendo.proveedor (proveedor_id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8mb4;
DESCRIBE telovendo.datos_factura;

SHOW TABLES FROM telovendo;

-- Insertamos 5 proveedores
INSERT INTO telovendo.proveedor (proveedor_id,nombre_representante_legal,nombre_corporativo ) VALUES (1,'Ana Alvarez','Vita Chips');
INSERT INTO telovendo.contacto (contacto_id, telefono, receptor_llamada, proveedor_id) VALUES (1,912345001,'Anatonieta Alamo',1);  
INSERT INTO telovendo.contacto (contacto_id, telefono, receptor_llamada, proveedor_id) VALUES (2,987654011,'Amanda Almagro',1); 
INSERT INTO telovendo.datos_factura (datos_factura_id, correo_electronico, proveedor_id) VALUES (1, 'aa@dominio.cl',1);

INSERT INTO telovendo.proveedor (proveedor_id,nombre_representante_legal,nombre_corporativo ) VALUES (2,'Benito Baranda','innovaTECH');
INSERT INTO telovendo.contacto (contacto_id, telefono, receptor_llamada, proveedor_id) VALUES (3,912345002,'Borja Boris',2);  
INSERT INTO telovendo.contacto (contacto_id, telefono, receptor_llamada, proveedor_id) VALUES (4,987654022,'Blanca Beltran',2); 
INSERT INTO telovendo.datos_factura (datos_factura_id, correo_electronico, proveedor_id) VALUES (2, 'bb@dominio.cl',2);

INSERT INTO telovendo.proveedor (proveedor_id,nombre_representante_legal,nombre_corporativo ) VALUES (3,'Carla Castro','Tecnologías OGX');
INSERT INTO telovendo.contacto (contacto_id, telefono, receptor_llamada, proveedor_id) VALUES (5,912345003,'Camilo Cordova',3);  
INSERT INTO telovendo.contacto (contacto_id, telefono, receptor_llamada, proveedor_id) VALUES (6,987654033,'Claudio Cortez',3); 
INSERT INTO telovendo.datos_factura (datos_factura_id, correo_electronico, proveedor_id) VALUES (3, 'cc@dominio.cl',3);

INSERT INTO telovendo.proveedor (proveedor_id,nombre_representante_legal,nombre_corporativo ) VALUES (4,'Daniel Davila','TodoAqui');
INSERT INTO telovendo.contacto (contacto_id, telefono, receptor_llamada, proveedor_id) VALUES (7,912345004,'David Davalos',4);  
INSERT INTO telovendo.contacto (contacto_id, telefono, receptor_llamada, proveedor_id) VALUES (8,987654044,'Danitza Duran',4); 
INSERT INTO telovendo.datos_factura (datos_factura_id, correo_electronico, proveedor_id) VALUES (4, 'aa@dominio.cl',4);

INSERT INTO telovendo.proveedor (proveedor_id,nombre_representante_legal,nombre_corporativo ) VALUES (5,'Eugenio Ercilla','Futuramax');
INSERT INTO telovendo.contacto (contacto_id, telefono, receptor_llamada, proveedor_id) VALUES (9,912345005,'Emilio Enriquez',5);  
INSERT INTO telovendo.contacto (contacto_id, telefono, receptor_llamada, proveedor_id) VALUES (10,987654055,'Esteban Encina',5); 
INSERT INTO telovendo.datos_factura (datos_factura_id, correo_electronico, proveedor_id) VALUES (5, 'aa@dominio.cl',5);

-- Mostramos los datos ingresados
SELECT * FROM telovendo.proveedor 
INNER JOIN telovendo.contacto ON proveedor.proveedor_id=contacto.proveedor_id
INNER JOIN telovendo.datos_factura ON proveedor.proveedor_id=datos_factura.proveedor_id;

/***
TeLoVendo tiene actualmente muchos clientes, pero nos piden que ingresemos solo 5 para probar la
nueva base de datos. Cada cliente tiene un nombre, apellido, dirección (solo pueden ingresar una).
***/
-- Creación tabla cliente
DROP TABLE IF EXISTS telovendo.cliente;
CREATE TABLE telovendo.cliente(
cliente_id  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
nombre VARCHAR(100) NOT NULL,
apellido VARCHAR(100) NOT NULL,
direccion VARCHAR(100) NOT NULL,
PRIMARY KEY (cliente_id)
) DEFAULT CHARSET=utf8mb4;
DESCRIBE telovendo.cliente;

-- Insertamos 5 clientes
INSERT INTO telovendo.cliente (cliente_id,nombre,apellido,direccion) VALUES 
(NULL, 'Alvaro','Alerce','Avenida los Almendros 1010'),
(NULL, 'Bastian','Bonilla','Avenida los Bosques 2020'),
(NULL, 'Carmelita','Carcuro','Avenida las Camelias 3030'),
(NULL, 'Danitza','Dominguez','Avenida los Duraznos 4040'),
(NULL, 'Efrain','Edwards','Avenida los Esmeraldas 5050');

-- Mostramos los datos ingresados
SELECT * FROM telovendo.cliente;

/***
TeLoVendo tiene diferentes productos. Ingrese 10 productos y su respectivo stock. Cada producto tiene
información sobre su precio, su categoría, proveedor y color. Los productos pueden tener muchos
proveedores.
***/
-- tabla categoria
DROP TABLE IF EXISTS telovendo.categoria;
CREATE TABLE telovendo.categoria(
categoria_id  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
nombre_categoria VARCHAR(100) NOT NULL,
PRIMARY KEY (categoria_id),
UNIQUE (nombre_categoria)
) DEFAULT CHARSET=utf8mb4;
DESCRIBE telovendo.categoria;

-- Insertamos 10 categorias 
INSERT INTO telovendo.categoria (categoria_id,nombre_categoria) VALUES
(1,'consolas de video juegos'),
(2,'juegos para consolas'),
(3,'electrónica y computación'),
(4,'instrumentos de vigilancia y control'),
(5,'aparato de alumbrados'),
(6,'juguetes electrónicos'),
(7,'telefonia');

-- Mostramos los datos ingresados
SELECT * FROM telovendo.categoria;

-- tabla producto
DROP TABLE IF EXISTS telovendo.producto;
CREATE TABLE telovendo.producto(
producto_id  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
nombre_producto VARCHAR(100) NOT NULL,
precio INT UNSIGNED NOT NULL,
color VARCHAR(50) NOT NULL,
stock INT UNSIGNED NOT NULL,
categoria_id SMALLINT UNSIGNED NOT NULL, 
PRIMARY KEY (producto_id),
CONSTRAINT categoria_ibfk_1  FOREIGN KEY (categoria_id) REFERENCES telovendo.categoria (categoria_id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8mb4;
DESCRIBE telovendo.producto;

-- tabla producto_x_proveedor
DROP TABLE IF EXISTS telovendo.producto_x_proveedor;
CREATE TABLE telovendo.producto_x_proveedor(
producto_x_proveedor_id  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
producto_id SMALLINT UNSIGNED NOT NULL, 
proveedor_id SMALLINT UNSIGNED NOT NULL, 
PRIMARY KEY (producto_x_proveedor_id),
CONSTRAINT producto_x_proveedor_ibfk_1  FOREIGN KEY (producto_id) REFERENCES telovendo.producto (producto_id) ON DELETE CASCADE,
CONSTRAINT producto_x_proveedor_ibfk_2  FOREIGN KEY (proveedor_id) REFERENCES telovendo.proveedor (proveedor_id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8mb4;
DESCRIBE telovendo.producto;

-- Insertamos 10 productos
INSERT INTO telovendo.producto(producto_id, nombre_producto, precio, color, stock, categoria_id) VALUES
(1,'nintendo switch', 350000, 'azul',100, 1),
(2,'play 4', 500000, 'negro',50, 1),
(3,'xbox one', 600000, 'negro',60, 1),
(4,'play 5', 700000, 'blanca',70, 1),
(5,'labtop 14 pulgadas', 1000000, 'gris',80, 3),
(6,'set camaras de vigilancia', 200000, 'blanco',20, 4),
(7,'auto electrico', 1000, 'rojo',10, 6),
(8,'tolva electrica', 9000, 'amarillo',90, 6),
(9,'celular noke', 300000, 'rojo',30, 7),
(10,'celular Androple', 400000, 'dorado',40, 7);

-- insertamos la relacion producto_x_proveedor
INSERT INTO telovendo.producto_x_proveedor (producto_x_proveedor_id, producto_id, proveedor_id) VALUES 
/*1='consolas de video juegos' son del proveedor 5='Futuramax'*/
(NULL,1,5),
(NULL,2,5),
(NULL,3,5),
(NULL,4,5),
/*3='electrónica y computación' son del proveedor 2='innovaTECH''*/
(NULL,5,2),
/*4='instrumentos de vigilancia y control' son del proveedor 3= 'Tecnologías OGX'*/
(NULL,6,3),
/*6='juguetes electronicos' son del proveedor 4='TodoAqui'*/
(NULL,7,4),
(NULL,8,4),
/*7='telefonia' son del proveedor 1='Vita Chips'*/
(NULL,9,1),
(NULL,10,1);

-- mostramos los productos por proveedor:
SELECT proveedor.nombre_corporativo, producto.nombre_producto,producto.color,producto.stock,producto.precio,categoria.nombre_categoria FROM telovendo.proveedor 
INNER JOIN telovendo.producto_x_proveedor ON proveedor.proveedor_id=producto_x_proveedor.proveedor_id
INNER JOIN telovendo.producto ON producto_x_proveedor.producto_id=producto.producto_id
INNER JOIN telovendo.categoria ON producto.categoria_id=categoria.categoria_id;

/*FUNCIONES*/

DROP FUNCTION IF EXISTS telovendo.max_rep_categoriaFn
DELIMITER $$
CREATE FUNCTION telovendo.max_rep_categoriaFn() RETURNS INT
DETERMINISTIC
BEGIN 
	DECLARE v_max_rep_cat INT DEFAULT 0;
	SET v_max_rep_cat= (SELECT count(producto.producto_id) AS repeticiones_categoria FROM telovendo.proveedor 
	INNER JOIN telovendo.producto_x_proveedor ON proveedor.proveedor_id=producto_x_proveedor.proveedor_id
	INNER JOIN telovendo.producto ON producto_x_proveedor.producto_id=producto.producto_id
	INNER JOIN telovendo.categoria ON producto.categoria_id=categoria.categoria_id GROUP BY categoria.categoria_id ORDER BY repeticiones_categoria DESC LIMIT 1);
    
    IF(ISNULL(v_max_rep_cat)) THEN
		RETURN 0;
    ELSE
		RETURN v_max_rep_cat;
	END IF;
END$$
DELIMITER ;


/*PROCEDIMINETOS*/

DROP PROCEDURE IF EXISTS telovendo.categoria_mas_repetida
DELIMITER $$
CREATE PROCEDURE telovendo.categoria_mas_repetida()
BEGIN
	DECLARE v_max_rep_categoria INT;
	SET v_max_rep_categoria=(SELECT telovendo.max_rep_categoriaFn());

	SELECT categoria.categoria_id, categoria.nombre_categoria,count(producto.producto_id) AS repeticiones FROM telovendo.proveedor 
	INNER JOIN telovendo.producto_x_proveedor ON proveedor.proveedor_id=producto_x_proveedor.proveedor_id
	INNER JOIN telovendo.producto ON producto_x_proveedor.producto_id=producto.producto_id
	INNER JOIN telovendo.categoria ON producto.categoria_id=categoria.categoria_id GROUP BY categoria.categoria_id HAVING repeticiones=v_max_rep_categoria;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS telovendo.productos_con_mayor_stock
DELIMITER $$
CREATE PROCEDURE telovendo.productos_con_mayor_stock()
BEGIN
	DECLARE v_max_stock_producto INT;
    SET v_max_stock_producto=(SELECT MAX(producto.stock) FROM telovendo.producto);
	
    SELECT producto.*,categoria.nombre_categoria FROM telovendo.producto 
    INNER JOIN categoria ON producto.categoria_id=categoria.categoria_id
    WHERE producto.stock=v_max_stock_producto;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS telovendo.color_de_producto_mas_comun
DELIMITER $$
CREATE PROCEDURE telovendo.color_de_producto_mas_comun()
BEGIN
	DECLARE v_max_rep_color INT;
	SET v_max_rep_color= (SELECT count(color) AS repeticiones FROM telovendo.producto GROUP BY color ORDER BY repeticiones DESC LIMIT 1);
	SELECT color,count(color) AS productos_con_ese_color FROM telovendo.producto GROUP BY color HAVING productos_con_ese_color =v_max_rep_color;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS telovendo.proveedores_con_menor_stock_de_producto
DELIMITER $$
CREATE PROCEDURE telovendo.proveedores_con_menor_stock_de_producto()
BEGIN
	DECLARE v_min_stock_producto INT;
    SET v_min_stock_producto=(SELECT MIN(producto.stock) FROM telovendo.producto);
    
    SELECT proveedor.nombre_corporativo, producto.nombre_producto, producto.stock, categoria.nombre_categoria FROM telovendo.proveedor 
	INNER JOIN telovendo.producto_x_proveedor ON proveedor.proveedor_id=producto_x_proveedor.proveedor_id
	INNER JOIN telovendo.producto ON producto_x_proveedor.producto_id=producto.producto_id
	INNER JOIN telovendo.categoria ON producto.categoria_id=categoria.categoria_id 
	WHERE producto.stock=v_min_stock_producto;
    
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS telovendo.cambiar_categoria_de_productos_mas_populares
DELIMITER $$
CREATE PROCEDURE telovendo.cambiar_categoria_de_productos_mas_populares(p_nombre_categoria VARCHAR(100))
BEGIN
	DECLARE v_max_rep_categoria INT;
    DECLARE v_max_registros INT DEFAULT NULL;
    DECLARE v_contador INT DEFAULT 1;
    DECLARE v_categoria_id_cambio INT DEFAULT NULL;
    DECLARE v_categoria_id_vieja INT DEFAULT NULL;
    
    SET v_max_rep_categoria=telovendo.max_rep_categoriaFn(); 
    
    /*Como pueden haber 2 o más categorias con el maximo de repeticiones creamos una tbla... categoria_id,nombre_categoria,repeticiones_categoria*/
    DROP TABLE IF EXISTS telovendo.categoria_con_max_repTB;
    CREATE TEMPORARY TABLE IF NOT EXISTS telovendo.categoria_con_max_repTB AS 
    (SELECT categoria.categoria_id, categoria.nombre_categoria, count(producto.producto_id) AS repeticiones_categoria FROM telovendo.producto
    INNER JOIN telovendo.categoria ON producto.categoria_id=categoria.categoria_id GROUP BY categoria.categoria_id  HAVING repeticiones_categoria = v_max_rep_categoria);
    SET v_max_registros=(SELECT COUNT(*) FROM telovendo.categoria_con_max_repTB);
    
	/*Si la categoria indicada no existe, la creamos en la tabla categoria*/
    SET v_categoria_id_cambio=(SELECT categoria_id FROM telovendo.categoria WHERE categoria.nombre_categoria=p_nombre_categoria);
    IF (ISNULL(v_categoria_id_cambio)) THEN
		INSERT INTO telovendo.categoria (categoria_id,nombre_categoria) VALUES(NULL,p_nombre_categoria);
    END IF;

	/*Ahora existe la cateogira y la dejamos el id guardado*/
	SET v_categoria_id_cambio=(SELECT categoria_id FROM telovendo.categoria WHERE categoria.nombre_categoria=p_nombre_categoria);

	/*Recorremos la tabla "categoria_con_max_repTB" que almacena todas las categorias con maximas repeticiones*/
    WHILE (v_contador <= v_max_registros) DO
		SET v_categoria_id_vieja=(SELECT categoria_id FROM telovendo.categoria_con_max_repTB LIMIT 1); /*leo el categoria_id de la tabla temporal*/
        DELETE FROM telovendo.categoria_con_max_repTB WHERE categoria_id=v_categoria_id_vieja; /*elimino de la tabla temporal el registro que lei*/
		
        SET SQL_SAFE_UPDATES = 0;
		UPDATE telovendo.producto SET categoria_id=v_categoria_id_cambio WHERE categoria_id=v_categoria_id_vieja; /*Actualizo el producto con el nuevo categoria_id*/
    
		SET v_contador=v_contador + 1;
    
    END WHILE;
    DROP TABLE IF EXISTS telovendo.categoria_con_max_repTB;
END$$
DELIMITER ;

/******************************************************************************
PREGUNTAS
******************************************************************************/

-- Cuál es la categoría de productos que más se repite.
/*SELECT categoria.categoria_id, categoria.nombre_categoria,count(producto.producto_id) AS cantidad_productos FROM telovendo.proveedor 
INNER JOIN telovendo.producto_x_proveedor ON proveedor.proveedor_id=producto_x_proveedor.proveedor_id
INNER JOIN telovendo.producto ON producto_x_proveedor.producto_id=producto.producto_id
INNER JOIN telovendo.categoria ON producto.categoria_id=categoria.categoria_id GROUP BY categoria.categoria_id ORDER BY cantidad_productos DESC;*/
CALL telovendo.categoria_mas_repetida();
-- Respuesta : Consola de video juegos es la categoría de productos que más se repite.


-- Cuáles son los productos con mayor stock
/*SELECT producto.nombre_producto,producto.stock FROM telovendo.producto ORDER BY producto.stock DESC;*/
CALL telovendo.productos_con_mayor_stock();
-- Respuesta : nintendo switch.


-- Qué color de producto es más común en nuestra tienda.
/*SELECT color, count(color) AS repeticiones FROM telovendo.producto GROUP BY color ORDER BY repeticiones DESC;*/
CALL telovendo.color_de_producto_mas_comun();
-- Respuesta : negro y rojo.


-- Cual o cuales son los proveedores con menor stock de productos.
/*
SELECT proveedor.nombre_corporativo, producto.nombre_producto, producto.stock, categoria.nombre_categoria FROM telovendo.proveedor 
INNER JOIN telovendo.producto_x_proveedor ON proveedor.proveedor_id=producto_x_proveedor.proveedor_id
INNER JOIN telovendo.producto ON producto_x_proveedor.producto_id=producto.producto_id
INNER JOIN telovendo.categoria ON producto.categoria_id=categoria.categoria_id 
ORDER BY producto.stock;
*/
CALL telovendo.proveedores_con_menor_stock_de_producto();
-- Respuesta : Proveedores con menor stock de producto : TodoAqui.


-- Cambien la categoría de productos más popular por ‘Electrónica y computación’.
/*SELECT categoria.categoria_id, categoria.nombre_categoria, count(producto.producto_id) AS repeticiones_categoria FROM telovendo.producto
    INNER JOIN telovendo.categoria ON producto.categoria_id=categoria.categoria_id GROUP BY categoria.categoria_id  */
CALL telovendo.cambiar_categoria_de_productos_mas_populares('Electrónica y computación');
-- Observamos el cambio realizando una consulta a la tabla categoria.
SELECT * FROM telovendo.categoria;











