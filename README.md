# Práctica Node, Prometheus y Grafana (docker-compose) 

Práctica de Despliegue de Aplicaciones Web realizada por Jairo Julià Bravo, en la que por mediante de docker-compose debemos crear un sistema compuesto por los servicios de node, prometheus y grafana

## Prometheus
---

Prometheus es una aplicación de software gratuita que se utiliza para registar métricas en tiempo real con una alta dimensionalidad utilizando una base de datos de seires de tiempo construida usando un modelo de extracción HTTP con querys flexibles y en tiempo real. Prometheus tiene una fácil implementación con Grafana.

## Grafana
---

Grafana se ha convertido en la tecnología más popular del mundo utilizada para componer tableros de observación con todo, desde la métrica de Prometeo y Grafito, hasta los registros y datos de aplicaciones de las centrales eléctricas y las colmenas.

## Práctica
---
La práctica consitste en crear un sistema compuesto por los sistemas Node, Prometheus y Grafana descritos anteriormente, de manera que podamos recoger datos, almacenarlos y visualizarlos de una manera mucho más gráfica con la finalidad de aprender nuevas tecnologias y afianzar conocimintos de Docker-compose.

## App

La primera parte de la práctica consiste en crear un contenedor llamado myapp_practica mediante un Dockerfile y este contenedor se trata de un servidor express básico.

### Dokerfile

```
FROM node:alpine3.10
WORKDIR /myapp
COPY ./src ./ 
EXPOSE 3000
RUN npm install 
CMD ["node","app.js"]
```

A partir de una aimgen de node (alpine 3.10) crearemos una imagen con una carpeta llamada "myapp" y copiaremos el contenido de nuestro ./src a este directorio, todo esto apuntando al puerto 3000 de nuestro contenedor. Por último ejecutaremos el comando **npm install** que creara la carpeta node_modules y utilizaremos el comando **node app.js** para arrancar el servidor.

A continuación crearemos el contenedor utilizando el Dockerfile descrito anteriormente, para ello en el fichero `docker-compose.yaml` tendremos el siguiente código: 

```
version: "2"
networks:
  network_practica:
services:   
  app:
    build: .
    container_name: myapp_practica
    ports:
      - "83:3000"
    networks: 
      - network_practica  
```

En este fragmento de código creamos el contenedor apartir del Dockerfile, utilizando el mismo contexto (`build: .`) con el nombre **myapp_practica**, utilizando el puerto 82 de nuestra máquina y el 3000 del contenedor. Todo ello irá enlacada a una misma red que compartirán todos los contenedores llamada `network_practica`

## Prometheus

Ester servicio lo crearemos de forma diferente a el de la aplicación ya que este partira de una imagen de dockerHub y lo incluiremos directamente en el fichero `docker-compose.yaml`.

```
version: "2"
networks:
  network_practica:
services:   
  app:
    build: .
    container_name: myapp_practica
    ports:
      - "83:3000"
    networks:
      - network_practica
prometheus:
    image: prom/prometheus:v2.20.1
    container_name: prometheus_practica
    depends_on:
        - app
    volumes:
    - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    command: --config.file=/etc/prometheus/prometheus.yml  
    ports:
        - "9090:9090"
    networks: 
        - network_practica       
```

Podemos observar que este contenedor se creará apartir de una versión específica de promehteus para así evitar incompatibilidades entre versiones, con el nombre `prometheus_practica`, el cual va a depender de el contenedor anterior `app`. Para este contenedor debemos crear un volumen para poder copiar el fichero `prometheus.yml ` que configura este servicio. Como hemos dicho antes todos los contenedores compartirán la misma network y en este caso escucharemos a el puero `9090` tanto en nuestra máquina como en el contenedor.