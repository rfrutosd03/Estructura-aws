# WordPress en Alta Disponibilidad en AWS

Este proyecto despliega un CMS **WordPress** en alta disponibilidad y escalabilidad sobre Amazon Web Services (AWS), organizado en tres capas de infraestructura.

---
## <span style="color:red">rfrutosd03.ddns.net</span>
---
---
## <span style="color:blue">Arquitectura en tres capas</span>

### <span style="color:green">Capa 1: Pública (Balanceador de carga)</span>
- **Función:** Recibir tráfico externo y distribuirlo a los servidores de aplicación.
- **Servicio:** Servidor Apache configurado como proxy inverso y balanceador.
- **Acceso:** Única capa accesible desde Internet.
- **Seguridad:** Grupo de seguridad permite solo puertos 80/443 desde cualquier origen.

### <span style="color:green">Capa 2: Privada (Aplicación + NFS)</span>
- **Función:** Ejecutar WordPress y servir contenido.
- **Servicios:**
  - Dos servidores Apache con PHP-FPM.
  - Un servidor NFS que exporta el directorio de WordPress.
- **Acceso:** Solo accesible desde la capa 1 (HTTP) y entre sí (NFS).
- **Seguridad:** Grupo de seguridad permite tráfico HTTP desde capa 1 y NFS entre nodos.

### <span style="color:green">Capa 3: Privada (Base de datos)</span>
- **Función:** Almacenar datos de WordPress.
- **Servicio:** Servidor MySQL/MariaDB.
- **Acceso:** Solo accesible desde la capa 2 (puerto 3306).
- **Seguridad:** Bloqueada la conectividad directa desde capa 1.

---

## <span style="color:red">Red y seguridad</span>

- **VPC:** 10.0.0.0/16.
- **Subredes:**
  - Pública: 10.0.1.0/24.
  - Privada App: 10.0.2.0/24.
  - Privada DB: 10.0.3.0/24.
- **Internet Gateway:** Conectado a la subred pública.
- **NAT Gateway:** Permite salida a Internet desde las subredes privadas.
- **Tablas de rutas:**
  - Pública → IGW.
  - Privadas → NAT (Una vez instalado el aprovisionamiento, podremos eliminar esta ruta)
- **Grupos de seguridad:** Definidos para aislar tráfico entre capas.

---

## <span style="color:orange">Provisionamiento</span>

Cada instancia se despliega con **aprovisionamiento.sh** que:
- Instalan y configuran Apache, PHP-FPM, NFS y MariaDB.
- Configuran balanceo de carga en Apache (capa 1).
- Montan NFS en los servidores de aplicación (capa 2).
- Crean base de datos y usuario restringido a la subred de aplicación (capa 3).

---

## <span style="color:purple">HTTPS y dominio</span>

- **Elastic IP:** Asignado a la instancia de la capa 1.
- **DNS:** El dominio público apunta al Elastic IP mediante un registro A
- **Redirección:** Todo el tráfico HTTP se redirige automáticamente a HTTPS.

---

## <span style="color:darkcyan">Escalabilidad y alta disponibilidad</span>

- **Aplicación:** Se pueden añadir más servidores Apache en la capa 2 y agregarlos al balanceador.
- **Base de datos:** Puede ampliarse con réplicas o clúster Galera.
- **Balanceador:** Puede escalarse con múltiples instancias y DNS.

---

## <span style="color:brown">Flujo de tráfico</span>

1. El usuario accede al dominio → Elastic IP de la capa 1.
2. El balanceador Apache recibe la petición HTTPS.
3. Apache distribuye la petición a uno de los servidores de aplicación en la capa 2.
4. El servidor de aplicación sirve el contenido desde NFS y consulta la base de datos en la capa 3.
5. La respuesta se devuelve al balanceador y luego al usuario.

---

## <span style="color:crimson">Seguridad</span>

- Solo la capa 1 es accesible desde Internet.
- La capa 3 (DB) está aislada y solo acepta tráfico desde la capa 2.
- La comunicación entre capas está controlada por grupos de seguridad.

---

## <span style="color:teal">Requisitos previos</span>

- Cuenta AWS activa.
- Conectividad a los servicios aws

## Autor

Ricardo Frutos Bravo
