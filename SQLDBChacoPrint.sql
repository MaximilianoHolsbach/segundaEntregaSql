DROP DATABASE IF EXISTS chaco_print_3;
CREATE DATABASE IF NOT EXISTS chaco_print_3;

USE chaco_print_3;

/* PERTENECE AL SEGMENTO IDENTIFICACION DE CLIENTE */

create table if not exists cliente(
    id_cliente int primary key not null auto_increment,
    nombre varchar(100),
    cuit varchar(11) default 'sin dato',
    fecha datetime default current_timestamp 
);

create table if not exists email_cliente(
    id_cliente int,
    email varchar(100),
    foreign key(id_cliente) references cliente(id_cliente) on delete cascade
);

create table if not exists telefono_cliente(
    id_cliente int,
    telefono varchar(50),
    foreign key(id_cliente) references cliente(id_cliente) on delete cascade
);

create table if not exists direccion_cliente(
    id_cliente int,
    direccion varchar(30),
    localidad varchar(60),
    provincia varchar(60),
    foreign key(id_cliente) references cliente(id_cliente) on delete cascade
);

/* PERTENECE AL SEGMENTO IDENTIFICACION DE RRHH */

create table if not exists puesto(
    id_puesto int primary key not null auto_increment,
    puesto varchar(30)
);

create table if not exists empleado(
    id_empleado int primary key not null auto_increment,
    nombre varchar(100),
    cuil varchar(11) default 'sin dato',
    puesto int,
    fecha datetime default current_timestamp 
);

create table if not exists email_empleado(
    id_empleado int,
    email varchar(100),
    foreign key(id_empleado) references empleado(id_empleado) on delete cascade
);

create table if not exists telefono_empleado(
    id_empleado int,
    telefono varchar(50),
    foreign key(id_empleado) references empleado(id_empleado) on delete cascade
);

create table if not exists direccion_empleado(
    id_empleado int,
    direccion varchar(100),
    foreign key(id_empleado) references empleado(id_empleado) on delete cascade
);

/* PERTENECE AL SEGMENTO IDENTIFICACION DE PROVEEDORES */

create table if not exists proveedor(
    id_proveedor int primary key not null auto_increment,
    nombre varchar(100),
    cuit varchar(11) default 'sin dato',
    fecha datetime default current_timestamp 
);

create table if not exists email_proveedor(
    id_proveedor int,
    email varchar(100),
    foreign key(id_proveedor) references proveedor(id_proveedor) on delete cascade
);

create table if not exists telefono_proveedor(
    id_proveedor int,
    telefono varchar(10),
    foreign key(id_proveedor) references proveedor(id_proveedor) on delete cascade
);

create table if not exists direccion_proveedor(
    id_proveedor int,
    direccion varchar(100),
    foreign key(id_proveedor) references proveedor(id_proveedor) on delete cascade
);

/* PERTENECE AL SEGMENTO DE STOCK */

create table if not exists stock(
    cod_interno int primary key not null auto_increment,
    id_producto varchar(100),
    nombre varchar(100),
    precio int,
    cantidad int,
    cantidad_minima int,
    proveedor int
);

/* SE UNE EL CLIENTE CON EL PRODUCTO */

create table if not exists venta(
    id_venta int primary key not null auto_increment,
    id_producto varchar(100),
    id_cliente int,
    nombre varchar(100),
    precio int,
    cantidad int,
    cantidad_minima int,
    fecha datetime default current_timestamp,
    foreign key(id_cliente) references cliente(id_cliente) on delete cascade
);

-- Seccion de vistas --
-- A esta vista la componen las tablas email_cliente y cliente, sirve para conocer los mails de los clientes
create or replace 
view vista_cliente_email as
	select c.id_cliente as id, c.nombre as nombre, email.email as email
    from cliente as c
    join email_cliente as email on c.id_cliente = email.id_cliente;

-- Esta vista se compone solo por la tabla stock, las misma trae los precios que superan el promedio para realizar un control de los mismos
create or replace 
view vista_control_precio as
	select stock.id_producto as id, stock.nombre as nombre, stock.precio as precio
    from stock as stock
    where stock.precio >= (
    select avg(stock.precio)
    from stock);

-- Esta vista esta compuesta por la tabla de email_empleado, y empleado, sirve para ver si a algun empleado le falta su correo
create or replace 
view vista_control_datos_rrhh as
	select e.id_empleado as id, e.nombre as nombre, ee.email as email
    from empleado as e
    left join email_empleado as ee on e.id_empleado = ee.id_empleado;

-- En esta vista solo interactuan los datos de la tabla stock para ver cuales productos que estan por debajo de la cantidad minima
create or replace 
view vista_control_stock as
	select stock.id_producto as id, stock.nombre as nombre, stock.cantidad as cantidad, stock.proveedor as proveedor
    from stock
    where stock.cantidad <= stock.cantidad_minima;

