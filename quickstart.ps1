#!/bin/bash
# AgriChain Quick Start Script for Windows PowerShell

echo "╔════════════════════════════════════════════════════════════╗"
echo "║          AgriChain - Quick Start Script                   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Function to start backend
start_backend() {
    echo "📦 Starting Backend Server..."
    cd C:\Users\sabaa\OneDrive\Desktop\agrichain\backend
    npm start
}

# Function to start frontend
start_frontend() {
    echo "🎨 Starting Frontend Server..."
    cd C:\Users\sabaa\OneDrive\Desktop\agrichain
    npx serve frontend
}

# Function to test API
test_api() {
    echo "🧪 Testing API Health..."
    $response = Invoke-WebRequest -Uri "http://localhost:5000/api/health" -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ API is responding"
        $response.Content
    } else {
        Write-Host "✗ API not responding. Make sure backend is running."
    }
}

# Check if running in PowerShell
if ($PSVersionTable.PSVersion.Major -lt 5) {
    echo "⚠️  This script requires PowerShell 5.0 or higher"
    exit 1
}

echo "Choose an option:"
echo "1) Start Backend"
echo "2) Start Frontend"
echo "3) Test API Health"
echo "4) Start Both (requires 2 terminal windows)"
echo ""
Read-Host -Prompt "Enter choice (1-4)" | ForEach-Object {
    switch ($_) {
        "1" { start_backend }
        "2" { start_frontend }
        "3" { test_api }
        "4" {
            Write-Host "Please open 2 separate terminals"
            Write-Host "Terminal 1: npm start (from backend folder)"
            Write-Host "Terminal 2: npx serve frontend (from root folder)"
        }
        default { echo "Invalid choice" }
    }
}
