# Kernel Build Automation for Sweet (Redmi Note 10 Pro)

Automated GitHub Actions workflow to build **KernelSU Next** (4.14 compatible) with SUSFS and advanced SELinux management for the Xiaomi Redmi Note 10 Pro (sweet). Also includes a separate workflow for building with **Kowsu** as an alternative root manager.

## Features

✅ **KernelSU Next (4.14 Compatible)**
- Optimized for 4.14 kernel architecture
- Automatic kernel integration via official setup scripts
- Kprobes support enabled for proper operation
- Better stability on legacy devices

✅ **Kowsu Alternative (Separate Workflow)**
- Alternative root management solution from [KOWX712/KernelSU](https://github.com/KOWX712/KernelSU)
- Works alongside KernelSU Next
- Manager and Systemless variants available
- Kprobes-based implementation

✅ **SUSFS (SELinux Unification System)**
- Hide SELinux modifications from user-space tools
- Xposed/LSPosed module hiding
- Seamless integration with KernelSU

✅ **Kowsu Support**
- Alternative root management solution
- Works alongside KernelSU
- Kprobes-based architecture

✅ **Advanced SELinux Features**
- AVC log spoofing (hide denial logs)
- SELinux modification hiding
- Full audit trail support
- SELinux development mode enabled

✅ **Device-Specific Optimizations**
- LN8000 charger driver patches (sweet-specific)
- LTO (Link Time Optimization) enabled
- LLVM compilation
- Device tree blob optimization

✅ **Build Quality**
- Compiled with `-O3` optimization flags
- LTO thin linking
- AOSP Clang and GCC toolchains
- Non-rooted base kernel (managed by KernelSU)

## Prerequisites

### On Your GitHub Repository

1. **Fork or create a repository** for your kernel source
2. **Enable GitHub Actions** in repository settings
3. **Configure secrets** (if you want auto-releases):
   - Go to Settings → Secrets and variables → Actions
   - Create `GITHUB_TOKEN` (optional, auto-provided by GitHub)

### Files Structure

```
kernel-repo/
├── .github/workflows/
│   └── build.yml                 # Main workflow
├── scripts/
│   ├── setup-environment.sh      # Environment configuration
│   ├── apply-patches.sh          # Patch management
│   └── add-security-features.sh  # KernelSU/SUSFS integration
├── device-sweet.conf             # Device configuration
└── README.md
```

## Setup Instructions

### 1. Copy Files to Your Repository

Place the provided files in your kernel repository:

```bash
# Copy workflow
mkdir -p .github/workflows
cp .github/workflows/build.yml your-kernel-repo/.github/workflows/

# Copy scripts
mkdir -p scripts
cp scripts/*.sh your-kernel-repo/scripts/
chmod +x your-kernel-repo/scripts/*.sh

# Copy configuration
cp device-sweet.conf your-kernel-repo/
```

### 2. Customize Kernel Source (if needed)

Edit `.github/workflows/build.yml` if using a different kernel source:

```yaml
- name: Download Kernel Source
  run: |
    git clone --depth=1 https://github.com/YOUR-FORK/android_kernel_xiaomi_sm6150 kernel -b YOUR-BRANCH
```

### 3. Push to GitHub

```bash
git add .github scripts device-sweet.conf
git commit -m "Add kernel build automation"
git push origin main
```

## Usage

### Workflow 1: Build with KernelSU Next (Default)

1. Go to your repository on GitHub
2. Navigate to **Actions** tab
3. Select **Build Kernel** workflow
4. Click **Run workflow**
5. Configure the inputs (all defaults recommended)

**Output**: Flashable ZIP with KernelSU Next integrated

### Workflow 2: Build with Kowsu (Alternative)

1. Go to your repository on GitHub
2. Navigate to **Actions** tab
3. Select **Build Kernel with Kowsu** workflow
4. Click **Run workflow**
5. Configure the inputs:
   - **Kowsu Variant**: `manager` (default) or `systemless`
   - Other options same as KernelSU workflow

**Output**: Flashable ZIP with Kowsu integrated instead of KernelSU

### Configuration Inputs

#### KernelSU Next Workflow
| Input | Options | Default | Description |
|-------|---------|---------|-------------|
| Enable Kowsu | `true`, `false` | `true` | Enable Kowsu support alongside KernelSU |
| Enable AVC Log Spoofing | `true`, `false` | `true` | Hide AVC denial logs |
| Hide SELinux Modifications | `true`, `false` | `true` | Hide SELinux changes |
| Enable SUSFS | `true`, `false` | `true` | Enable SUSFS patches |
| Create Release | `true`, `false` | `true` | Auto-create GitHub release |

#### Kowsu Workflow
| Input | Options | Default | Description |
|-------|---------|---------|-------------|
| Kowsu Variant | `manager`, `systemless` | `manager` | Kowsu operation mode |
| Enable AVC Log Spoofing | `true`, `false` | `true` | Hide AVC denial logs |
| Hide SELinux Modifications | `true`, `false` | `true` | Hide SELinux changes |
| Enable SUSFS | `true`, `false` | `true` | Enable SUSFS patches |
| Create Release | `true`, `false` | `true` | Auto-create GitHub release |

### Build Output

After successful build:

1. **Flashable ZIP**: Available in Releases section
   - Automatically packaged with AnyKernel3
   - Ready to flash via recovery
   
2. **Artifacts**: Available in Actions → Build artifacts
   - `kernel-sweet-KSU-*.zip` - Flashable kernel package
   - `Image.gz` - Compiled kernel image
   - `dtb.img` - Device tree blob

## Build Matrix

The workflow supports multiple configurations:

```
KernelSU Version: [next, legacy]
SUSFS: [enabled, disabled]
Kowsu: [enabled, disabled]
AVC Spoofing: [enabled, disabled]
SELinux Hiding: [enabled, disabled]
```

You can configure any combination of these options per build.

## Configuration Files

### device-sweet.conf
Device-specific configuration:
- Device names and codes
- Kernel configuration paths
- Build optimization flags
- Device tree blob information
- AnyKernel3 settings

Edit this file to:
- Change optimization flags (e.g., `-O3` to `-O2`)
- Adjust LTO settings (thin vs full)
- Modify toolchain versions
- Update kernel source repository

### .github/workflows/build.yml
Main workflow file. Contains:
- GitHub Actions triggers
- Build steps and sequence
- Environment variables
- Tool versions
- Release configuration

## Advanced Customization

### Adding Custom Patches

1. Create a `patches/` directory in your repository
2. Add patch files with `.patch` extension
3. Edit `scripts/apply-patches.sh` to apply them:

```bash
apply_patch "file:///path/to/your/patch" "Custom Patch Name" "2"
```

### Modifying Build Flags

Edit `.github/workflows/build.yml`:

```yaml
make -j$(nproc) O=out ARCH=${{ env.ARCH }} \
  LLVM=1 \
  LTO=thin \
  LOCALVERSION="-KSU-${{ env.DEVICE }}" \
  Image.gz dtb
```

### Changing Kernel Source

Update the kernel clone URL in `build.yml`:

```yaml
- name: Download Kernel Source
  run: |
    git clone --depth=1 https://your-custom-repo kernel -b custom-branch
```

## Troubleshooting

### Build Fails with "Patch Failed"

**Issue**: A patch doesn't apply cleanly
**Solution**: 
- Check if patch is already applied
- Increase fuzz level (max 3)
- Verify patch compatibility with kernel version

### Kernel Won't Boot

**Issue**: Compiled kernel doesn't boot
**Solution**:
- Verify defconfig matches your ROM
- Check if all required drivers are enabled
- Review kernel version compatibility

### Missing Defconfig

**Issue**: Sweet defconfig not found
**Solution**:
```bash
cd kernel
make ARCH=arm64 savedefconfig
cp defconfig arch/arm64/configs/sweet_defconfig
```

### SUSFS Patch Conflicts

**Issue**: SUSFS patch fails to apply
**Solution**:
- Update SUSFS patch URL in scripts
- Check KernelSU version compatibility
- Try with different fuzz levels

### No Release Created

**Issue**: Build succeeds but no release
**Solution**:
- Enable "Create Release" option in workflow inputs
- Verify GitHub token has write permissions
- Check GitHub Actions logs for errors

## Device Information

**Device**: Redmi Note 10 Pro
- **Codename**: sweet / sweetin
- **SoC**: Qualcomm Snapdragon 732G (SM6150)
- **Architecture**: ARM64 (aarch64)
- **Kernel**: 4.14.x (Legacy but actively maintained)
- **Android Versions**: 11-16 supported
- **Optimizations**: 
  - KernelSU Next (4.14 optimized)
  - LN8000 charger driver support
  - LTO enabled
  - LLVM compilation

### Supported ROMs
- LineageOS 20+ (Android 13+)
- PixelOS 15+ (Android 15+)
- Stock MIUI 11-13
- Custom ROMs based on 4.14 kernel

## Features Explained

### KernelSU Next (4.14 Optimized)
- Modern kernel-level root solution optimized for 4.14 kernel
- Better compatibility with older kernel versions
- No daemon required
- Superior SELinux compatibility
- Recommended for all 4.14-based ROMs
- Better stability on legacy devices

### Kowsu (Alternative Manager)
- Alternative root manager from [KOWX712/KernelSU](https://github.com/KOWX712/KernelSU)
- Kprobes-based implementation
- Two operation modes:
  - **Manager Mode**: Standard root management
  - **Systemless Mode**: Minimal system integration
- Can coexist with KernelSU for advanced use cases
- Hides SELinux-related activities
- Works with Xposed/LSPosed modules
- Invisible to SELinux policy tools
- Essential for systemless modifications

### Kowsu
- Alternative root manager
- Works alongside KernelSU
- Useful for specific modules
- Kprobes-based implementation

### AVC Log Spoofing
- Hides denial logs from audit daemon
- Prevents apps from detecting SELinux enforcement
- Useful for compatibility
- Enabled via audit subsystem

### SELinux Modification Hiding
- Makes SELinux policy changes invisible
- Works with SUSFS integration
- Enables development mode features
- Prevents security policy breakage reporting

## Security Considerations

⚠️ **Important Notes**:

1. **Non-Rooted by Default**: Base kernel has no root; managed by KernelSU
2. **SELinux Protection**: Full SELinux enabled for security
3. **Audit Logging**: Comprehensive audit trail maintained
4. **Module Loading**: Restricted to KernelSU manager app
5. **GIT Verification**: Patches sourced from verified repositories

## Support & Issues

For issues with:
- **Kernel Build**: Check GitHub Actions logs
- **KernelSU**: [KernelSU GitHub](https://github.com/tiann/KernelSU)
- **SUSFS**: [SUSFS GitHub](https://github.com/JackA1ltMan/susfs4ksu)
- **Kowsu**: [Kowsu GitHub](https://github.com/E7KMbb/KoWSU)

## Credits

- **KernelSU**: [tiann/KernelSU](https://github.com/tiann/KernelSU)
- **SUSFS**: [JackA1ltMan](https://github.com/JackA1ltMan/susfs4ksu)
- **Kowsu**: [E7KMbb/KoWSU](https://github.com/E7KMbb/KoWSU)
- **LN8000 Patches**: [crdroidandroid](https://github.com/crdroidandroid)
- **Build Automation**: [Perf Neon Builder](https://github.com/riarumoda/perf_neon-builder)
- **Kernel Base**: [PixelOS-Devices](https://github.com/PixelOS-Devices/android_kernel_xiaomi_sm6150)

## License

GPL-2.0 (Linux Kernel License)

---

**Last Updated**: 2026-05-12
**Workflow Version**: 1.0
**Compatible Kernel**: 4.14.x (Android 11-16)
