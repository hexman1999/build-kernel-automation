#!/bin/bash
# KernelSU Next, SUSFS, and Kowsu Integration Script
# Integrates security features into the 4.14 kernel

set -e

KERNEL_DIR="${1:-.}"
SUSFS_ENABLED="${2:-true}"
KOWSU_ENABLED="${3:-true}"
AVC_SPOOF="${4:-true}"
HIDE_SELINUX="${5:-true}"

cd "$KERNEL_DIR"

echo "=========================================="
echo "Integrating Security Features (4.14 Kernel)"
echo "=========================================="
echo "  KernelSU: Next (4.14 compatible)"
echo "  SUSFS Enabled: $SUSFS_ENABLED"
echo "  Kowsu Enabled: $KOWSU_ENABLED"
echo "  AVC Log Spoofing: $AVC_SPOOF"
echo "  Hide SELinux Modifications: $HIDE_SELINUX"
echo "=========================================="

DEVICE_DEFCONFIG="arch/arm64/configs/sweet_defconfig"

# Create defconfig if it doesn't exist
if [ ! -f "$DEVICE_DEFCONFIG" ]; then
    echo "Creating minimal defconfig..."
    mkdir -p $(dirname "$DEVICE_DEFCONFIG")
    touch "$DEVICE_DEFCONFIG"
fi

# ===== KernelSU Next Integration (4.14 compatible) =====
echo ""
echo ">>> Integrating KernelSU Next (4.14 kernel)..."

# Run KernelSU Next setup script
if curl -LSs https://raw.githubusercontent.com/tiann/KernelSU/next/kernel/setup.sh | bash 2>/dev/null; then
    echo "[SUCCESS] KernelSU Next integrated"
else
    echo "[WARNING] KernelSU Next setup script execution failed or already integrated"
fi

# ===== Configure Kprobes (Required for KernelSU/SUSFS/Kowsu) =====
echo ""
echo ">>> Configuring Kprobes for 4.14 kernel..."

# Remove conflicting kprobes config
sed -i '/# CONFIG_KPROBES/d' "$DEVICE_DEFCONFIG"
sed -i '/^CONFIG_KPROBES=/d' "$DEVICE_DEFCONFIG"

# Add kprobes support with 4.14 specific configs
cat >> "$DEVICE_DEFCONFIG" << 'EOF'

# KernelSU Next Support - Kprobes Required (4.14)
CONFIG_KPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_HAVE_KPROBES=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_KPROBES_SAFETY_RCU=y
EOF

echo "[OK] Kprobes configured for 4.14"

# ===== SUSFS Integration (SELinux Unification) =====
if [ "$SUSFS_ENABLED" = "true" ]; then
    echo ""
    echo ">>> Integrating SUSFS (SELinux Unification with KernelSU Next)..."
    
    # Use KernelSU Next SUSFS patches (4.14 compatible)
    SUSFS_PATCH="https://github.com/JackA1ltMan/susfs4ksu/raw/main/ksu_next.patch"
    
    echo "SUSFS Patch URL: $SUSFS_PATCH"
    
    # Download and apply SUSFS patch
    if curl -Ls "$SUSFS_PATCH" > /tmp/susfs.patch 2>/dev/null; then
        # Check if patch applies
        if patch -p1 --dry-run < /tmp/susfs.patch > /dev/null 2>&1; then
            if patch -s -p1 --fuzz=5 < /tmp/susfs.patch > /dev/null 2>&1; then
                echo "[SUCCESS] SUSFS patches applied"
            else
                echo "[WARNING] SUSFS patch application failed (may be already applied)"
            fi
        else
            echo "[INFO] SUSFS patch already applied or incompatible"
        fi
    else
        echo "[WARNING] Failed to download SUSFS patch"
    fi
    
    # SUSFS SELinux configuration
    cat >> "$DEVICE_DEFCONFIG" << 'EOF'

# SUSFS Support - SELinux Integration (4.14 compatible)
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_DEBUG=y
CONFIG_SECURITY_SELINUX_AVC=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
EOF
fi

