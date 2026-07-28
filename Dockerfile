FROM ubuntu:22.04

# Prevent interactive prompts freezing the installation layer
ENV DEBIAN_FRONTEND=noninteractive

# Configure environment path structures for Android SDK, Java, and local utilities
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV PATH="${PATH}:${JAVA_HOME}/bin:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools"

# 1. Install critical system utilities, Java 17, and compiler tools
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

# 2. FIXED: Explicitly download and execute the official NodeSource Node.js v20 Setup Script
# This overwrites Ubuntu's legacy distribution defaults and installs the proper modern runtime environment!
RUN curl -fsSL https://nodesource.com | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

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
