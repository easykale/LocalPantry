# Use the official SwiftWasm image (Swift for WebAssembly)
# This is required to build SwiftUI-compatible apps (Tokamak) on Linux
FROM ghcr.io/swiftwasm/swift:latest

# Install basic development tools and system dependencies
RUN apt-get update && apt-get install -y \
    git \
    make \
    curl \
    libncurses5 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy your project files into the container
COPY . .

# Resolve Swift package dependencies
# This will pull in Tokamak (the SwiftUI implementation) if defined in Package.swift
RUN swift package resolve

# Command to build the project for WebAssembly
# Note: You can change 'build' to 'test' or 'run' depending on needs
CMD ["swift", "build", "--triple", "wasm32-unknown-wasi"]