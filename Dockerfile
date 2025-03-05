# Establecer el Sistema Operativo: Ubuntu versión 24.04
# ------------------------------------------------------------------------------
FROM ubuntu:24.04

# Establecer las variables de entorno
# ------------------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/miniconda3/bin:$PATH"

# Instalar las dependencias necesarias básicas
# ------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    vim \
    tree \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
# Instalar locales, para que se puedan usar carácteres especiales de España
# ------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y locales && \
    locale-gen es_ES.UTF-8 && \
    update-locale LANG=es_ES.UTF-8 LC_ALL=es_ES.UTF-8

# Configurar locales
# ------------------------------------------------------------------------------
ENV LANG=es_ES.UTF-8
ENV LC_ALL=es_ES.UTF-8
ENV LANGUAGE=es_ES.UTF-8

# Descargar e instalar Miniconda
# ------------------------------------------------------------------------------
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    -O /root/miniconda.sh && \
    bash /root/miniconda.sh -b -u -p /root/miniconda3 && \
    rm -rf /root/miniconda.sh

# Copiar el ambiente en el contenedor
COPY . /app

# Crear el ambiente de conda con los sofwares necesarios conda
RUN conda env create -f /app/code/conda_env.yaml && conda clean -a -y

# Establecer el ambiente por defecto
ENV CONDA_DEFAULT_ENV=myenv
SHELL ["conda", "run", "-n", "buscador_biota", "/bin/bash", "-c"]

# Verificar que la instalación ha sido correcta
RUN conda info --envs

# Instalar dependencias adicionales por si acaso
RUN pip install --upgrade pip

# Init conda
RUN conda init
RUN source /root/.bashrc

## Activar el ambiente
WORKDIR /app/
RUN activate buscador_biota

# Activar Bash por defecto
# ------------------------------------------------------------------------------
CMD ["/bin/bash"]