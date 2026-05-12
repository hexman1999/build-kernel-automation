#!/bin/bash
# Local Build Helper and Verification Script
# Use this to test patches and verify configuration before pushing to GitHub

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KERNEL_DIR="${SCRIPT_DIR}/kernel"
DEVICE="sweet"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║ Kernel Build Helper for $DEVICE                           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Help function
show_help() {
    cat << EOF
Usage: $0 [COMMAND] [OPTIONS]

Commands:
  setup              Setup kernel source and toolchain
  patches            Verify and test patches
  config             Validate kernel configuration
  clean              Clean build artifacts
  verify-urls        Check if patch URLs are accessible
  show-config        Display current configuration
  help               Show this help message

Options for 'patches':
  --dry-run          Test patches without applying
  --force            Force apply patches
  --list             List available patches

Examples:
  $0 setup
  $0 patches --dry-run
  $0 verify-urls
  $0 show-config

EOF
    exit 0
}

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    
    case $status in
        "success") echo -e "${GREEN}[✓]${NC} $message" ;;
        "error") echo -e "${RED}[✗]${NC} $message" ;;
        "warning") echo -e "${YELLOW}[!]${NC} $message" ;;
        "info") echo -e "${BLUE}[i]${NC} $message" ;;
    esac
}

# Check prerequisites
check_prerequisites() {
    echo ""
    echo "Checking prerequisites..."
    
    local missing_tools=()
    
    # Check for required tools
    for tool in git curl patch wget; do
        if ! command -v $tool &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -eq 0 ]; then
        print_status "success" "All prerequisites met"
    else
        print_status "error" "Missing tools: ${missing_tools[*]}"
        echo "Install with: sudo apt-get install ${missing_tools[*]}"
        return 1
    fi
}

# Setup kernel source
setup_kernel() {
    echo ""
    echo "Setting up kernel source and toolchain..."
    
    if [ -d "$KERNEL_DIR" ]; then
        print_status "warning" "Kernel directory already exists"
        read -p "Remove and re-clone? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$KERNEL_DIR"
        else
            print_status "info" "Using existing kernel directory"
            return 0
        fi
    fi
    
    print_status "info" "Cloning kernel source..."
    git clone --depth=1 https://github.com/PixelOS-Devices/android_kernel_xiaomi_sm6150 \
        "$KERNEL_DIR" -b sixteen-qpr2
    
    if [ $? -eq 0 ]; then
        print_status "success" "Kernel source cloned"
        echo "  Location: $KERNEL_DIR"
        echo "  Size: $(du -sh "$KERNEL_DIR" | cut -f1)"
    else
        print_status "error" "Failed to clone kernel source"
        return 1
    fi
}

# Verify patches
verify_patches() {
    local dry_run="${1:---dry-run}"
    
    echo ""
    echo "Verifying patches..."
    
    # Array of patches to check
    declare -a PATCHES=(
        "https://github.com/crdroidandroid/android_kernel_xiaomi_sm6150/commit/7b73f853977d2c016e30319dffb1f49957d30b40.patch:LN8K_1"
        "https://github.com/crdroidandroid/android_kernel_xiaomi_sm6150/commit/63dddc108d57dc43e1cd0da0f1445875f760cf97.patch:LN8K_2"
    )
    
    local success=0
    local failed=0
    
    for patch_info in "${PATCHES[@]}"; do
        IFS=':' read -r url name <<< "$patch_info"
        echo ""
        echo "Patch: $name"
        echo "URL: $url"
        
        if curl -sL "$url" > /tmp/patch_test.patch 2>/dev/null; then
            print_status "info" "Downloaded successfully"
            
            if [ -d "$KERNEL_DIR" ]; then
                cd "$KERNEL_DIR"
                if patch -p1 --dry-run < /tmp/patch_test.patch > /dev/null 2>&1; then
                    print_status "success" "Patch applies cleanly"
                    ((success++))
                else
                    print_status "warning" "Patch may already be applied"
                    ((success++))
                fi
                cd "$SCRIPT_DIR"
            fi
        else
            print_status "error" "Failed to download patch"
            ((failed++))
        fi
    done
    
    echo ""
    echo "Summary: $success successful, $failed failed"
}

