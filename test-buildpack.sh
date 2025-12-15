#!/bin/bash
# Test script for zxing-cpp buildpack

set -e

STACK=${1:-scalingo-22}
BUILDPACK_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "======================================"
echo "Testing zxing-cpp buildpack on $STACK"
echo "======================================"

# Create temporary directories
BUILD_DIR=$(mktemp -d)
CACHE_DIR=$(mktemp -d)
ENV_DIR=$(mktemp -d)

# Cleanup function
cleanup() {
  echo "Cleaning up temporary directories..."
  rm -rf "$BUILD_DIR" "$CACHE_DIR" "$ENV_DIR"
}
trap cleanup EXIT

echo ""
echo "Running buildpack in Docker container ($STACK)..."
echo ""

docker run --rm \
  -v "$BUILDPACK_DIR:/buildpack:ro" \
  -v "$BUILD_DIR:/build" \
  -v "$CACHE_DIR:/cache" \
  -v "$ENV_DIR:/env" \
  "scalingo/$STACK:latest" \
  bash -c "
    set -e
    cd /build

    # Run detect
    echo '===> Running detect'
    /buildpack/bin/detect /build

    # Run compile
    echo ''
    echo '===> Running compile'
    /buildpack/bin/compile /build /cache /env

    # Verify installation
    echo ''
    echo '===> Verifying installation'
    if [ -d /build/.zxing-cpp ]; then
      echo '✓ Installation directory exists'
    else
      echo '✗ Installation directory not found'
      exit 1
    fi

    if [ -f /build/.zxing-cpp/lib/libZXing.so ]; then
      echo '✓ libZXing.so found'
    else
      echo '✗ libZXing.so not found'
      ls -la /build/.zxing-cpp/lib/ || true
      exit 1
    fi

    if [ -d /build/.zxing-cpp/include/ZXing ]; then
      echo '✓ Header files found'
    else
      echo '✗ Header files not found'
      exit 1
    fi

    if [ -f /build/.profile.d/zxing-cpp.sh ]; then
      echo '✓ Environment setup script found'
    else
      echo '✗ Environment setup script not found'
      exit 1
    fi

    echo ''
    echo '===> Installation summary'
    echo 'Installed files:'
    find /build/.zxing-cpp -type f | head -20
    echo '...'

    echo ''
    echo '===> Environment variables'
    cat /build/.profile.d/zxing-cpp.sh
  "

echo ""
echo "======================================"
echo "✓ Test passed for $STACK"
echo "======================================"
