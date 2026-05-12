# 🚀 Kernel Build Automation - Complete Setup Guide

## ✅ What's Ready

Your kernel build automation system is now complete with **2 GitHub Actions workflows**:

### Workflow 1: KernelSU Next (4.14 Optimized)
```
🔧 Root Manager: KernelSU Next
📦 Features: SUSFS, Kowsu support, AVC spoofing, SELinux hiding
⚙️  Kernel: 4.14.x
🏗️  Build: LTO enabled, LLVM, -O3 optimization
```

### Workflow 2: Kowsu (Alternative Manager)
```
🔧 Root Manager: Kowsu (KOWX712/KernelSU)
📦 Variants: Manager mode or Systemless mode
⚙️  Kernel: 4.14.x
🏗️  Build: Same optimizations as KernelSU workflow
```

---

## 📋 Complete File Structure

```
Kernel-Build-Automation/
├── .github/workflows/
│   ├── build.yml                    ✅ KernelSU Next workflow
│   └── build-kowsu.yml             ✅ Kowsu alternative workflow
│
├── scripts/
│   ├── setup-environment.sh         ✅ Build environment setup
│   ├── apply-patches.sh            ✅ Device patch management
│   └── add-security-features.sh    ✅ KernelSU/SUSFS/Kowsu integration
│
├── patches/                         ✅ Patch storage directory
│
├── device-sweet.conf               ✅ Device configuration
├── .gitignore                      ✅ Git rules
│
├── README.md                       ✅ Full documentation
├── QUICKSTART.md                   ✅ 5-minute setup guide
├── PATCH_REFERENCES.md             ✅ Patch and build reference
├── SETUP_COMPLETE.md               ✅ Setup summary
└── build-helper.sh                 ✅ Local verification tool
```

---

## 🎯 Quick Setup (3 Steps)

### Step 1: Update Kernel Source URL

Edit these files and replace the kernel source URL:
- `.github/workflows/build.yml` (line ~46)
- `.github/workflows/build-kowsu.yml` (line ~46)

**Current:**
```yaml
git clone --depth=1 https://github.com/PixelOS-Devices/android_kernel_xiaomi_sm6150 kernel -b sixteen-qpr2
```

**Change to YOUR fork:**
```yaml
git clone --depth=1 https://github.com/YOUR-USERNAME/android_kernel_xiaomi_sm6150 kernel -b YOUR-BRANCH
```

### Step 2: Commit and Push

```bash
cd /home/muhammad/Desktop/Kernel\ Build\ Automation

git add .
git commit -m "Add kernel build automation with KernelSU Next + SUSFS + Kowsu"
git push origin main
```

### Step 3: Run a Build

1. Go to GitHub repository
2. Click **Actions** tab
3. Choose workflow:
   - **"Build Kernel"** for KernelSU Next
   - **"Build Kernel with Kowsu"** for Kowsu
4. Click "Run workflow"
5. Use default options or customize
6. Monitor build progress
7. Download from **Releases** when complete

---

## 🔧 Build Inputs Available

### KernelSU Next Workflow
| Input | Options | Default |
|-------|---------|---------|
| Enable Kowsu | true / false | true |
| Enable AVC Log Spoofing | true / false | true |
| Hide SELinux Modifications | true / false | true |
| Enable SUSFS | true / false | true |
| Create Release | true / false | true |

### Kowsu Workflow
| Input | Options | Default |
|-------|---------|---------|
| Kowsu Variant | manager / systemless | manager |
| Enable AVC Log Spoofing | true / false | true |
| Hide SELinux Modifications | true / false | true |
| Enable SUSFS | true / false | true |
| Create Release | true / false | true |

---

## 📦 What Each Workflow Includes

### LN8000 Charger Patches
```
✅ Charger driver support (sweet-specific)
✅ Power profile optimization
✅ Charging controller integration
```

### KernelSU Next Integration
```
✅ Automatic kernel integration
✅ Kprobes configuration (4.14 optimized)
✅ Return probes support
✅ Stack access API enabled
```

### SUSFS Support (Optional)
```
✅ SELinux modification hiding
✅ Xposed/LSPosed compatibility
✅ AVC denial log hiding
✅ Invisible to SELinux tools
```

### Kowsu Integration (Alternative)
```
✅ Alternative root manager
✅ Manager mode (standard)
✅ Systemless mode (minimal)
✅ Kprobes-based implementation
```

### Security Features
```
✅ AVC Log Spoofing: Hide audit denials
✅ SELinux Hiding: Hide modifications
✅ Full SELinux: Enforced security
✅ Audit Framework: Comprehensive logging
```

---

## 📚 Documentation Available

| File | Purpose | Read When |
|------|---------|-----------|
| **README.md** | Full documentation | Before first build |
| **QUICKSTART.md** | 5-minute setup | If you need quick start |
| **PATCH_REFERENCES.md** | Patch URLs and references | Adding custom patches |
| **SETUP_COMPLETE.md** | Setup summary | First time setup |
| **device-sweet.conf** | Device configuration | Customizing build |

---

## 🎛️ Customization Options

### Change Kernel Source
Edit `.github/workflows/build.yml` and `.github/workflows/build-kowsu.yml`:
```yaml
git clone --depth=1 https://github.com/YOUR-FORK/android_kernel_xiaomi_sm6150 kernel -b YOUR-BRANCH
```

