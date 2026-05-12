# Patch URLs and References
# Reference file for all patches used in the build process

## LN8000 Charger Patches (sweet-specific)

### Primary LN8000 Charger Support Patches
- Name: LN8K_Charger_Support_1
  URL: https://github.com/crdroidandroid/android_kernel_xiaomi_sm6150/commit/7b73f853977d2c016e30319dffb1f49957d30b40.patch
  Description: LN8000 charging support driver
  Fuzz: 2
  
- Name: LN8K_Charger_Support_2
  URL: https://github.com/crdroidandroid/android_kernel_xiaomi_sm6150/commit/63dddc108d57dc43e1cd0da0f1445875f760cf97.patch
  Description: LN8000 ADC/power profile
  Fuzz: 2

## KPatch and LTO Fixes

### LTO Compatibility for 4.14 Kernel
- Name: LTO_4.14_Fixup
  URL: https://github.com/TheSillyOk/android_kernel_xiaomi_sm6150/commits/main
  Description: LTO and kpatch compatibility fixes for 4.14
  Source: TheSillyOk

## SUSFS (SELinux Unification System)

### SUSFS Patches for KernelSU Integration
- Name: SUSFS_KSU_Next
  URL: https://github.com/JackA1ltMan/susfs4ksu/raw/main/ksu_next.patch
  Description: SUSFS patches for KernelSU Next version
  Fuzz: 5
  Maintained By: JackA1ltMan

- Name: SUSFS_KSU_Latest
  URL: https://github.com/JackA1ltMan/susfs4ksu/raw/main/ksu_latest.patch
  Description: SUSFS patches for KernelSU Latest/Legacy version
  Fuzz: 5
  Maintained By: JackA1ltMan

## KernelSU Integration Scripts

### KernelSU Next Setup (4.14 Optimized)
- Name: KernelSU_Next_Setup
  URL: https://raw.githubusercontent.com/tiann/KernelSU/next/kernel/setup.sh
  Description: Official KernelSU Next kernel integration script (optimized for 4.14)
  Branch: next
  Kernel Support: 4.14.x (Legacy kernels)
  
### Kowsu Integration

#### Kowsu Repository
- Name: Kowsu_KernelSU
  URL: https://github.com/KOWX712/KernelSU
  Description: Kowsu - Alternative KernelSU implementation
  Maintained By: KOWX712
  Type: Alternative root manager

#### Kowsu Patches (if available)
- Name: Kowsu_KProbes
  URL: https://raw.githubusercontent.com/KOWX712/KernelSU/main/kowsu.patch
  Description: Kowsu kprobes-based root manager patches
  Fuzz: 5
  Note: May not be available; relies on kprobes configuration

## Device Tree and DTBO Patches

### DTBO (Device Tree Blob Overlay) Patches
- Name: DTBO_Sweet_Support
  URL: https://github.com/xiaomi-sm6150/android_kernel_xiaomi_sm6150/commits/main
  Description: DTBO patches for sweet device
  Source: xiaomi-sm6150

## Kernel Support Information

### 4.14 Kernel Compatibility

**Sweet Device (Redmi Note 10 Pro)** runs a **4.14.x** legacy kernel that is actively maintained.

**KernelSU Next** is recommended for 4.14 because:
- Better 4.14 kernel architecture support
- Optimized kprobes integration for older kernels
- Stable and tested on 4.14+ kernels
- Better performance on legacy devices

**Configuration for 4.14:**
```
CONFIG_KPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_HAVE_KPROBES=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
```

### Kowsu on 4.14
- Kowsu also uses kprobes-based implementation
- Fully compatible with 4.14 kernel
- Can be used as alternative to KernelSU Next
- Supports both manager and systemless modes

### Kernel Source Repositories

#### PixelOS (Recommended for sweet)
- URL: https://github.com/PixelOS-Devices/android_kernel_xiaomi_sm6150
- Branch: sixteen-qpr2
- Android Versions: 15-16
- Kernel: 4.14.x
- Status: Actively maintained
- LN8000 Support: ✓

#### LineageOS (Alternative)
- URL: https://github.com/LineageOS/android_kernel_xiaomi_sm6150
- Branch: lineage-20 (or current)
- Android Versions: 20 (Android 13)
- Kernel: 4.14.x
- Status: Actively maintained
- LN8000 Support: ✓

#### TBYOOL (MIUI - Community)
- URL: https://github.com/tbyool/android_kernel_xiaomi_sm6150
- Branch: MIUI-buildout
- Android Versions: 11-13
- Kernel: 4.14.x
- Status: Community maintained
- LN8000 Support: ✓

