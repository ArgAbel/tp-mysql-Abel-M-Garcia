/*Ejercicios
Ejercicio 1 – Crear Base de Datos
Crear una base de datos llamada veterinaria_patitas_felices.*/

CREATE DATABASE veterinaria_patitas_felices;
USE veterinaria_patitas_felices;

/*Ejercicio 2 – Crear tabla duenos
Crear la tabla duenos con las siguientes columnas:*/

CREATE TABLE duenos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    dirección VARCHAR(100)
);
/*se corrigio despúes de creado el nombre del campo id */
/*ALTER TABLE `duenos` ADD `direccion` VARCHAR(100) NOT NULL AFTER `email`;*/
/*agregue olvido*/

/*Ejercicio 3 – Crear tabla mascotas
Crear la tabla mascotas con las siguientes columnas:
Columna Tipo Restricciones
id INT PRIMARY KEY, AUTO_INCREMENT
nombre VARCHAR(50) NOT NULL
especie VARCHAR(30) NOT NULL
fecha_nacimiento DATE
id_dueno INT FOREIGN KEY → duenos.id*/

CREATE TABLE mascotas(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(30) NOT NULL,
	fecha_nacimiento DATE,
    id_dueno INT,
    FOREIGN KEY (id_dueno)REFERENCES duenos(id)
) 

/*Ejercicio 4 – Crear tabla veterinarios
Crear la tabla veterinarios con las siguientes columnas:
Columna Tipo Restricciones
id INT PRIMARY KEY, AUTO_INCREMENT
nombre VARCHAR(50) NOT NULL
apellido VARCHAR(50) NOT NULL
matricula VARCHAR(20) NOT NULL, UNIQUE
especialidad VARCHAR(50) NOT NULL*/

CREATE TABLE veterinarios(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(50) NOT NULL,
	matricula VARCHAR(50) NOT NULL UNIQUE,
    especialidad VARCHAR(50) NOT NULL
 )

/*Ejercicio 5 – Crear tabla historial_clinico
Crear la tabla historial_clinico con las siguientes columnas:
Columna Tipo Restricciones
id INT PRIMARY KEY, AUTO_INCREMENT
id_mascota INT FOREIGN KEY → mascotas.id
id_veterinario INT FOREIGN KEY → veterinarios.id
fecha_registro DATETIME NOT NULL, DEFAULT CURRENT_TIMESTAMP
descripcion VARCHAR(250) NOT NULL*/

CREATE TABLE historial_clinico(
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_mascota INT,
    id_veterinario INT,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion VARCHAR(250) NOT NULL,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id),
    FOREIGN KEY (id_veterinario) REFERENCES veterinarios(id)
 )
 /*ALTER TABLE historial_clinico
ADD COLUMN restrict BOOLEAN NOT NULL DEFAULT FALSE;*/

 /*Ejercicio 6 – Insertar registros
Insertar:
● 3 dueños con información completa
● 3 mascotas, cada una asociada a un dueño
● 2 veterinarios con especialidades distintas
● 3 registros de historial clínico */

INSERT INTO veterinarios (nombre, especie, matricula, especialidad) VALUES
('Dr. Javier', 'Caninos y Felinos', 'VET-001A', 'Medicina Interna'),
('Dra. Cecilia', 'Exóticos', 'VET-002B', 'Dermatología');

INSERT INTO mascotas (nombre, especie, fecha_nacimiento, id_dueno) VALUES
('Luna', 'Perro', '2020-05-15', 1),
('Max', 'Gato', '2022-01-20', 2),
('Kiwi', 'Loro', '2023-03-10', 3);

INSERT INTO duenos (nombre, apellido, telefono, email) VALUES
('Ana', 'Gómez', '351-1234567', 'ana.gomez@mail.com'),
('Luis', 'Pérez', '11-98765432', 'luis.perez@mail.com'),
('Marta', 'Rodríguez', '223-5551234', 'marta.rodriguez@mail.com');

INSERT INTO historial_clinico (id_mascota, id_veterinario, descripcion) VALUES
(1, 1, 'Consulta de rutina. Vacunación anual aplicada.'),
(2, 1, 'Examen por vómitos leves. Dieta blanda recomendada.'),
(3, 2, 'Revisión dermatológica por picoteo excesivo en patas.');

/*Ejercicio 7 – Actualizar registros
Realizar las siguientes actualizaciones:
1. Cambiar la dirección de un dueño (por ID o nombre).
2. Actualizar la especialidad de un veterinario (por ID o matrícula).
3. Editar la descripción de un historial clínico (por ID).
*/
/*7_1*/
UPDATE duenos SET direccion ='mosconi1234' WHERE id = 1;
/*7_2*/
UPDATE veterinarios SET especialidad ='Cardiología' WHERE matricula = 'VET-001A';
/*7_3*/
UPDATE historial_clinico SET descripcion ='Consulta de rutina. Vacunación anual aplicada y revisión dental.' WHERE id = 1;

/*Ejercicio 8 – Eliminar registros
1. Eliminar una mascota (por ID o nombre).
2. Verificar que se eliminen automáticamente los registros del historial clínico asociados
(ON DELETE CASCADE).*/

/* comando para saber el nombre de la fk*/
SELECT
    constraint_name
FROM
    information_schema.key_column_usage
WHERE
    table_name = 'historial_clinico' AND column_name = 'id_mascota'
    AND constraint_schema = 'veterinaria_patitas_felices';
/*borrar foreing key para poder cambiar el campo a delete con cascade*/
ALTER TABLE historial_clinico
DROP FOREIGN KEY historial_clinico_ibfk_1;
/*agregar la fk con cascade*/
ALTER TABLE historial_clinico
ADD CONSTRAINT fk_historial_mascota_cascade
FOREIGN KEY (id_mascota)
REFERENCES mascotas(id)
ON DELETE CASCADE
ON UPDATE RESTRICT;
/* eliminando la mascota*/
DELETE FROM mascotas WHERE id = 2;

/*Ejercicio 9 – JOIN simple
Consulta que muestre:
● Nombre de la mascota
● Especie
● Nombre completo del dueño (nombre + apellido)
*/
SELECT m.nombre, m.especie, CONCAT(duenos.nombre, ' ', duenos.apellido) AS nombre_completo_dueño
FROM mascotas m
INNER JOIN duenos ON m.id_dueno = duenos.id

/*Ejercicio 10 – JOIN con historial clínico*/
SELECT m.nombre AS nombre_mascota, m.especie, CONCAT(d.nombre, ' ', d.apellido) 
AS nombre_completo_dueño,v.nombre AS nombre_veterinario, h.fecha_registro, h.descripcion
FROM historial_clinico h
INNER JOIN mascotas m ON m.id = h.id_mascota
INNER JOIN duenos d ON d.id = m.id_dueno
INNER JOIN veterinarios v ON v.id = h.id_veterinario
ORDER BY h.fecha_registro DESC;