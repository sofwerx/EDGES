#!/system/bin/sh
echo "In chroot.sh..."
#if ! mount | grep -v grep | grep /data/local/nhsystem/kali-armhf/proc ; then
  mount --bind /proc/ /data/local/nhsystem/kali-armhf/proc/ > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /data/local/nhsystem/kali-armhf/dev ; then
  mount --bind /dev/ /data/local/nhsystem/kali-armhf/dev/ > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /data/local/nhsystem/kali-armhf/sys ; then
  mount --bind /sys/ /data/local/nhsystem/kali-armhf/sys/ > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /data/local/nhsystem/kali-armhf/dev/pts ; then
  mount -t devpts devpts /data/local/nhsystem/kali-armhf/dev/pts > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /dev/pts ; then
  mount -t devpts devpts /dev/pts > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /data/usr; then
  mount --bind /data/local/nhsystem/kali-armhf/usr /data/usr > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /data/bin; then
  mount --bind /data/local/nhsystem/kali-armhf/bin /data/bin > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /data/lib; then
  mount --bind /data/local/nhsystem/kali-armhf/lib /data/lib > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /data/var; then
  mount --bind /data/local/nhsystem/kali-armhf/var /data/var > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /data/run; then
  mount --bind /data/local/nhsystem/kali-armhf/run /data/run > /dev/null 2>&1
#fi
#if ! mount | grep /sys/fs/cgroup | grep tmpfs ; then
  mount -t tmpfs -o rw,relatime,seclabel,mode=755 tmpfs /sys/fs/cgroup > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/cpuset; then
  mkdir -p /sys/fs/cgroup/cpuset
  mount -t cgroup -o rw,relatime,cpuset,release_agent=/sbin/cpuset_release_agent cgroup /sys/fs/cgroup/cpuset > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/cpu; then
  mkdir -p /sys/fs/cgroup/cpu
  mount -t cgroup -o rw,relatime,cpu cgroup /sys/fs/cgroup/cpu > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/cpuacct; then
  mkdir -p /sys/fs/cgroup/cpuacct
  mount -t cgroup -o rw,relatime,cpuacct cgroup /sys/fs/cgroup/cpuacct > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/schedtune; then
  mkdir -p /sys/fs/cgroup/schedtune
  mount -t cgroup -o rw,relatime,schedtune cgroup /sys/fs/cgroup/schedtune > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/blkio; then
  mkdir -p /sys/fs/cgroup/blkio
  mount -t cgroup -o rw,relatime,blkio cgroup /sys/fs/cgroup/blkio > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/memory; then
  mkdir -p /sys/fs/cgroup/memory
  mount -t cgroup -o rw,relatime,memory cgroup /sys/fs/cgroup/memory > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/devices; then
  mkdir -p /sys/fs/cgroup/devices
  mount -t cgroup -o rw,relatime,devices cgroup /sys/fs/cgroup/devices > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/freezer; then
  mkdir -p /sys/fs/cgroup/freezer
  mount -t cgroup -o rw,relatime,freezer cgroup /sys/fs/cgroup/freezer > /dev/null 2>&1
#fi
#if ! mount |grep -v grep | grep /sys/fs/cgroup/net_cls; then
  mkdir -p /sys/fs/cgroup/net_cls
  mount -t cgroup -o rw,relatime,net_cls cgroup /sys/fs/cgroup/net_cls > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/perf_event; then
  mkdir -p /sys/fs/cgroup/perf_event
  mount -t cgroup -o rw,relatime,perf_event cgroup /sys/fs/cgroup/perf_event > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/net_prio; then
  mkdir -p /sys/fs/cgroup/net_prio
  mount -t cgroup -o rw,relatime,net_prio cgroup /sys/fs/cgroup/net_prio > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/pids; then
  mkdir -p /sys/fs/cgroup/pids
  mount -t cgroup -o rw,relatime,pids cgroup /sys/fs/cgroup/pids > /dev/null 2>&1
#fi
#if ! mount | grep -v grep | grep /sys/fs/cgroup/debug; then
  mkdir -p /sys/fs/cgroup/debug
  mount -t cgroup -o rw,relatime,debug cgroup /sys/fs/cgroup/debug > /dev/null 2>&1
#fi
export PATH=/usr/bin:/bin:/usr/local/bin:/usr/sbin:/sbin:/usr/local/sbin:$PATH
# echo "Running powers.sh..."
# exec /system/bin/chroot /data/local/nhsystem/kali-armhf/ /EDGES/hackrf/powers.sh
#/system/bin/toybox chroot /data/local/nhsystem/kali-armhf/ /EDGES/hackrf/powers.sh

echo "Running hackrf_sweep..."

exec /system/bin/chroot /data/local/nhsystem/kali-armhf/ /usr/local/bin/hackrf_sweep -1 -f1:7250 -w 100000 -l32 -g8 >> edges-ongoing.json 2>/dev/null
# exec /system/bin/chroot /data/local/nhsystem/kali-armhf/ /usr/local/bin/hackrf_sweep -1 -f1:7250 -w 100000 -l32 -g8
#>> edges-ongoing.json 2>/dev/null
# /data/local/nhsystem/kali-armhf/usr/bin/python -c 'import pty; pty.spawn("/system/bin/chroot /data/local/nhsystem/kali-armhf/ /usr/local/bin/hackrf_sweep -1 -f1:7250 -w 100000 -l32 -g8 2>&1")';
#/dev/null # | grep 2018 | ./sorter.pl

# set -eo pipefail
filename=edges-$(date +%Y%m%d%H%M%S).json
# exit_script() {
#   echo '{ "final":true } ] }' >> $filename
#   trap - SIGINT SIGTERM # clear the trap
#   kill -- -$$ # Sends SIGTERM to child/sub processes
# }
# trap exit_script SIGINT SIGTERM
(
  echo '{ "edges": ['
  first=true
  while true ; do
     if $first ; then
       echo "  {"
       first=false
     else
       echo ","
       echo "  {"
     fi
     echo -n '    "powers": '
     /system/bin/chroot /data/local/nhsystem/kali-armhf/ /usr/local/bin/hackrf_sweep -1 -f1:7250 -w 100000 -l32 -g8
     echo ","
     echo -n '    "location":'
     /system/bin/curl -sL http://localhost:3000
     echo -n "  }"
  done
) > $filename
