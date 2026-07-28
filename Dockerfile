FROM ubuntu:22.04

# Prevent interactive prompts freezing the installation layer
ENV DEBIAN_FRONTEND=noninteractive

# Install all critical utilities, build tools, Node, and WebKit development libraries
# Explicitly including clang-14 and libwebkit2gtk-4.1-dev to clear the missing shared library error!
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
    nodejs \
    npm \
    android-sdk \
    && rm -rf /var/lib/apt/lists/*

# Map precise configuration path variables directly into the OS framework
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV PATH="${PATH}:${JAVA_HOME}/bin:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools"

# Set up standard application directory links
WORKDIR /app

# Install Gradio web interface components into Python pipeline context
RUN pip3 install gradio

# Install the Socket Supply Co. CLI compiler engine globally
RUN npm install -g @socketsupply/socket

# Accept Android structural operating licenses securely 
RUN yes | sdkmanager --licenses || true

# Copy application configuration architecture files into the container
COPY . .

# Execute your Gradio Python controller engine script
CMD ["python3", "app.py"]
