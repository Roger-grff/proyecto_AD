
SET NAMES utf8mb4;

-- ============================================================
-- Base de datos: tareas_db
-- ============================================================
CREATE DATABASE IF NOT EXISTS tareas_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE tareas_db;

-- Tabla estudiantes
CREATE TABLE IF NOT EXISTS estudiantes (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    cedula   VARCHAR(20)  NOT NULL UNIQUE,
    nombre   VARCHAR(120) NOT NULL,
    password VARCHAR(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla tareas
CREATE TABLE IF NOT EXISTS tareas (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    codigo       VARCHAR(20)  NOT NULL UNIQUE,
    titulo       VARCHAR(200) NOT NULL,
    descripcion  TEXT         NOT NULL,
    fecha_limite DATETIME     NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla entregas  (UNIQUE garantiza que no se entregue 2 veces la misma tarea)
CREATE TABLE IF NOT EXISTS entregas (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    tarea_id      INT      NOT NULL,
    estudiante_id INT      NOT NULL,
    respuesta     TEXT     NOT NULL,
    fecha_entrega DATETIME NOT NULL,
    FOREIGN KEY (tarea_id)      REFERENCES tareas(id)      ON DELETE CASCADE,
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id) ON DELETE CASCADE,
    UNIQUE KEY uk_entrega (tarea_id, estudiante_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Datos de prueba ──────────────────────
INSERT IGNORE INTO estudiantes (cedula, nombre, password) VALUES
('1700000001', 'Ana García',       'pass123'),
('1700000002', 'Luis Pérez',       'pass123'),
('1700000003', 'María Rodríguez',  'pass123'),
('1700000004', 'Carlos López',     'pass123');

INSERT IGNORE INTO tareas (codigo, titulo, descripcion, fecha_limite) VALUES
('TAREA-001',
 'Introducción a Docker',
 'Instala Docker Desktop, corre el contenedor hello-world y documenta el proceso con capturas. Explica qué sucede internamente.',
 DATE_ADD(NOW(), INTERVAL 7 DAY)),
('TAREA-002',
 'Dockerfile y construcción de imágenes',
 'Crea un Dockerfile para una app web simple. Documenta cada instrucción y sube la imagen a Docker Hub.',
 DATE_ADD(NOW(), INTERVAL 14 DAY)),
('TAREA-003',
 'Docker Compose – App multi-contenedor',
 'Define con Docker Compose una app con: servidor web, backend Python y base de datos. Los servicios deben comunicarse dentro de la red Docker.',
 DATE_ADD(NOW(), INTERVAL 21 DAY)),
('TAREA-004',
 'Balanceo de carga con NGINX',
 'Configura NGINX como balanceador de carga entre tres instancias web. Usa weights y verifica la distribución con herramientas de carga.',
 DATE_ADD(NOW(), INTERVAL 3 DAY)),
('TAREA-DEMO',
 'Tarea vencida (solo para probar validación)',
 'Esta tarea tiene fecha pasada para verificar que el sistema no permite entregas fuera de plazo.',
 DATE_SUB(NOW(), INTERVAL 1 DAY));

-- Usuario de replicación
CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED WITH mysql_native_password BY 'repl_pass123';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;
