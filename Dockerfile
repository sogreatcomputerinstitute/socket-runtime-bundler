FROM ubuntu:22.04

# Prevent interactive prompts freezing the installation layer
ENV DEBIAN_FRONTEND=noninteractive

# Configure environment path structures for Android SDK, Java, and NVM Node links
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV NVM_DIR=/root/.nvm
ENV PATH="${NVM_DIR}/versions/node/v20.11.0/bin:${PATH}:${JAVA_HOME}/bin:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools"

# 1. Install core system components, Java 17, and internal WebKit visual libraries
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
    && rm -rf /var/lib/apt/lists/*

# 2. FIXED: Use the official NVM installation engine to fetch Node.js v20 safely
# This avoids broken URL links, bad file formats, and system cache errors entirely!
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    . "$NVM_DIR/nvm.sh" \
    && nvm install 20.11.0 \
    && nvm use v20.11.0 \
    && nvm alias default 20.11.0

# 3. Install the Socket Supply Co. CLI compiler engine globally
RUN npm install -g @socketsupply/socket

# 4. Accept Android structural operating licenses securely 
RUN yes | sdkmanager --licenses || true

# Setup the runtime application directory
WORKDIR /app

# Install Gradio web interface components into Python pipeline context
RUN pip3 install gradio

# Copy application configuration architecture files into the container
COPY . .

# Execute your Gradio Python controller engine script
CMD ["python3", "app.py"]