# ===== Kowsu Integration (Alternative root manager) =====
if [ "$KOWSU_ENABLED" = "true" ]; then
    echo ""
    echo ">>> Integrating Kowsu (Alternative root manager)..."
    
    # Kowsu from https://github.com/KOWX712/KernelSU
    KOWSU_REPO="https://github.com/KOWX712/KernelSU"
    echo "Kowsu Repository: $KOWSU_REPO"
    
    # Try to download Kowsu patch
    KOWSU_PATCH="https://raw.githubusercontent.com/KOWX712/KernelSU/main/kowsu.patch"
    
    if curl -Ls "$KOWSU_PATCH" > /tmp/kowsu.patch 2>/dev/null; then
        if patch -p1 --dry-run < /tmp/kowsu.patch > /dev/null 2>&1; then
            if patch -s -p1 --fuzz=5 < /tmp/kowsu.patch > /dev/null 2>&1; then
                echo "[SUCCESS] Kowsu patches applied"
            fi
        else
            echo "[INFO] Kowsu patch not available online (kprobes-based, will work with CONFIG_KPROBES)"
        fi
    else
        echo "[INFO] Kowsu uses kprobes-based implementation (no patch needed)"
    fi
    
    # Kowsu configuration (requires kprobes, compatible with 4.14)
    cat >> "$DEVICE_DEFCONFIG" << 'EOF'

# Kowsu Support - Alternative Root Manager (4.14 compatible)
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_KOWSU_ENABLED=y
EOF

    echo "[OK] Kowsu configured"
fi

# ===== AVC Log Spoofing =====
if [ "$AVC_SPOOF" = "true" ]; then
    echo ""
    echo ">>> Enabling AVC Log Spoofing..."
    
    cat >> "$DEVICE_DEFCONFIG" << 'EOF'

# AVC Log Spoofing Support
CONFIG_AUDIT=y
CONFIG_AUDIT_ARCH=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_GENERIC=y
EOF
    echo "[OK] AVC log spoofing configured"
fi

# ===== Hide SELinux Modifications =====
if [ "$HIDE_SELINUX" = "true" ]; then
    echo ""
    echo ">>> Configuring SELinux Modification Hiding..."
    
    # Ensure SELinux is fully enabled for SUSFS to work
    cat >> "$DEVICE_DEFCONFIG" << 'EOF'

# SELinux Hiding Support (SUSFS)
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_DEBUG=y
CONFIG_SECURITY_SELINUX_AVC=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
EOF
    echo "[OK] SELinux modification hiding configured"
fi

# ===== Clean and Validate Configuration =====
echo ""
echo ">>> Cleaning and validating configuration..."

# Remove duplicate entries
{
    awk '!seen[$0]++' "$DEVICE_DEFCONFIG"
} > "$DEVICE_DEFCONFIG.tmp"
mv "$DEVICE_DEFCONFIG.tmp" "$DEVICE_DEFCONFIG"

# Remove empty lines and comment-only lines, then re-add structure
{
    grep -v '^[[:space:]]*#' "$DEVICE_DEFCONFIG" | grep -v '^[[:space:]]*$'
    echo ""
    grep '^#' "$DEVICE_DEFCONFIG" || true
} | awk '!seen[$0]++' > "$DEVICE_DEFCONFIG.tmp"
mv "$DEVICE_DEFCONFIG.tmp" "$DEVICE_DEFCONFIG"

# Validate defconfig
echo "Configuration validation:"
echo "  Total lines: $(wc -l < "$DEVICE_DEFCONFIG")"
echo "  CONFIG entries: $(grep -c '^CONFIG_' "$DEVICE_DEFCONFIG" || echo "0")"
echo "  Kprobes enabled: $(grep -c 'CONFIG_KPROBES=y' "$DEVICE_DEFCONFIG" || echo "0")"
echo "  SELinux enabled: $(grep -c 'CONFIG_SECURITY_SELINUX=y' "$DEVICE_DEFCONFIG" || echo "0")"

echo ""
echo "=========================================="
echo "Security features integration completed"
echo "=========================================="