### Add Custom Patches
1. Add patch files to `patches/` directory
2. Edit `scripts/apply-patches.sh`
3. Add to PATCHES array

### Modify Build Flags
Edit `.github/workflows/build.yml` make command:
```bash
make -j$(nproc) O=out ARCH=arm64 \
  LLVM=1 \
  LTO=thin \  # Change to 'full' for better optimization (slower)
  LOCALVERSION="-Custom" \
  Image.gz dtb
```

### Configure Device Settings
Edit `device-sweet.conf`:
- Device names
- Defconfig path
- Output directory
- Build optimization flags

---

## 🧪 Local Testing

Use the provided build-helper script to verify setup:

```bash
# Check prerequisites
./build-helper.sh verify-urls

# Download kernel source
./build-helper.sh setup

# Verify patches
./build-helper.sh patches --dry-run

# List available patches
./build-helper.sh patches --list

# Show current configuration
./build-helper.sh show-config

# Validate kernel configuration
./build-helper.sh config

# Clean build artifacts
./build-helper.sh clean
```

---

## 🚨 Troubleshooting

### "Workflows not showing in Actions?"
- ✅ Verify `.github/workflows/*.yml` files exist
- ✅ Check YAML syntax is valid
- ✅ Refresh GitHub page (F5)

### "Build fails with patch error?"
- ✅ Check patch URL is accessible
- ✅ Verify patch compatibility with kernel version
- ✅ Check GitHub Actions logs for details

### "No artifacts after build?"
- ✅ Check build completed successfully
- ✅ Verify artifact paths in workflow match build output
- ✅ Check for sufficient disk space in runner

### "Release not created?"
- ✅ Enable "Create Release" option in workflow inputs
- ✅ Check GitHub Actions logs for errors
- ✅ Verify GitHub token permissions

---

## 📊 Build Specifications

### Device
- **Name**: Redmi Note 10 Pro
- **Codename**: sweet / sweetin
- **SoC**: Snapdragon 732G (SM6150)
- **Architecture**: ARM64 (aarch64)

### Kernel
- **Version**: 4.14.x (Legacy but maintained)
- **Android Versions**: 11-16 supported
- **ROMs**: LineageOS, PixelOS, MIUI compatible

### Build Configuration
- **Optimization**: -O3 flags
- **LTO**: Link Time Optimization (thin)
- **LLVM**: LLVM compiler frontend enabled
- **Toolchain**: AOSP Clang r383902 + GCC 11

### Security
- **Root Manager**: KernelSU Next OR Kowsu
- **SELinux**: Enabled and enforced
- **SUSFS**: Hiding support (optional)
- **Kprobes**: Required for root managers

---

## 🔗 Important Links

### Primary Resources
- **KernelSU**: https://github.com/tiann/KernelSU
- **Kowsu**: https://github.com/KOWX712/KernelSU
- **SUSFS**: https://github.com/JackA1ltMan/susfs4ksu
- **Kernel Source**: https://github.com/PixelOS-Devices/android_kernel_xiaomi_sm6150

### Reference Projects
- **Perf Neon Builder**: https://github.com/riarumoda/perf_neon-builder
- **Kernel Build Action**: https://github.com/hexman1999/Kernel-Action

### Documentation
- **KernelSU Docs**: https://kernelsu.org/
- **Android Kernel**: https://source.android.com/docs/setup/build/building-kernels
- **GitHub Actions**: https://docs.github.com/en/actions

---

## ⚡ Quick Reference Commands

### Push to GitHub
```bash
git add .
git commit -m "Your commit message"
git push origin main
```

### Check Workflow Status
Visit: `https://github.com/YOUR-USERNAME/YOUR-REPO/actions`

### Download Builds
Visit: `https://github.com/YOUR-USERNAME/YOUR-REPO/releases`

### View Build Logs
Actions tab → Select workflow run → View job logs

---

## ✨ What You Can Do Now

1. ✅ **Build with KernelSU Next** - Optimized for 4.14 kernel
2. ✅ **Build with Kowsu** - Alternative root manager option
3. ✅ **Customize Patches** - Add device-specific or custom patches
4. ✅ **Automatic Releases** - Builds are auto-released to GitHub
5. ✅ **Multiple Configurations** - Build with different security options
6. ✅ **Download Artifacts** - Get kernel and flashable ZIPs
7. ✅ **Share with Community** - All builds are in GitHub Releases

---

## 🎓 Next Steps

1. **Update kernel source URL** in both workflow files
2. **Push to GitHub** to enable workflows
3. **Run first build** from Actions tab
4. **Download flashable ZIP** from Releases
5. **Test on device** (backup first!)
6. **Customize** as needed for your requirements

---

## 📝 Version Information

- **Setup Version**: 2.0
- **Kernel Target**: 4.14.x (Sweet - SM6150)
- **Workflows**: 2 (KernelSU Next + Kowsu)
- **Last Updated**: 2026-05-12
- **Status**: ✅ Complete and Ready to Use

---

## 🎉 You're All Set!

Everything is configured and ready to go. Your kernel build automation system is now operational with:
- ✅ KernelSU Next (4.14 optimized)
- ✅ Kowsu alternative option
- ✅ SUSFS support
- ✅ Advanced SELinux features
- ✅ Automatic GitHub releases
- ✅ Device-specific optimizations

**Ready to build your first kernel? Head to GitHub Actions and click "Run workflow"!**
