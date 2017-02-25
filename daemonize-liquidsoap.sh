#!/bin/sh

# Generate configuration files to run liquidsoap as daemon.

base_dir="${HOME}/liquidsoap-daemon"
main_script="${base_dir}/main.liq"
run_script="${base_dir}/run.liq"
pid_dir="${base_dir}/pid"
log_dir="${base_dir}/log"
liquidsoap_binary=`which liquidsoap`

if [ -z "${init_type}" ]; then
    init_type="systemd"
fi;

initd_target="/etc/init.d/liquidsoap-daemon"
launchd_target="${HOME}/Library/LaunchAgents/fm.liquidsoap.daemon.plist"
systemd_target="/etc/systemd/system/liquidsoap.service"

if [ -z "${mode}" ]; then
    mode=install
fi;

if [ "${mode}" = "remove" ]; then
    case "${init_type}" in
	systemd)
	    sudo systemctl disable liquidsoap
	    sudo systemctl stop liquidsoap
	    sudo rm "$systemd_target"
	    sudo systemctl daemon-reload
	    ;;
	launchd)
	    launchctl unload "${launchd_target}"
	    ;;
	initd)
	    sudo "${initd_target}" stop
	    sudo update-rc.d -f liquidsoap-daemon remove
	    ;;
    esac
    exit 0
fi;
if [ "${init_type}" != "systemd" ]; then
    mkdir -p "${pid_dir}"
    mkdir -p "${log_dir}"

    cat <<EOS > "${run_script}"
#!/bin/env liquidsoap

set("log.file",true)
set("log.file.path","${log_dir}/run.log")
EOS

    if [ "${init_type}" != "launchd" ]; then
	cat <<EOS >> "${run_script}"
set("init.daemon",true)
set("init.daemon.change_user",true)
set("init.daemon.change_user.group","${USER}")
set("init.daemon.change_user.user","${USER}")
set("init.daemon.pidfile",true)
set("init.daemon.pidfile.path","${pid_dir}/run.pid")
EOS
    fi;

    echo "%include \"${main_script}\"" >> "${run_script}"

    cat "liquidsoap.${init_type}.in" | \
	sed -e "s#@liquidsoap_binary@#${liquidsoap_binary}#g" | \
	sed -e "s#@base_dir@#${base_dir}#g" | \
	sed -e "s#@run_script@#${run_script}#g" | \
	sed -e "s#@pid_dir@#${pid_dir}#g" > "liquidsoap.${init_type}"

    case "${init_type}" in
	launchd)
	    cp "liquidsoap.${init_type}" "${launchd_target}"
	    launchctl load "${launchd_target}"
	    ;;
	initd)
	    chmod +x "liquidsoap.${init_type}"
	    sudo cp "liquidsoap.${init_type}" "${initd_target}"
	    sudo update-rc.d liquidsoap-daemon defaults 
	    sudo "${initd_target}" start
	    ;;
    esac
else
    echo "[Unit]
Description=Liquidsoap daemon
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$base_dir
ExecStart=$liquidsoap_binary $main_script
Restart=on-abort

[Install]
WantedBy=multi-user.target" > liquidsoap.service
    sudo mv liquidsoap.service /etc/systemd/system
    sudo systemctl daemon-reload
    sudo systemctl start liquidsoap
    echo "The Systemd service has been installed!
If you want Liquidsoap to start on boot, run:
systemctl enable liquidsoap
If Liquidsoap fails to start, add the following lines to $main_script to insure full compatibility with Systemd:
set(\"log.file\",false)
set(\"log.stdout\",true)
The service will run the script at $main_script with a working directory of $base_dir. If this script (or the playlists it references) uses relative paths in another directory, you may want to edit $systemd_target accordingly.
If something doesn't work as intended, open an issue at https://github.com/savonet/liquidsoap-daemon or send an email to Bill Dengler <codeofdusk@gmail.com>."
fi
