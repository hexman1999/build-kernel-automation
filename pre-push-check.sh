#!/bin/bash
# Pre-Push Checklist Script
# Run this to verify everything is ready before pushing to GitHub

set -e

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  Kernel Build Automation - Pre-Push Checklist           ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERRORS=0
WARNINGS=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

check_file() {
    local file=$1
    local name=$2
    if [ -f "$SCRIPT_DIR/$file" ]; then
        echo -e "${GREEN}✓${NC} $name"
    else
        echo -e "${RED}✗${NC} $name (NOT FOUND)"
        ((ERRORS++))
    fi
}

check_dir() {
    local dir=$1
    local name=$2
    if [ -d "$SCRIPT_DIR/$dir" ]; then
        echo -e "${GREEN}✓${NC} $name"
    else
        echo -e "${RED}✗${NC} $name (NOT FOUND)"
        ((ERRORS++))
    fi
}

check_file_content() {
    local file=$1
    local pattern=$2
    local name=$3
    if grep -q "$pattern" "$SCRIPT_DIR/$file" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $name"
    else
        echo -e "${YELLOW}!${NC} $name (Pattern not found)"
        ((WARNINGS++))
    fi
}

# Workflow files
echo "GitHub Actions Workflows:"
check_file ".github/workflows/build.yml" "KernelSU Next workflow"
check_file ".github/workflows/build-kowsu.yml" "Kowsu workflow"

# Scripts
echo ""
echo "Build Scripts:"
check_file "scripts/setup-environment.sh" "Environment setup script"
check_file "scripts/apply-patches.sh" "Patch application script"
check_file "scripts/add-security-features.sh" "Security features script"

# Directories
echo ""
echo "Required Directories:"
check_dir ".github/workflows" ".github/workflows directory"
check_dir "scripts" "scripts directory"
check_dir "patches" "patches directory"

# Configuration
echo ""
echo "Configuration Files:"
check_file "device-sweet.conf" "Device configuration"
check_file ".gitignore" "Git ignore file"

# Documentation
echo ""
echo "Documentation:"
check_file "README.md" "Main README"
check_file "QUICKSTART.md" "Quick start guide"
check_file "PATCH_REFERENCES.md" "Patch references"
check_file "SETUP_COMPLETE.md" "Setup summary"
check_file "START_HERE.md" "Quick reference"

# Helper
echo ""
echo "Helper Scripts:"
check_file "build-helper.sh" "Build helper script"

# Workflow content checks
echo ""
echo "Workflow Content Verification:"
check_file_content ".github/workflows/build.yml" "KernelSU Next" "KernelSU Next in build.yml"
check_file_content ".github/workflows/build.yml" "KOWX712" "Kowsu mention in build.yml"
check_file_content ".github/workflows/build-kowsu.yml" "KOWX712/KernelSU" "Kowsu repo in build-kowsu.yml"
check_file_content ".github/workflows/build-kowsu.yml" "kowsu_variant" "Kowsu variant option"

# Script content checks
echo ""
echo "Script Content Verification:"
check_file_content "scripts/add-security-features.sh" "KernelSU Next" "KernelSU Next in security script"
check_file_content "scripts/add-security-features.sh" "KOWX712" "Kowsu reference in security script"
check_file_content "scripts/apply-patches.sh" "LN8K" "LN8000 patches in apply script"

# Configuration checks
echo ""
echo "Configuration Verification:"
check_file_content "device-sweet.conf" "DEVICE_NAME" "Device name in config"
check_file_content "device-sweet.conf" "sweet_defconfig" "Sweet defconfig in config"

# Important content checks
echo ""
echo "Critical Content Checks:"

if grep -q "4.14" "$SCRIPT_DIR/.github/workflows/build.yml"; then
    echo -e "${GREEN}✓${NC} 4.14 kernel mentioned in build.yml"
else
    echo -e "${YELLOW}!${NC} 4.14 kernel not explicitly mentioned"
    ((WARNINGS++))
fi

if grep -q "PixelOS-Devices/android_kernel_xiaomi_sm6150" "$SCRIPT_DIR/.github/workflows/build.yml"; then
    echo -e "${GREEN}✓${NC} Kernel source URL present"
else
    echo -e "${YELLOW}!${NC} Kernel source URL may need update"
    ((WARNINGS++))
fi

if grep -q "CONFIG_KPROBES=y" "$SCRIPT_DIR/scripts/add-security-features.sh"; then
    echo -e "${GREEN}✓${NC} Kprobes configuration present"
else
    echo -e "${RED}✗${NC} Kprobes configuration missing"
    ((ERRORS++))
fi

# Summary
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                    SUMMARY                               ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}Errors: 0${NC}"
else
    echo -e "${RED}Errors: $ERRORS${NC}"
fi

if [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}Warnings: 0${NC}"
else
    echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
fi

echo ""

# Action items
if [ $ERRORS -eq 0 ]; then
    echo "✅ All checks passed! Ready to push to GitHub."
    echo ""
    echo "Next steps:"
    echo "1. Update kernel source URL in workflow files"
    echo "2. Commit changes: git add . && git commit -m 'Add kernel automation'"
    echo "3. Push to GitHub: git push origin main"
    echo "4. Go to Actions tab and run a workflow"
    exit 0
else
    echo -e "${RED}✗ Fix the errors above before pushing${NC}"
    exit 1
fi
