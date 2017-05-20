# liquidsoap-daemon

Run liquidsoap as daemon!

This script configures your system to run your liquidsoap script, automatically and in the background. It currently supports the following init systems:
* `Systemd` (modern Linux; Debian 8 or later, Ubuntu 15.04 or later, recent versions of Fedora, Arch Linux, etc)
* `Initd` (older Linux; Debian before 8, Ubuntu before 15.04)
* `Launchd` (MacOS)

To use the script:

* Place the script to run as daemon at `<user home>/liquidsoap-daemon/main.liq`
* Run `daemonize-liquidsoap.sh` with the same user

That's it, the daemon files are installed!

By default, the script installs a `Systemd` service. If you want to install files for another system, you can do:
```
init_type=<init system> ./daemonize-liquidsoap.sh
```
Valid modes are currently: `systemd` (default), `initd`, `launchd`.

Once you have installed the daemonization scripts, you need to start the daemon as follows:

* `Systemd`: `sudo systemctl start liquidsoap`
* `Initd`: `sudo /etc/init.d/liquidsoap-daemon start`
* `Launchd`: `launchctl load ${HOME}/Library/LaunchAgents/fm.liquidsoap.daemon.plist`

You can also stop the daemon and remove the files installed by the script by running:
```
mode=remove [init_type=<init system>] ./daemonize-liquidsoap.sh
```

To run this script, you will need the `sudo` command. On Debian and Ubuntu, run:
```
apt install sudo
```
And configure as needed.

To install the initd scripts on older Debian systems (before 8), you will need the `update-rc.d` command. On Debian, run:
```
apt-get install init-system-helpers
```

For initd scripts on Ubuntu (before 15.04), you need to install:
```
apt-get install sysv-rc
```