### Toolchain URLs

#### AOSP Clang
- URL: https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/tags/android-{VERSION}.tar.gz/clang/{CLANG_VERSION}.tar.gz
- Latest: r383902 (android-16.0.0_r16)
- Alternative: r416 (older), r370 (older)

#### AOSP GCC
- URL: https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-gnu-{VERSION}.tar.gz
- Latest: aarch64-linux-gnu-11
- Alternative: aarch64-linux-gnu-10, aarch64-linux-gnu-9

### AnyKernel3 Flasher

- URL: https://github.com/osm0sis/AnyKernel3
- Branch: master
- Description: Universal kernel flasher for custom recovery
- Purpose: Package kernel into flashable ZIP

## Patch Application Order

### For KernelSU Next Build
1. **Device-Specific Patches** (LN8K for sweet)
2. **LTO/KPatch Fixes** (4.14 kernel compatibility)
3. **KernelSU Next Integration** (automatic via setup script)
4. **Kprobes Configuration** (CONFIG_KPROBES=y, etc.)
5. **SUSFS Patches** (if enabled)
6. **Security Configuration** (SELinux, Audit, AVC spoofing)

### For Kowsu Build
1. **Device-Specific Patches** (LN8K for sweet)
2. **LTO/KPatch Fixes** (4.14 kernel compatibility)
3. **Kowsu Integration** (clone and setup from KOWX712/KernelSU)
4. **Kprobes Configuration** (required for Kowsu - 4.14 specific)
5. **SUSFS Patches** (if enabled - compatible with Kowsu)
6. **Security Configuration** (SELinux, Audit, AVC spoofing)

## Configuration Flags Reference

### Essential Configs (4.14 Kernel)
- `CONFIG_KPROBES=y` - Required for KernelSU Next/Kowsu
- `CONFIG_SECURITY_SELINUX=y` - SELinux support
- `CONFIG_AUDIT=y` - Audit subsystem for AVC logging

### KernelSU Next Related (4.14 Specific)
- `CONFIG_KPROBES=y` - Kernel probes
- `CONFIG_KPROBES_ON_FTRACE=y` - FTRACE integration
- `CONFIG_HAVE_KPROBES=y` - Architecture support
- `CONFIG_KRETPROBES=y` - Return probes
- `CONFIG_HAVE_KRETPROBES=y` - Architecture support for return probes
- `CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y` - Stack access for 4.14

### Kowsu Related (4.14 Specific)
- `CONFIG_KPROBES=y` - Kprobes (same as above)
- `CONFIG_HAVE_KRETPROBES=y` - Return probes
- `CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y` - Stack access
- `CONFIG_KOWSU_ENABLED=y` - Enable Kowsu

## Adding New Patches

To add a custom patch:

1. Create a `.patch` file:
   ```bash
   git diff > patches/my-custom.patch
   ```

2. Add to `apply-patches.sh`:
   ```bash
   apply_patch "https://example.com/my-patch.patch" "My Custom Patch" "2"
   ```

3. Test with dry-run:
   ```bash
   patch -p1 --dry-run < patches/my-custom.patch
   ```

## Verification URLs

### GitHub Actions Documentation
- https://docs.github.com/en/actions
- https://github.com/features/actions

### Android Kernel Documentation
- https://source.android.com/docs/setup/build/building-kernels
- https://www.kernel.org/doc/

### Device Documentation
- Sweet DeviceTree: https://github.com/xiaomi-sm6150/android_kernel_xiaomi_sm6150

---

**Last Updated**: 2026-05-12
**Workflow Version**: 2.0 (KernelSU Next + Kowsu)
**Kernel Compatibility**: 4.14.x (Sweet/SM6150)

## Workflow Information

### Available Workflows
1. **build.yml** - KernelSU Next (4.14 optimized) with optional Kowsu
2. **build-kowsu.yml** - Kowsu as primary root manager (alternative)

### Differences Between Workflows
| Feature | KernelSU Next | Kowsu |
|---------|---------------|-------|
| Root Manager | KernelSU Next | Kowsu (KOWX712) |
| Implementation | Official | Alternative |
| Variants | Single | Manager/Systemless |
| Kprobes Required | Yes | Yes |
| 4.14 Support | ✓ Optimized | ✓ Compatible |
| SUSFS Compatible | Yes | Yes (Limited testing) |

**Note**: URLs are current as of the update date. Always verify URLs are active before using.
