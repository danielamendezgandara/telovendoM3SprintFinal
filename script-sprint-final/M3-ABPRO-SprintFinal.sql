-- M3 Sprint Final Grupo 3

-- Creación de una base de datos
CREATE DATABASE telovendoapp DEFAULT CHARACTER SET utf8mb4;
-- Deben crear un usuario con privilegios para crear, eliminar y modificar tablas, 
-- insertar registros.
CREATE USER 'admintelovendoapp'@'localhost' IDENTIFIED BY 'password';
-- Al usuario creado se le crea una nueva de contraseña de conexión.
SET PASSWORD FOR 'admintelovendoapp'@'localhost' = 'ADminteloVendoAPP9876$$';

-- Totalidad de permisos a la base de datos creada.
GRANT ALL PRIVILEGES ON telovendoapp.* TO 'admintelovendoapp'@'localhost';
-- Se cargan los privilegios del usuario.
FLUSH PRIVILEGES;

-- Creación de las tablas base de datos telovendoapp necesarias de acuerdo al
-- contexto de la problemática

-- Creación tabla categoría producto.
-- Dado que la tabla categoria no depende de ninguna otra dentro de la base de datos
-- se puede considerar como una entidad fuerte. Es la primera que crearemos.
DROP TABLE IF EXISTS telovendoapp.categoria;
CREATE TABLE telovendoapp.categoria(
categoria_id  INT UNSIGNED NOT NULL AUTO_INCREMENT,
nombre_categoria VARCHAR(100) NOT NULL,
descripcion_categoria VARCHAR(100),
PRIMARY KEY (categoria_id)
) DEFAULT CHARSET=utf8mb4;
-- Descripción de la tabla categoria
DESCRIBE telovendoapp.categoria;

-- Creación tabla proveedor.
-- La tabla proveedor se relaciona con la tabla categoría en una relación de uno es a uno,
-- ya que un único proveedor posee una categoría y no dos o más la misma.
DROP TABLE IF EXISTS telovendoapp.proveedor;
CREATE TABLE telovendoapp.proveedor(
proveedor_id        INT UNSIGNED NOT NULL AUTO_INCREMENT, 
representante_legal VARCHAR(100) NOT NULL,
nombre_coorporativo VARCHAR(100) NOT NULL,
categoria_id        INT UNSIGNED NOT NULL,
PRIMARY KEY (proveedor_id),
CONSTRAINT fk_proveedor_categoria 
FOREIGN KEY (categoria_id) REFERENCES telovendoapp.categoria (categoria_id) 
ON DELETE CASCADE
) DEFAULT CHARSET=utf8mb4;
-- Descripción de la tabla proveedor
DESCRIBE telovendoapp.proveedor;


-- Creación tabla contacto proveedor
-- Creada la tabla proveedor se procede a la creación de  la tabla contacto, que depende
-- de la tabla proveedor , es por ello que para existir la relación debe crearse primero la
-- tabla proveedor. Un proveedor puede tener a lo menos 2 contactos.
DROP TABLE IF EXISTS telovendoapp.contacto;
CREATE TABLE telovendoapp.contacto(
contacto_id            INT UNSIGNED NOT NULL AUTO_INCREMENT,
proveedor_id           INT UNSIGNED NOT NULL,
telefono_contacto      BIGINT,
receptor_llamada       VARCHAR(100) NOT NULL,
PRIMARY KEY (contacto_id),
CONSTRAINT fk_contacto_proveedor
FOREIGN KEY (proveedor_id) REFERENCES telovendoapp.proveedor (proveedor_id) 
ON DELETE CASCADE
)DEFAULT CHARSET=utf8mb4;
-- Descripción de la tabla contacto.
DESCRIBE telovendoapp.contacto;

-- Creación tabla facturacion
-- La tabla facturación considera el correo electrónico del proveedor, si bien se menciona que es 
-- uno sólo,consideramos que es más adecuado separarlo de la tabla proveedor e incorporarlo en 
-- una tabla que refleje la transacción. La tabla facturación se relaciona con la tabla proveedor
-- través de la columna proveedor_id.
DROP TABLE IF EXISTS telovendoapp.facturacion;
CREATE TABLE telovendoapp.facturacion(
facturacion_id       INT UNSIGNED NOT NULL AUTO_INCREMENT,
correo_electronico   VARCHAR(255),
proveedor_id         INT UNSIGNED NOT NULL,
PRIMARY KEY(facturacion_id),
CONSTRAINT fk_facturacion_proveedor
FOREIGN KEY (proveedor_id) REFERENCES telovendoapp.proveedor (proveedor_id) 
ON DELETE CASCADE
)DEFAULT CHARSET=utf8mb4;
-- Descripción de la tabla facturacion.
DESCRIBE telovendoapp.facturacion;