# List patches
list_patches() {
    echo ""
    echo "Available Patches:"
    echo ""
    
    echo "LN8000 Charger Support:"
    echo "  1. LN8K_Charger_1"
    echo "     https://github.com/crdroidandroid/android_kernel_xiaomi_sm6150/commit/7b73f853977d2c016e30319dffb1f49957d30b40.patch"
    echo ""
    echo "  2. LN8K_Charger_2"
    echo "     https://github.com/crdroidandroid/android_kernel_xiaomi_sm6150/commit/63dddc108d57dc43e1cd0da0f1445875f760cf97.patch"
    echo ""
    
    echo "Security Features:"
    echo "  - SUSFS (KSU Next): https://github.com/JackA1ltMan/susfs4ksu/raw/main/ksu_next.patch"
    echo "  - SUSFS (KSU Latest): https://github.com/JackA1ltMan/susfs4ksu/raw/main/ksu_latest.patch"
    echo "  - Kowsu: https://raw.githubusercontent.com/E7KMbb/KoWSU/main/kowsu.patch"
    echo ""
}

# Verify URLs
verify_urls() {
    echo ""
    echo "Verifying patch URLs..."
    echo ""
    
    declare -a URLS=(
        "https://raw.githubusercontent.com/tiann/KernelSU/next/kernel/setup.sh:KernelSU Next Setup"
        "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh:KernelSU Legacy Setup"
        "https://github.com/JackA1ltMan/susfs4ksu/raw/main/ksu_next.patch:SUSFS KSU Next"
        "https://github.com/JackA1ltMan/susfs4ksu/raw/main/ksu_latest.patch:SUSFS KSU Latest"
        "https://raw.githubusercontent.com/E7KMbb/KoWSU/main/kowsu.patch:Kowsu Patches"
    )
    
    for url_info in "${URLS[@]}"; do
        IFS=':' read -r url name <<< "$url_info"
        echo -n "Checking $name... "
        
        if curl -sL --head "$url" > /dev/null 2>&1; then
            print_status "success" "$name - OK"
        else
            print_status "error" "$name - FAILED"
        fi
    done
}

# Show configuration
show_configuration() {
    echo ""
    echo "Current Configuration:"
    echo ""
    
    if [ -f "$SCRIPT_DIR/device-sweet.conf" ]; then
        echo "Device Configuration:"
        grep "^[^#]" "$SCRIPT_DIR/device-sweet.conf" | head -10
        echo ""
    fi
    
    if [ -f "$SCRIPT_DIR/.github/workflows/build.yml" ]; then
        echo "Workflow Configuration:"
        grep "env:" -A 10 "$SCRIPT_DIR/.github/workflows/build.yml" | grep -E "^\s+[A-Z_]+:" | head -5
        echo ""
    fi
}

# Validate kernel configuration
validate_config() {
    echo ""
    echo "Validating kernel configuration..."
    
    if [ ! -d "$KERNEL_DIR" ]; then
        print_status "error" "Kernel directory not found. Run 'setup' first."
        return 1
    fi
    
    cd "$KERNEL_DIR"
    
    DEFCONFIG="arch/arm64/configs/sweet_defconfig"
    
    if [ ! -f "$DEFCONFIG" ]; then
        print_status "error" "Defconfig not found at $DEFCONFIG"
        return 1
    fi
    
    echo ""
    print_status "info" "Checking essential configurations..."
    
    configs_to_check=(
        "CONFIG_KPROBES=y:Kprobes support"
        "CONFIG_SECURITY_SELINUX=y:SELinux support"
        "CONFIG_AUDIT=y:Audit framework"
    )
    
    for config_check in "${configs_to_check[@]}"; do
        IFS=':' read -r config desc <<< "$config_check"
        if grep -q "^${config}" "$DEFCONFIG"; then
            print_status "success" "$desc: ENABLED"
        elif grep -q "^# ${config}" "$DEFCONFIG"; then
            print_status "warning" "$desc: DISABLED"
        else
            print_status "warning" "$desc: NOT SET"
        fi
    done
    
    echo ""
    echo "Configuration Stats:"
    echo "  Total lines: $(wc -l < "$DEFCONFIG")"
    echo "  CONFIG entries: $(grep -c "^CONFIG_" "$DEFCONFIG" || echo "0")"
}

# Clean build artifacts
clean_build() {
    echo ""
    echo "Cleaning build artifacts..."
    
    if [ -d "$KERNEL_DIR/out" ]; then
        print_status "info" "Removing kernel output directory..."
        rm -rf "$KERNEL_DIR/out"
        print_status "success" "Cleaned"
    fi
    
    print_status "success" "Cleanup complete"
}

# Main script logic
if [ $# -eq 0 ]; then
    show_help
fi

check_prerequisites || exit 1

case "$1" in
    setup)
        setup_kernel
        ;;
    patches)
        case "${2:---dry-run}" in
            --list)
                list_patches
                ;;
            *)
                verify_patches "$2"
                ;;
        esac
        ;;
    verify-urls)
        verify_urls
        ;;
    config)
        validate_config
        ;;
    show-config)
        show_configuration
        ;;
    clean)
        clean_build
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_status "error" "Unknown command: $1"
        show_help
        ;;
esac

echo ""
echo "Done!"
