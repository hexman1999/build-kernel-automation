# Quick Start Guide

## 5-Minute Setup

### Step 1: Prepare Your Repository (2 min)

```bash
# Navigate to your kernel repository
cd your-kernel-repo

# Clone this setup (or copy files manually)
git clone https://github.com/hexman1999/Kernel-Build-Automation temp-setup
cp -r temp-setup/.github .
cp -r temp-setup/scripts .
cp -r temp-setup/patches .
cp temp-setup/device-sweet.conf .
cp temp-setup/README.md SETUP-README.md
rm -rf temp-setup
```

### Step 2: Configure Your Kernel Source (1 min)

Edit `.github/workflows/build.yml` and `.github/workflows/build-kowsu.yml` line 46-49:

```yaml
- name: Download Kernel Source
  run: |
    echo "Cloning kernel source..."
    git clone --depth=1 https://github.com/YOUR-USERNAME/android_kernel_xiaomi_sm6150 kernel -b YOUR-BRANCH
```

### Step 3: Commit and Push (1 min)

```bash
git add .github scripts patches device-sweet.conf SETUP-README.md
git commit -m "Add kernel build automation with KernelSU Next + SUSFS + Kowsu"
git push origin main
```

### Step 4: Run First Build (1 min)

**For KernelSU Next (Default):**
1. Go to GitHub → Actions
2. Click "Build Kernel"
3. Click "Run workflow" 
4. Use default options
5. Watch the build progress!

**For Kowsu (Alternative):**
1. Go to GitHub → Actions
2. Click "Build Kernel with Kowsu"
3. Select variant: `manager` (default) or `systemless`
4. Click "Run workflow"
5. Watch the build progress!

---

## Configuration Options

### KernelSU Next Build (Recommended)
- Root Manager: **KernelSU Next (4.14 optimized)** ✓
- Kowsu: **enabled** ✓ (optional alternative)
- SUSFS: **enabled** ✓
- AVC Log Spoofing: **enabled** ✓
- SELinux Hiding: **enabled** ✓

### Kowsu Build (Alternative)
- Root Manager: **Kowsu manager or systemless**
- Variant: **manager** (default) or **systemless**
- SUSFS: **enabled** ✓
- AVC Log Spoofing: **enabled** ✓
- SELinux Hiding: **enabled** ✓

### Minimal Build (Testing)
- SUSFS: **disabled** ✗
- Kowsu: **disabled** ✗ (KernelSU workflow)
- Create Release: **disabled** ✗

---

## Verify Setup is Working

### Check 1: Files Present

```bash
# Should show these files exist:
ls -la .github/workflows/build.yml
ls -la scripts/setup-environment.sh
ls -la scripts/apply-patches.sh
ls -la scripts/add-security-features.sh
ls -la device-sweet.conf
```

### Check 2: Workflow Visible on GitHub

1. Push to GitHub
2. Go to **Actions** tab
3. Should see "Build Kernel" workflow
4. Should be able to click "Run workflow"

### Check 3: Build Successful

After first build:
1. Check **Actions** tab for build status
2. Download artifacts (should have `.zip` file)
3. Go to **Releases** tab (if auto-release enabled)

---

## Troubleshooting Quick Checks

| Issue | Check | Fix |
|-------|-------|-----|
| Workflow not visible | Push to main branch | Verify files in `.github/workflows/` |
| Build fails | Check logs | Download logs from Actions page |
| No artifacts | Check output paths | Verify kernel compiles to `out/arch/arm64/boot/` |
| Build hangs | Check timeout | Default is 360 minutes (enough) |

---

## Next Steps

1. **Customize patches**: Edit `scripts/apply-patches.sh`
2. **Add custom features**: Modify `device-sweet.conf`
3. **Optimize build**: Adjust flags in `build.yml`
4. **Setup Discord/Telegram**: Add notifications to workflow
5. **Schedule builds**: Use cron in `build.yml` (optional)

---

## File Reference

| File | Purpose | When to Edit |
|------|---------|--------------|
| `.github/workflows/build.yml` | KernelSU Next workflow | Change kernel source, compiler, build flags |
| `.github/workflows/build-kowsu.yml` | Kowsu workflow | Change Kowsu repository, kernel source |
| `scripts/apply-patches.sh` | Patch management | Add custom patches, modify patch order |
| `scripts/add-security-features.sh` | KernelSU/SUSFS setup | Configure security features |
| `scripts/setup-environment.sh` | Build environment | Configure device paths, environment vars |
| `device-sweet.conf` | Device config | Device-specific settings |
| `README.md` | Documentation | Reference guide |

---

**Need Help?** Check the full README.md for detailed documentation!
