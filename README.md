<h1 align='center'> Sistema Web Distribuido con Docker, Flask, Nginx y MySQL</h1>

## Descripción

Este proyecto implementa una arquitectura web distribuida utilizando contenedores Docker. El sistema está compuesto por tres servidores desarrollados con Flask, un servidor Nginx que actúa como balanceador de carga y un contenedor MySQL para el almacenamiento de datos.

La arquitectura permite distribuir las solicitudes de los clientes entre varios servidores, mejorando la disponibilidad, escalabilidad y rendimiento del sistema.

---

## Arquitectura del Proyecto

<img width="544" height="583" alt="image" src="https://github.com/user-attachments/assets/8ec46d34-514f-4a0e-b268-0133f605317f" />


---

## Tecnologías Utilizadas

- Python
- Flask
- Docker
- Docker Compose
- Nginx
- MySQL
- HTML
- CSS
- JavaScript
- k6 (Pruebas de carga)

---

## Estructura del Proyecto

```
proyecto_AD/
│
├── docker-compose.yml
├── README.md
│
├── nginx/
│   ├── Dockerfile
│   └── nginx.conf
│
├── servidor1/
│   ├── app.py
│   ├── Dockerfile
│   ├── requirements.txt
│   └── templates/
│       ├── base.html
│       ├── entregar.html
│       ├── login.html
│       ├── mis_entregas.html
│       └── tareas.html
│
├── servidor2/
│   ├── app.py
│   ├── Dockerfile
│   ├── requirements.txt
│   └── templates/
│       ├── base.html
│       ├── entregar.html
│       ├── login.html
│       ├── mis_entregas.html
│       └── tareas.html
│
├── servidor3/
│   ├── app.py
│   ├── Dockerfile
│   ├── requirements.txt
│   └── templates/
│       ├── base.html
│       ├── entregar.html
│       ├── login.html
│       ├── mis_entregas.html
│       └── tareas.html
│
├── db/
│   ├── init.sql
│   └── init-slave.sh
│
└── tests/
    └── test.js
```

---

## Requisitos

Antes de ejecutar el proyecto es necesario tener instalado:

- Docker Desktop
- Docker Compose

Verificar instalación:

```bash
docker --version
docker compose version
```

---

## Instalación

Clonar el repositorio:

```bash
git clone https://github.com/Roger-grff/proyecto_AD
```

Ingresar al proyecto:

```bash
cd proyecto_AD
```

Levantar todos los servicios:

```bash
docker compose up -d
```

Verificar los contenedores:

```bash
docker ps
```

---

## Acceso a la Aplicación

Una vez iniciado el proyecto, acceder desde el navegador:

```
http://localhost:8080
```

> El puerto puede variar dependiendo de la configuración del archivo `docker-compose.yml`.

---

## Contenedores del Proyecto

| Contenedor | Función |
|------------|---------|
| nginx | Balanceador de carga |
| servidor1 | Aplicación Flask |
| servidor2 | Aplicación Flask |
| servidor3 | Aplicación Flask |
| mysql | Base de datos |

---

## Interfaz

| Pantalla | Vista previa |
|---|---|
| Login | <img width="450" height="500" alt="image" src="https://github.com/user-attachments/assets/871842bc-6592-4805-aa52-df62cd820797" />|
| Lista de tareas | <img width="450" height="400" alt="image" src="https://github.com/user-attachments/assets/e18bc032-6990-496f-a0ad-c02879caaa91" />|
| Entrega de tarea | <img width="450" height="400" alt="image" src="https://github.com/user-attachments/assets/218d4487-4a46-4132-b30b-475fe60bfa61" />|
| Mis entregas | <img width="450" height="400" alt="image" src="https://github.com/user-attachments/assets/9e88a0f9-5e48-49af-a063-3ec8315e3e26" />|

---

## Balanceo de Carga

Nginx distribuye automáticamente las solicitudes entrantes entre los tres servidores Flask utilizando el algoritmo Round Robin.

Beneficios:

- Distribución uniforme del tráfico.
- Mayor disponibilidad.
- Mejor rendimiento.
- Escalabilidad horizontal.

---

# Pruebas de Carga

El proyecto incluye pruebas de carga utilizando **k6** para evaluar el rendimiento bajo múltiples usuarios concurrentes.

## Crear la carpeta de pruebas

```
tests/
```

Dentro de ella crear el archivo:

```
load_test.js
```

Contenido:

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    scenarios: {
        usuarios_100: {
            executor: 'constant-vus',
            vus: 100,
            duration: '3m',
        },
        usuarios_300: {
            executor: 'constant-vus',
            vus: 300,
            duration: '3m',
            startTime: '3m', 
        },
        usuarios_500: {
            executor: 'constant-vus',
            vus: 500,
            duration: '3m',
            startTime: '6m', 
        },
    },
};

export default function () {
    const res = http.get('http://host.docker.internal:8080/');

    check(res, {
        'status es 200': (r) => r.status === 200,
    });

    sleep(1);
}
//docker run --rm -i -v "${PWD}:/scripts" grafana/k6 run /scripts/test.js
//docker stats
```

---

## Ejecutar la prueba

Windows CMD

```bash
 docker run --rm -i -v "${PWD}/tests:/scripts" grafana/k6 run /scripts/test.js
```
Se visualizará el consumo de:

- CPU
- Memoria RAM
- Red
- Procesamiento por contenedor

---

## Métricas Evaluadas

Durante las pruebas de carga se analizan:

- Tiempo promedio de respuesta.
- Tiempo máximo de respuesta.
- Solicitudes por segundo (RPS).
- Usuarios concurrentes.
- Porcentaje de errores.
- Uso de CPU.
- Uso de memoria.
- Rendimiento del balanceador.

---

## Ejemplo de Resultados

<img width="1026" height="541" alt="image" src="https://github.com/user-attachments/assets/f1b16678-b839-41fc-83b8-44350d1bb07d" />

---

## Detener el Proyecto

```bash
docker compose down
```

Para eliminar también los volúmenes:

```bash
docker compose down -v
```

---

## Autores

- **Andre chang**
- **Nayely Ayol**
- **Roger Grefa**

Proyecto desarrollado con fines académicos para implementar una arquitectura distribuida basada en contenedores Docker y evaluar su desempeño mediante pruebas de carga con k6.