-- Creación tabla producto
-- La tabla producto se relaciona con la tabla categoria siguiendo la relación de que diversos
-- productos pueden coincidir en categoría o no. La relación establecida entre la tabla categoria y
-- la tabla producto es de uno es a muchos. Las tablas se relacionan por la categoria_id.
DROP TABLE IF EXISTS telovendoapp.producto;
CREATE TABLE telovendoapp.producto(
producto_id     INT UNSIGNED NOT NULL AUTO_INCREMENT,
nombre_producto VARCHAR(100) NOT NULL,
precio_producto INT UNSIGNED DEFAULT 0,
stock_producto  INT UNSIGNED DEFAULT 0,
categoria_id    INT UNSIGNED NOT NULL,
color_producto  VARCHAR(100),
PRIMARY KEY (producto_id),
CONSTRAINT fk_producto_categoria
FOREIGN KEY (categoria_id) REFERENCES telovendoapp.categoria (categoria_id) 
ON DELETE CASCADE
) DEFAULT CHARSET=utf8mb4;
-- Descripción de la tabla producto.
DESCRIBE telovendoapp.producto;

-- Creación tabla proveedor_producto (tabla intermediaria)
-- Una vez construidas las tablas proveedor y producto, es necesario crear una tabla intermediaria,
-- debido a que un producto puede tener distintos proveedores de acuerdo al enunciado.Dado esto
-- la tabla proveedor_producto posee dos foreign key una para relacionarse con la tabla proveedor
-- y otra para relacionarse con la tabla producto.
DROP TABLE IF EXISTS telovendoapp.proveedor_producto;
CREATE TABLE telovendoapp.proveedor_producto(
proveedor_producto_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
proveedor_id          INT UNSIGNED NOT NULL, 
producto_id           INT UNSIGNED NOT NULL,
PRIMARY KEY (proveedor_producto_id),
CONSTRAINT fk_proveedor_producto_proveedor
FOREIGN KEY (proveedor_id) REFERENCES telovendoapp.proveedor (proveedor_id) 
ON DELETE CASCADE,
CONSTRAINT fk_proveedor_producto_producto
FOREIGN KEY (producto_id) REFERENCES telovendoapp.producto (producto_id) 
ON DELETE CASCADE
) DEFAULT CHARSET=utf8mb4;
-- Descripción de la tabla proveedor_producto.
DESCRIBE telovendoapp.proveedor_producto;


-- Creación tabla cliente.
-- Considerando lo que dice el enunciado la tabla cliente no depende de ninguna otra tabla, se 
-- establece como primary key el cliente_id.
DROP TABLE IF EXISTS telovendoapp.cliente;
CREATE TABLE telovendoapp.cliente(
cliente_id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
nombre_cliente    VARCHAR(100) NOT NULL,
apellido_cliente  VARCHAR(100) NOT NULL,
direccion_cliente VARCHAR(100) NOT NULL,
PRIMARY KEY(cliente_id)
) DEFAULT CHARSET=utf8mb4;
-- Descripción de la tabla cliente.
DESCRIBE telovendoapp.cliente;

-- Creación de la tabla venta.
-- Si bien en el enunciado no lo menciona decidimos declarar la tabla venta para
-- que la tabla cliente tuviera relación indirecta con el producto a través de la
-- tabla detalle_venta.
DROP TABLE IF EXISTS telovendoapp.venta;
CREATE TABLE telovendoapp.venta(
venta_id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
fecha_venta      DATETIME DEFAULT NOW(),
cliente_id       INT UNSIGNED NOT NULL,
PRIMARY KEY(venta_id),
CONSTRAINT fk_venta_cliente
FOREIGN KEY (cliente_id) REFERENCES telovendoapp.cliente(cliente_id)
ON DELETE CASCADE
)DEFAULT CHARSET=utf8mb4;
-- Descripción de la tabla venta.
DESCRIBE telovendoapp.venta;

