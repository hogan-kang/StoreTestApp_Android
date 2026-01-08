#!/bin/bash

# Utility script to sign Android artifacts (APK and AAB)
# Usage: ./sign_artifacts.sh <path-to-unsigned-file> <keystore-path> <key-alias>
# Environment variables KEYSTORE_PASSWORD and KEY_PASSWORD must be set for security.

INPUT_FILE=$1
KEYSTORE_PATH=$2
KEY_ALIAS=$3

if [ -z "$INPUT_FILE" ] || [ -z "$KEYSTORE_PATH" ] || [ -z "$KEY_ALIAS" ]; then
    echo "Usage: ./sign_artifacts.sh <file.apk|file.aab> <keystore.jks> <key-alias>"
    echo "Please set KEYSTORE_PASSWORD and KEY_PASSWORD env vars."
    exit 1
fi

if [[ "$INPUT_FILE" == *.aab ]]; then
    echo "Signing App Bundle (AAB)..."
    OUTPUT_FILE="${INPUT_FILE%.*}-signed.aab"
    
    cp "$INPUT_FILE" "$OUTPUT_FILE"
    
    jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
        -keystore "$KEYSTORE_PATH" \
        -storepass "$KEYSTORE_PASSWORD" \
        -keypass "$KEY_PASSWORD" \
        "$OUTPUT_FILE" "$KEY_ALIAS"
        
    echo "Signed AAB created at: $OUTPUT_FILE"

elif [[ "$INPUT_FILE" == *.apk ]]; then
    echo "Signing APK..."
    ALIGNED_FILE="${INPUT_FILE%.*}-aligned.apk"
    OUTPUT_FILE="${INPUT_FILE%.*}-signed.apk"
    
    # Check for build tools
    if ! command -v zipalign &> /dev/null; then
        echo "Error: zipalign not found. Please add Android SDK build-tools to PATH."
        exit 1
    fi
    
    if ! command -v apksigner &> /dev/null; then
        echo "Error: apksigner not found. Please add Android SDK build-tools to PATH."
        exit 1
    fi

    echo "Running zipalign..."
    zipalign -v -p 4 "$INPUT_FILE" "$ALIGNED_FILE"
    
    echo "Running apksigner..."
    apksigner sign --ks "$KEYSTORE_PATH" \
        --ks-pass env:KEYSTORE_PASSWORD \
        --key-pass env:KEY_PASSWORD \
        --out "$OUTPUT_FILE" \
        "$ALIGNED_FILE"
        
    rm "$ALIGNED_FILE"
    echo "Signed APK created at: $OUTPUT_FILE"

else
    echo "Unsupported file extension. Please provide .apk or .aab"
    exit 1
fi
