# Usar una imagen base de Ubuntu
FROM ubuntu:20.04

# Configurar el entorno no interactivo para evitar solicitudes de configuración durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar los repositorios y la lista de paquetes
RUN apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y

# Instalar dependencias necesarias
RUN apt-get install -y \
    wget \
    curl \
    unzip \
    ca-certificates \
    lsb-release \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libdbus-1-3 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libx11-6 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxkbcommon0 \
    libxkbfile1 \
    libxrandr2 \
    xdg-utils \
    libgbm1 \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Declarar la variable de arquitectura
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        DEB_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        DEB_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64"; \
    else \
        echo "Arquitectura desconocida"; \
        exit 1; \
    fi && \
    wget -O /tmp/code.deb $DEB_URL

# Instalar el paquete .deb descargado
RUN dpkg -i /tmp/code.deb && apt-get install -f

RUN mkdir -p /home/ubuntu/code

# Crear el directorio de trabajo donde se almacenará el código
WORKDIR /home/ubuntu/code

# Exponer el puerto 8585
EXPOSE 8585

# code serve-web --host 0.0.0.0 --port 8585 --user-data-dir /home/ubuntu/code --connection-token ynoa
CMD ["code", "serve-web", "--host", "0.0.0.0", "--port", "8585", "--user-data-dir", "/home/ubuntu/code", "--connection-token", "ynoa"]
