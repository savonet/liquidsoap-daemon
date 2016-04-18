# liquidsoap-daemon

Run liquidsoap as daemon!

This script sets your system to run your liquidsoap scripts. It currently supports the following init systems:
* `initd` (Linux)
* `launchd` (OSX)

It works as follows:

* You place the script to run as daemon here: `<user home>/liquidsoap-daemon/main.liq`
* You run `daemonize-liquidsoap.sh` with the same user

That's it!

By default, the script installs `initd` files. If you want to install files for another system, you can do:
```
init_type=<init system> ./daemonize-liquidsoap.sh
```
Valid modes currently are: `initd` (default), `launchd`.

You can also remove the files installed by the script by running:
```
mode=remove [mode=<init system] ./daemonize-liquidsoap.sh
```

Finally, to install the init scripts, you will need the `sudo` and `update-rc.d` commands.
You can install them in Debian and Debian-derived systems by doing:
```
apt-get install sudo init-system-helpers
```
and then configure `sudo`, if needed.