-- Creación de la tabla detalle_venta.
-- La tabla detalle venta se relaciona con la tabla venta. Esta tabla identifica el detalle
-- de la venta y se relaciona directamente con el producto mediante una foreign key que coincide
-- con la columna producto_id de la tabla producto.
DROP TABLE IF EXISTS telovendoapp.detalle_venta;
CREATE TABLE telovendoapp.detalle_venta(
detalle_venta_id  INT UNSIGNED NOT NULL AUTO_INCREMENT,
precio_venta      INT UNSIGNED NOT NULL,
cantidad_producto INT UNSIGNED NOT NULL,
venta_id          INT UNSIGNED NOT NULL,
producto_id       INT UNSIGNED NOT NULL,
PRIMARY KEY (detalle_venta_id),
CONSTRAINT fk_detalle_venta_venta
FOREIGN KEY (venta_id) REFERENCES telovendoapp.venta(venta_id)
ON DELETE CASCADE,
CONSTRAINT fk_detalle_venta_producto
FOREIGN KEY (producto_id) REFERENCES telovendoapp.producto(producto_id)
ON DELETE CASCADE
)DEFAULT CHARSET=utf8mb4;
-- Descripción de la tabla venta.
DESCRIBE telovendoapp.venta;

-- Para efecto de lo que se solicita más adelante se agrega a la tabla 
-- categoria registros relacionados con categorías de productos electrodomésticos.
INSERT INTO telovendoapp.categoria
VALUES (NULL,'Grandes electrodomésticos','Frigoríficos, lavadoras, lavavajillas,entre otros'),
(NULL,'Pequeños electrodomésticos','Planchas, freidoras, tostadoras, entre otros'),
(NULL,'Equipos de informática y telecomunicaciones','Ordenadores, impresoras, copiadoras, entre otros'),
(NULL,'Aparatos electrónicos de consumo','Radios, televisores, cadenas de alta fidelidad, entre otros'),
(NULL,'Aparatos de alumbrado','Lámparas de todo tipo, luminarias para lámparas fluorescentes  entre otros'),
(NULL,'Herramientas eléctricas o electrónicas',' Taladradoras, sierras, máquinas de coser, entre otros'),
(NULL,'Instrumentos de vigilancia o control','Detector de humos, termostatos y otros aparatos de medición '),
(NULL,'Máquinas expendedoras','Máquinas expendedoras de bebidas, productos sólidos, dinero entre otros ');

-- Se observa el resultado, observando los registros ingresados a la tabla categoria.
SELECT * FROM telovendoapp.categoria;

-- Insertar 5 registros a la tabla proveedores.
INSERT INTO telovendoapp.proveedor
VALUES (NULL,'Patricio Aguirre Cabrera','Global Chile HB',1),
(NULL,'Josefina Almodovar Cortés','Tectronic',3),
(NULL,'Pablo Herrera Guzmán','Comercial HLP',2),
(NULL,'Tamara Díaz Rosales','BIP Chile',4),
(NULL,'Victor Vicencio Arancibia','Enelec',5);

-- Se observa el resultado, observando los registros ingresados a la tabla proveedor.

SELECT * FROM telovendoapp.proveedor;

-- Insertar 10 registros a la tabla producto.
INSERT INTO telovendoapp.producto
VALUES(NULL, 'MACBOOK AIR M1',990900,20,3,'rosado plata'),
(NULL, 'DELL INSPIRON 3501',599900,30,3,'azul platino'),
(NULL, 'ASUS VIVOBOOK 14 K413EA-AM1880W',649600,40,3,'verde platino'),
(NULL, 'REFRIGERADOR NO FROST 249LT 2900hbd',309990,120,1,'negro platino'),
(NULL, 'LAVADORA WOBBLE WA90H4400SW1ZS',209900,150,1,'blanco'),
(NULL, 'SAMSUNG LED 43" T5202 FHD Smart TV',208500,60,4,'negro platino'),
(NULL, 'MINICOMPONENTE SONY MHC-V13',189900,90,4,'negro platino'),
(NULL, 'HORNO CON FREIDORA DE AIRE OSTER',159900,145,2,'blanco'),
(NULL, 'PLANCHA SILVER STAR MOD ES-94A',89990,75,2,'negro grisaceo'),
(NULL, 'LÁMPARA CARLTON 2 - SOBREMESA',75800,60,5,'negro rosa');

-- Se observa el resultado, observando los registros ingresados a la tabla producto.

SELECT * FROM telovendoapp.producto;

