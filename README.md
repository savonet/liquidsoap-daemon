# liquidsoap-daemon

Run liquidsoap as daemon!

This script sets your system to run your liquidsoap scripts. It currently supports the following init systems:
* `Systemd` (modern Linux systems)
* `Initd` (older Linux systems)
* `Launchd` (MacOS)

It works as follows:

* You place the script to run as daemon here: `<user home>/liquidsoap-daemon/main.liq`
* You run `daemonize-liquidsoap.sh` with the same user

That's it!

By default, the script installs a `Systemd` service. If you want to install files for another system, you can do:
```
init_type=<init system> ./daemonize-liquidsoap.sh
```
Valid modes currently are: `systemd` (default), `initd`, `launchd`.

You can also remove the files installed by the script by running:
```
mode=remove [init_system=<init system>] ./daemonize-liquidsoap.sh
```

To install the initd scripts, you will need the `sudo` and `update-rc.d` commands.
You can install them in Debian:
```
apt-get install sudo init-system-helpers
```
and then configure `sudo`, if needed.

For initd scripts on Ubuntu, you need to install:
```
apt-get install sudo sysv-rc
```
