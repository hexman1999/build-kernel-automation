#!/bin/bash
# Setup Build Environment for Sweet Device
# This script prepares the build environment and configurations

set -e

DEVICE="${1:-sweet}"
KERNEL_DIR="${2:-.}"
DEVICE_DEFCONFIG="${DEVICE}_defconfig"
ARCH="arm64"

echo "=========================================="
echo "Setting up build environment for $DEVICE"
echo "=========================================="

# Check if kernel directory exists
if [ ! -d "$KERNEL_DIR" ]; then
    echo "Error: Kernel directory $KERNEL_DIR not found"
    exit 1
fi

cd "$KERNEL_DIR"

# Create output directory
mkdir -p out

# Device-specific configurations
case $DEVICE in
    sweet)
        echo "Configuring for Redmi Note 10 Pro (sweet)"
        KERNEL_CONFIG="arch/arm64/configs/${DEVICE_DEFCONFIG}"
        DTB_BINARY="out/arch/arm64/boot/dtb.img"
        ;;
    *)
        echo "Unknown device: $DEVICE"
        exit 1
        ;;
esac

# Verify defconfig exists
if [ ! -f "$KERNEL_CONFIG" ]; then
    echo "Warning: Defconfig not found at $KERNEL_CONFIG"
    echo "Creating minimal defconfig..."
    mkdir -p "$(dirname "$KERNEL_CONFIG")"
    touch "$KERNEL_CONFIG"
fi

# Export environment variables
export DEVICE=$DEVICE
export DEVICE_DEFCONFIG=$DEVICE_DEFCONFIG
export ARCH=$ARCH
export KERNEL_CONFIG=$KERNEL_CONFIG
export DTB_BINARY=$DTB_BINARY

# Display configuration
echo ""
echo "Configuration Summary:"
echo "  Device: $DEVICE"
echo "  Defconfig: $DEVICE_DEFCONFIG"
echo "  Architecture: $ARCH"
echo "  Kernel Config: $KERNEL_CONFIG"
echo "  DTB Binary: $DTB_BINARY"
echo ""

# Source environment for next steps
env | grep -E "^(DEVICE|KERNEL_CONFIG|ARCH)=" > "$KERNEL_DIR/build.env"
echo "Environment saved to build.env"
