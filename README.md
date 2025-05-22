# 🔄 Potation

A Tool for Kali Linux that allows you to automatically **change the MAC address and/or hostname** of a device at specified time intervals to increase anonymity when connecting to networks.

---

## 🛡️ Opportunities

- 🔁 Automatic change of MAC address
- 🔁 Automatic hostname change
- ⏱️ Configurable shift interval (default is 1 minute)
— 🔓 The ability to disable and restore the original settings
- ✅ Compatibility with Kali Linux and other Debian - based systems

---

## 📦 Requirements

- `macchanger`
- Sudo rights
- Bash-compatible system (Kali Linux recommended)

Installing 'macchanger' (if not already installed):

```bash
sudo apt update
sudo apt install macchanger -y
```

---

## ⚙️ Install

```bash
git clone https://github.com/step8rother/potation.git
cd potation
chmod +x potation.sh
```

---

## 🚀 Usage

`sudo ./potation.sh [options]`

## 🔧 Available flags

| Flag | Description |
| ------------ | ----------------------------------------------------------- |
| `-t <minutes>` | Shift interval (default: `1`) |
| `-m` | Change only the MAC address |
| `-h` | Change only the hostname |
| `-mh` | Change both the MAC address and the hostname (analogous to running without flags) |
| `-r` | Disable the script and restore the original MAC and hostname |

---

## 📌 Examples

- Changes MAC and hostname every 1 minute:
`sudo ./potation.sh`

- Change MAC and hostname every 5 minutes:
`sudo ./potation.sh -t 5`

- Only MAC address change every 2 minutes:
`sudo ./potation.sh -m -t 2`

- Only hostname change:
`sudo ./potation.sh -h`

- Reset and return to the original state:
`sudo ./potation.sh -r`

---

## ⚠️ Important

- Changing the MAC address may lead to disconnection on some networks.
- Frequent hostname changes can be detected by the DHCP server.

---

## 📄 LICENSE

MIT © Potation Project