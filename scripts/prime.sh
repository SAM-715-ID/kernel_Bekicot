#! /vendor/bin/sh

# Run under a new tmpfs to avoid /dev selabel
mkdir /dev/ep
mount -t tmpfs nodev /dev/ep

cat /vendor/bin/init.qcom.post_boot.sh > /dev/ep/init.qcom.post_boot.sh

echo '
start vendor.msm_irqbalance

# Re-enable SELinux
echo "97" > /sys/fs/selinux/enforce
' >> /dev/ep/init.qcom.post_boot.sh

mount --bind /dev/ep/init.qcom.post_boot.sh /vendor/bin/init.qcom.post_boot.sh
chmod 755 /vendor/bin/init.qcom.post_boot.sh
chcon "u:object_r:vendor_qti_init_shell_exec:s0" /vendor/bin/init.qcom.post_boot.sh

# Modify /vendor/bin
mkdir /dev/ep/bin
cp -a --preserve=all /vendor/bin/* /dev/ep/bin/
mv /dev/msm_irqbalance /dev/ep/bin/msm_irqbalance
chcon u:object_r:vendor_msm_irqbalanced_exec:s0 /dev/ep/bin/msm_irqbalance
chown root:shell /dev/ep/bin/msm_irqbalance
mount --bind /dev/ep/bin /vendor/bin
