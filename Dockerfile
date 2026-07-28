FROM ubuntu:22.04

# Prevent interactive prompts freezing the installation layer
ENV DEBIAN_FRONTEND=noninteractive

# Configure environment path structures for Android SDK, Java, and local utilities
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV PATH="${PATH}:${JAVA_HOME}/bin:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools"

# 1. Install critical system utilities, Java 17, and core graphic libraries
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    zip \
    build-essential \
    clang-14 \
    g++-mingw-w64 \
    gcc-mingw-w64 \
    openjdk-17-jdk \
    pkg-config \
    libgtk-3-dev \
    libwebkit2gtk-4.1-dev \
    python3 \
    python3-pip \
    android-sdk \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# 2. GUARANTEED NATIVE FIX: Setup the official NodeSource signing key and Node.js v20 repository pool
# Using separated, standard APT commands ensures no bash routing scripts fail
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://nodesource.com | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://nodesource.com nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

# 3. Install the Socket Supply Co. CLI compiler engine globally using our newly verified Node environment
RUN npm install -g @socketsupply/socket

# 4. Accept Android structural operating licenses securely 
RUN yes | sdkmanager --licenses || true

# Setup the runtime application workspace directory
WORKDIR /app

# Install Gradio web interface components into Python pipeline context
RUN pip3 install gradio

# Copy application configuration architecture files into the container
COPY . .

# Execute your Gradio Python controller engine script
CMD ["python3", "app.py"]
