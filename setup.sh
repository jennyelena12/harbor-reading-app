#!/bin/bash

# Harbor iOS App - Automated Setup Script
# This script generates the complete Xcode project with all configurations

set -e  # Exit on any error

echo "🚀 Harbor - iOS Reading App Setup"
echo "=================================="
echo ""

# Check if we're in the right directory
if [ ! -f "package.swift" ] && [ ! -d "Harbor" ]; then
    echo "❌ Error: Please run this script from the Harbor project root directory"
    echo "Make sure you're in the directory containing 'Harbor/' folder and 'project.yml'"
    exit 1
fi

echo "✅ Found Harbor project files"
echo ""

# Check if XcodeGen is installed
if ! command -v xcodegen &> /dev/null; then
    echo "📦 XcodeGen not found. Installing via Homebrew..."
    echo "   This requires Homebrew. If you don't have it, install from: https://brew.sh"
    brew install xcodegen
    echo "✅ XcodeGen installed"
else
    echo "✅ XcodeGen is already installed"
fi

echo ""
echo "🔨 Generating Xcode project from project.yml..."

# Generate the Xcode project
xcodegen generate --spec project.yml

echo "✅ Xcode project generated: Harbor.xcodeproj"
echo ""

# Verify the project was created
if [ -d "Harbor.xcodeproj" ]; then
    echo "✅ Project structure is ready!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Open the project in Xcode:"
    echo "      → open Harbor.xcodeproj"
    echo ""
    echo "   2. Or open via Xcode.app:"
    echo "      → File → Open → Harbor.xcodeproj"
    echo ""
    echo "   3. Select iPhone 17 simulator"
    echo ""
    echo "   4. Press Cmd+R to build and run"
    echo ""
    echo "🎉 Enjoy Harbor!"
else
    echo "❌ Error: Project generation failed"
    exit 1
fi
