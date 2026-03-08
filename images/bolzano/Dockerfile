FROM nvidia/cuda:13.1.1-cudnn-runtime-ubuntu24.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

# Install system dependencies & common Linux tools
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    bzip2 \
    ca-certificates \
    git \
    zip \
    unzip \
    tar \
    gzip \
    htop \
    vim \
    nano \
    tree \
    jq \
    less \
    openssh-client \
    build-essential \
    libgl1 \
    libglx0 \
    libglvnd0 \
    libegl1 \
    libgles2 \
    libxml2 \
    && rm -rf /var/lib/apt/lists/*

# Install code-server (VS Code in browser)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Rename ubuntu user to jovyan for JupyterHub compatibility
RUN usermod -l jovyan ubuntu && \
    groupmod -n jovyan ubuntu 2>/dev/null || true && \
    usermod -aG users,video jovyan && \
    usermod -d /home/jovyan -m jovyan && \
    mkdir -p /home/jovyan/work && \
    chown -R jovyan:jovyan /home/jovyan /opt

USER jovyan
WORKDIR /home/jovyan

# Install Miniforge (mamba)
RUN wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 5 \
    https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh \
    -O /tmp/miniforge.sh \
    && bash /tmp/miniforge.sh -b -p /opt/conda \
    && rm /tmp/miniforge.sh

ENV PATH=/opt/conda/bin:$PATH

# ── Python 3.12 + JupyterHub/Lab + ML & EDA stack ──────────────────────
RUN mamba install -y -c conda-forge \
    python=3.12 \
    # --- Jupyter ecosystem ---
    jupyterhub=5.2.1 \
    jupyterlab=4.3.4 \
    jupyter-lsp \
    python-lsp-server \
    # --- Data manipulation ---
    numpy \
    pandas \
    # --- Scientific computing ---
    scipy \
    statsmodels \
    # --- Machine Learning ---
    scikit-learn \
    xgboost \
    lightgbm \
    # --- Visualization ---
    matplotlib \
    seaborn \
    plotly \
    # --- Image processing ---
    pillow \
    opencv \
    # --- NLP basics ---
    nltk \
    # --- Utilities ---
    tqdm \
    joblib \
    h5py \
    requests \
    lxml \
    pyyaml \
    && mamba clean -afy

# Install jupyter-server-proxy (for code-server integration)
RUN pip install --no-cache-dir jupyter-server-proxy

# Pre-install VS Code extensions for Python & Jupyter
RUN code-server --install-extension ms-python.python && \
    code-server --install-extension ms-toolsai.jupyter

COPY jupyter_server_config.py /etc/jupyter/
COPY overrides.json /opt/conda/share/jupyter/lab/settings/overrides.json

CMD ["jupyterhub-singleuser"]