-- Esta vista se compone de las tablas empleado y puesto, la misma sirve para conocer los puestos de cada recurso humano de la empresa
create or replace 
view vista_puestos as
	select p.puesto as puesto, e.nombre as nombre
    from puesto as p
    join empleado as e on p.id_puesto = e.puesto;
    
-- Seccion de funciones --

-- Esta Funcion sirve para cotizar cualquier producto, solamente ingresando el codigo interno
delimiter $$
create function cotizacion (codigo_interno int) RETURNS float(11,2)
reads sql data
BEGIN
    declare resultado float;
    declare dolarhoy float;
    declare impuesto float;
    declare costo varchar(100);
    set dolarhoy = 175.50;
    set costo = (select precio from stock where cod_interno = codigo_interno);
    set resultado = (costo * dolarhoy) * 1.21;
    return resultado;
END $$
delimiter ;

-- Esta funcion nos sirve para conocer si un producto especifico necesita reposicion
delimiter $$
create function reposicion (codigo_interno int) RETURNS varchar(15) CHARSET utf8mb4
READS SQL DATA
BEGIN
    declare resultado int;
    declare cantidad1 int;
    declare cantidad2 int;
    declare respuesta varchar(15);
    select cantidad into cantidad1 from stock where cod_interno = codigo_interno;
    select cantidad_minima into cantidad2 from stock where cod_interno = codigo_interno;
    set resultado = cantidad1 - cantidad2;
    if resultado < 0 then
        set respuesta = 'comprar';
        return respuesta;
	else
        set respuesta = 'no comprar';
        return respuesta;
    end if;
END $$
delimiter ;

-- Seccion de stored procedure --

-- Este SP nos permite insertar un mail de forma segura para que no se repita
delimiter $$
create procedure `insertar_mail`(in id_empleado int,
                                 in email varchar(100))
begin
    select count(ep.email) into @existe from email_empleado as ep where ep.email = email;
    if @existe = 0 then
        insert into email_empleado(id_empleado,email)
        value (id_empleado,email);
	else 
        select 'El mail ya existe';
	end if;
end $$
delimiter ;

-- Este SP nos permite ordenar al cliente, segun necesitemos
delimiter $$
create procedure `orden_cliente`(in orden varchar(20))
begin
    if orden <> '' then
        set @cliente_orden = concat('order by',' ',orden);
	else 
        set @cliente_orden = '';
	end if;
    set @consulta = concat('select * from cliente',' ',@cliente_orden);
    prepare mi_consulta from @consulta;
    execute mi_consulta;
    deallocate prepare mi_consulta;
end $$
delimiter ;

-- Seccion de trigger --

-- Pertenece a la creacion y actualizacion del cliente


create table if not exists auditoria_cliente
(
    id_cliente int,
    nombre varchar(100),
    cuit varchar(11),
    fecha date
);

create trigger `log_crear_cliente`
after insert on `cliente`
for each row
insert into `auditoria_cliente`(id_cliente,nombre,cuit,fecha)
value (new.id_cliente,new.nombre,new.cuit,new.fecha);

create trigger `log_update_cliente`
before update on `cliente`
for each row
insert into `auditoria_cliente`(id_cliente,nombre,cuit,fecha)
value (old.id_cliente,old.nombre,old.cuit,curdate());

-- ########## Pertenece a la creaciòn actualización, y por ultimo eliminación de elemento en el stock colocando en tres tablas distintas########

create table if not exists crear_auditoria_stock
(
    cod_interno int,
    id_producto varchar(100),
    nombre varchar(100),
    precio int,
    proveedor int,
    fecha date
);

create trigger `log_crear_producto`
after insert on `stock`
for each row
insert into `crear_auditoria_stock`(cod_interno,id_producto,nombre,precio,proveedor,fecha)
value (new.cod_interno,new.id_producto,new.nombre,new.precio,new.proveedor,curdate());

create table if not exists actualiza_auditoria_stock
(
    cod_interno int,
    id_producto varchar(100),
    nombre varchar(100),
    precio int,
    proveedor int,
    fecha date
);

create trigger `log_update_producto`
before update on `stock`
for each row
insert into `actualiza_auditoria_stock`(cod_interno,id_producto,nombre,precio,proveedor,fecha)
value (old.cod_interno,old.id_producto,old.nombre,old.precio,old.proveedor,curdate());

create table if not exists elimina_auditoria_stock
(
    cod_interno int,
    id_producto varchar(100),
    nombre varchar(100),
	usuario varchar(100),
    fecha date
);

create trigger `log_elimina_producto`
before delete on `stock`
for each row
insert into `elimina_auditoria_stock`(cod_interno,id_producto,nombre,usuario,fecha)
value (old.cod_interno,old.id_producto,old.nombre,user(),curdate());
	
