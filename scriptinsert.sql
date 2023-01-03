-- SCRIPT DE INSERCION DE DATOS --
-- Las script de inserción que no se ven aqui reflejados, fueron importados de forma masiva 


use chaco_print_3;

-- SEGMENTO RECURSOS HUMANOS -- 

insert into puesto (puesto)
value
('GERENTE'),
('ADMINISTRATIVO'),
('TECNICO'),
('SUPERVISOR'),
('VENDEDOR');

insert into empleado (nombre,cuil,puesto)
value
('RIVAS LUIS','97468685',1),                    
('VILLAVERDE JUAN MATIAS','66323812',2),        
('SANCHEZ FRANCISCO RAMON','34563077',2),       
('HOLSBACH MAXIMILIANO','26026339',4),          
('TUR SPRINGER GUSTAVO','11523133',4),          
('VERA LEONARDO','82760489',3),                 
('CASTILLO YANINA','55112637',2),               
('CHIOTTA MARIA LELIA','39124260',4),           
('BARRETO JUAN JOSE','89946007',4),             
('MASSARO GERMAN EDGARDO','44251185',5);     

insert into direccion_empleado (id_empleado,direccion)
value
(1,'B Felipe Gallardo Av Coronel Falcon Mz 3 Pc 21'),
(2,'Pasaje Brown N 2328 '),
(3,'Pasaje Gabriel Carrasco N 3125 Villa Don Andres'),
(4,'Yolanda de Elizondo N 1270'),
(5,'Arizaga N 350'),
(6,'Calle Lino Torres N 122'),
(7,'Mz 29 Pc 4 Chacra 40 B Malvinas Argentinas 2'),
(8,'San Buenaventura del Monte Alto N 245'),
(9,'Sargento Cabral N 5280'),
(10,'J D PERON 702 ');

insert into telefono_empleado (id_empleado,telefono)
value
(1,'0362_1546694'),
(2,'0362_1548504'),
(3,'0362_1541620'),
(4,'0362_1543628'),
(5,'0362_1549305'),
(6,'0362_152992'),
(7,'0362_1546241'),
(8,'36247568'),
(9,'0362_1541740'),
(10,'0362_154');

insert email_empleado (id_empleado,email)
value
(2,'jm.villaverde.06@gmail.com'),
(6,'jm.villaverde.06@gmail.com'),
(7,'castillo_leyes@hotmail.com'),
(8,'leliachiotta84@gmail.com'),
(9,'juanju_flogger1@hotmail.com'),
(10,'gmassaro@komsa.com.ar');

-- SEGMENTO DEL PROVEEDOR --

insert into proveedor (nombre,cuit)
value
('ROTHER','49541693'),
('EPSON','37151970'),
('HEWLETT_PACKARD','81703873'),
('LEXMARK','98533005'),
('RICOH','56405133'),
('MITA', '40439316'),
('KATUN', '15867987'),
('SAMSUNG', '33666937'),
('KONICA', '99377326'),
('EFRENLOPEZ', '6212994');

insert into telefono_proveedor(id_proveedor,telefono)
value
(1,'15797062'),
(2,'15843009'),
(3,'15785657'),
(4,'15454820'),
(5,'15306292'),
(6,'15290475'),
(7,'15366120'),
(8,'15857068'),
(9,'15376698'),
(10,'15772311');

insert into email_proveedor (id_proveedor,email)
value
(1,'BROTHER@gmail.com'),
(2,'EPSON@yahoo.com'),
(3,'HEWLETT_PACKARD@outlook.com'),
(4,'LEXMARK@gmail.com'),
(5,'RICOH@yahoo.com'),
(6,'MITA@outlook.com'),
(7,'KATUN@gmail.com'),
(8,'SAMSUNG@yahoo.com'), 
(9,'KONICA@outlook.com'),
(10,'EFRENLOPEZ@gmail.com');

insert into direccion_proveedor (id_proveedor,direccion)
value
(1,'FLORIDA 833 2 216'),
(2,'PARANA 433 1 A'),
(3,'MOREAU DE JUSTO A 1,930'),
(4,'PASEO COLON 982'),  
(5,'MITRE 544'),  
(6,'ARCOS 1650'),  
(7,'AV. BUENOS AIRES Y CALLE 11 0'),  
(8,'SANTA FE 1548 01'), 
(9,'LAVALLE 1634 7 F'),
(10,'LAVALLE ENTRE LAS CALLES  MON 1634 7 F');