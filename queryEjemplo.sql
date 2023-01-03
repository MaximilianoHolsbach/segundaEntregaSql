use chaco_print_3;

-- Con esta consulta traigo todos los datos relacionados al producto a cotizar

select id_producto, nombre , cotizacion(cod_interno) as Precio_en_pesos from stock where cod_interno = 5;

-- Con esta consulta traigo todos los datos pertinentes del producto a reponer. 

select s.id_producto,s.nombre,reposicion(s.cod_interno) from stock s where s.cod_interno = 1;

