# liquidsoap-daemon

Run liquidsoap as daemon!

This script configures your system to run your liquidsoap script, automatically and in the background. It currently supports the following init systems:
* `Systemd` (modern Linux; Debian 8 or later, Ubuntu 15.04 or later, recent versions of Fedora, Arch Linux, etc)
* `Initd` (older Linux; Debian before 8, Ubuntu before 15.04)
* `Launchd` (MacOS)

## Install

* Setup a system user with `sudo` access.
* Run `daemonize-liquidsoap.sh <script-name>` with the same user.

`<script name>` can be one of:
* `name` when `/home/<user>/liquidsoap-daemon/script/<main>.liq` exists
* `name.liq` when `/home/<user>/liquidsoap-daemon/script/<main>.liq` exists
* A full path to an existing script file.

It is recommended to place your script files in `/home/<user>/liquidsoap-daemon/script/`.

That's it, the daemon files are installed!

By default, the script installs a `Systemd` service. If you want to install files for another system, you can do:
```
init_type=<init system> ./daemonize-liquidsoap.sh <script-name>
```
Valid modes are currently: `systemd` (default), `initd`, `launchd`.

## Run

Once you have installed the daemonization scripts, you need to start the daemon as follows:

* `Systemd`: `sudo systemctl start <script-name>-liquidsoap`
* `Initd`: `sudo /etc/init.d/<script-name>-liquidsoap-daemon start`
* `Launchd`: `launchctl load ${HOME}/Library/LaunchAgents/<script-name>.liquidsoap.daemon.plist`

## Remove

You can also stop the daemon and remove the files installed by the script by running:
```
mode=remove [init_type=<init system>] ./daemonize-liquidsoap.sh <script-name>
```

## Dependencies

To run this script, you will need the `sudo` command. On Debian and Ubuntu, run:
```
apt install sudo
```
And configure as needed.

To install the `initd` scripts on older Debian systems (before 8), you will need the `update-rc.d` command. On Debian, run:
```
apt-get install init-system-helpers
```
