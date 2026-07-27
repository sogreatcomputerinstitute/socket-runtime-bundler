FROM ubuntu:22.04

# Prevent interactive prompts freezing the installation layer
ENV DEBIAN_FRONTEND=noninteractive

# Configure environment path structures for Android SDK, Java, and local utilities
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:${JAVA_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/34.0.0"

# Install core utilities, Java OpenJDK 17, Python 3, and Linux C++ desktop compilation dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    zip \
    build-essential \
    openjdk-17-jdk \
    pkg-config \
    libgtk-3-dev \
    libwebkit2gtk-4.0-dev \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js v20 (Required to run Socket Supply Co's CLI toolchain)
RUN curl -fsSL https://nodesource.com | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install the Socket Supply Co. CLI compiler engine globally
RUN npm install -g @socketsupply/socket

# Fetch and install Android Command Line Tools securely into system directories
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && curl -o /tmp/cmdline-tools.zip https://google.com \
    && unzip /tmp/cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm /tmp/cmdline-tools.zip

# Auto-accept Android SDK core licenses and install the specific APIs, build tools, and NDK
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "ndk;26.1.10909125"

# Setup the application directory
WORKDIR /app

# Install Gradio web interface components into Python pipeline context
RUN pip3 install gradio

# Copy application configuration architecture files into the container
COPY . .

# Execute your Gradio Python controller engine script
CMD ["python3", "app.py"]