-- Cuál es la categoría de productos que más se repite.
-- Para saber qué categoría de productos más se repite se calculará la frecuencia de 
-- categoria_id de la tabla productos mediante la función COUNT. Dado que la tabla 
-- producto no nos muestra el nombre de la categoria y que podemos establecer una relación
-- entre la tabla producto y la tabla categoria mediante categoria id  obtenemos los datos 
-- comunes entre las dos tablas mediante INNER JOIN previamente ordenando la tabla producto
-- mediante la agrupación de registros por categoría y ordenándolos de forma descendente por
-- el campo creado de cuántas veces se repite dicha categoria, finalmente se limita a 1 para
-- obtener sólo la categoría que más se repite de productos.

   SELECT nombre_categoria,COUNT(nombre_categoria) maximo
   FROM telovendoapp.categoria
   INNER JOIN telovendoapp.producto
   ON telovendoapp.categoria.categoria_id=telovendoapp.producto.categoria_id
   GROUP BY nombre_categoria
   ORDER BY maximo DESC
   LIMIT 1;
   -- De acuerdo al resultado la categoría que más se repide es 'Equipos de informática y telecomunicaciones'.

   -- Cuáles son los productos con mayor stock
   -- Para obtener los productos con mayor stock ordenamos la tabla productos por la columna
   -- stock producto de mayor a menor y lo limitamos a 3 registros(a criterio).
   SELECT producto_id,nombre_producto,stock_producto
   FROM telovendoapp.producto
   ORDER BY stock_producto DESC
   LIMIT 3;
   -- Los productos con mayor stock son 'LAVADORA WOBBLE WA90H4400SW1ZS'(150),
   -- 'HORNO CON FREIDORA DE AIRE OSTER'(145), y 'REFRIGERADOR NO FROST 249LT 2900hbd'(120).
   
   -- Qué color de producto es más común en nuestra tienda.
   -- Para obtener el color más común de nuestra tienda a grupamos los registros mediante 
   -- la frecuencia en que se repite un mismo color, para ello creamos la columna color_mas_comun
   -- y ordenamos de forma descente en base a este campo la tabla, finalmente lo limitamos a un 
   -- registro.
   SELECT color_producto,COUNT(color_producto) color_mas_comun
   FROM telovendoapp.producto
   GROUP BY color_producto
   ORDER BY color_mas_comun DESC
   LIMIT 1;
-- El color más común de productos en nuestra tienda es negro platino.

-- Cual o cuales son los proveedores con menor stock de productos.
-- Para determinar cuáles son los proveedores con menor stock debemos sumar los stock de cada productos
-- agrupando estos últimos por categoria_id. Dado que producto se relaciona indirectamente con la 
-- tabla proveedor por la tabla categoria, primeramente obtenemos los registros o campos comunes de 
-- la intersección de la tabla proveedor y la tabla categoria mediante el campo categoria_id, posterior-
-- mente el resultado se intersecciona con la tabla producto que previamente ha sido agrupada por 
-- categoria_id y ordenada de menor a mayor en base a la suma total de cada stock de producto.
   SELECT proveedor_id, representante_legal,
   nombre_coorporativo,SUM(stock_producto) stock_total_productos
   FROM telovendoapp.proveedor
   INNER JOIN telovendoapp.categoria
   ON telovendoapp.proveedor.categoria_id = telovendoapp.categoria.categoria_id
   INNER JOIN telovendoapp.producto
   ON telovendoapp.producto.categoria_id=telovendoapp.categoria.categoria_id
   GROUP BY telovendoapp.producto.categoria_id
   ORDER BY stock_total_productos ASC
   LIMIT 3;
   
   -- Los proveedores con menor stock de productos son : Enelec (60 productos total en 
   -- stock), Tectronic (90 productos total en stock) y BIP Chile(150 productos en total en 
   -- stock).
   
   -- Cambien la categoría de productos más popular por ‘Electrónica y computación’.
   -- Considerando que la categoria más popular es la que más se repite dentro de 
   -- los productos, realizamos una selección en base a la agrupación de los registros mediante 
   -- categoria y los ordenamos por la frecuencia de la categoria una vez obtenido esto selecciona-
   -- sólo el campo categoria_id de la tabla producto y se lo asignamos como valor a el campo
   -- categoria_id de la tabla categoria. Cuando se ejecute el UPDATE se cambiará por el nombre de 
   -- categoria nuevo identificando el valor del campo categoria_id dado.
   UPDATE telovendoapp.categoria
   SET nombre_categoria = 'Electrónica y computación'
   WHERE categoria_id = (SELECT categoria_id
   FROM telovendoapp.producto GROUP BY categoria_id
   ORDER BY COUNT(categoria_id) DESC LIMIT 1);
   
   -- Se observa el cambio realizado a la tabla categoria de la base de datos telovendoapp.

   SELECT categoria_id,nombre_categoria FROM telovendoapp.categoria;




















