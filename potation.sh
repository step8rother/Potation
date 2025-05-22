#!/bin/bash
# POTATION

# ==== Usage ====
# sudo ./potation.sh    changes MAC and hostname every 1 minute
# sudo ./potation.sh -t 5    changes MAC and hostname every 5 minute
# sudo ./potation.sh -m -t 2    changes only MAC every 2 minute
# sudo ./potation.sh -h    changes only hostname every 1 minute
# sudo ./potation.sh -r    restore MAC and hostname to default (before launch script)


# ==== Default settings ====
INTERFACE="wlan0"  # change if different
INTERVAL=1
CHANGE_MAC=false
CHANGE_HOSTNAME=false

# ==== Save current values ====
ORIGINAL_MAC=$(cat /sys/class/net/$INTERFACE/address)
ORIGINAL_HOSTNAME=$(hostname)

# ==== Func ====

generate_hostname() {
  echo "host-$(cat /dev/urandom | tr -dc 'a-z0-9' | head -c8)"
}

change_mac() {
  sudo ifconfig $INTERFACE down
  sudo macchanger -r $INTERFACE > /dev/null
  sudo ifconfig $INTERFACE up
}

change_hostname() {
  NEW_HOSTNAME=$(generate_hostname)
  sudo hostnamectl set-hostname $NEW_HOSTNAME
  sudo sed -i "s/127.0.1.1.*/127.0.1.1\t$NEW_HOSTNAME/" /etc/hosts
}

restore_originals() {
  echo "[INFO] Restoring the original MAC and hostname..."

  sudo ifconfig $INTERFACE down
  sudo macchanger -m $ORIGINAL_MAC $INTERFACE > /dev/null
  sudo ifconfig $INTERFACE up

  sudo hostnamectl set-hostname $ORIGINAL_HOSTNAME
  sudo sed -i "s/127.0.1.1.*/127.0.1.1\t$ORIGINAL_HOSTNAME/" /etc/hosts

  echo "[INFO] Changing MAC and hostname is disabled. The original values have been restored."
  exit 0
}

print_usage() {
  echo "Usage: $0 [-t <minutes>] [-m] [-h] [-mh] [-r]"
  exit 1
}

# ==== Args ====
if [[ $# -eq 0 ]]; then
  CHANGE_MAC=true
  CHANGE_HOSTNAME=true
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    -t)
      shift
      INTERVAL=${1:-1}
      ;;
    -m)
      CHANGE_MAC=true
      ;;
    -h)
      CHANGE_HOSTNAME=true
      ;;
    -mh)
      CHANGE_MAC=true
      CHANGE_HOSTNAME=true
      ;;
    -r)
      restore_originals
      ;;
    *)
      print_usage
      ;;
  esac
  shift
done

# ==== Echo ====
echo "[INFO] The shift will take place every $INTERVAL minutes."
echo "[INFO] Active options:"
$CHANGE_MAC && echo "  - MAC-address"
$CHANGE_HOSTNAME && echo "  - Hostname"

# ==== Main ====
while true; do
  $CHANGE_MAC && change_mac && echo "[+] MAC-address changed"
  $CHANGE_HOSTNAME && change_hostname && echo "[+] Hostname changed"
  sleep $((INTERVAL * 60))
done
