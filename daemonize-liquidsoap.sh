#!/bin/sh

# Generate configuration files to run liquidsoap as daemon.

main_script="${HOME}/liquidsoap-daemon/main.liq"
run_script="${HOME}/liquidsoap-daemon/run.liq"
pid_dir="${HOME}/liquidsoap-daemon/pid"
log_dir="${HOME}/liquidsoap-daemon/log"
liquidsoap_binary=`which liquidsoap`

if [ -z "${init_type}" ]; then
  init_type="initd"
fi;

initd_target="/etc/init.d/liquidsoap-daemon"
launchd_target="${HOME}/Library/LaunchAgents/fm.liquidsoap.daemon.plist"

if [ -z "${mode}" ]; then
  mode=install
fi;

if [ "${mode}" = "remove" ]; then
  case "${init_type}" in
    launchd)
      launchctl unload "${launchd_target}"
    ;;
    initd)
      sudo "${initd_target}" stop
      sudo update-rc.d liquidsoap-daemon disable
    ;;
  esac
  exit 0
fi;

mkdir -p "${pid_dir}"
mkdir -p "${log_dir}"

cat <<EOS > "${run_script}"
#!/bin/env liquidsoap

set("log.file",true)
set("log.file.path","${log_dir}/<script>.log")
EOS

if [ "${init_type}" != "launchd" ]; then
  cat <<EOS >> "${run_script}"
set("init.daemon",true)
set("init.daemon.change_user",true)
set("init.daemon.change_user.group","${USER}")
set("init.daemon.change_user.user","${USER}")
set("init.daemon.pidfile",true)
set("init.daemon.pidfile.path","${pid_dir}/<script>.pid")
EOS
fi;

echo "%include \"${main_script}\"" >> "${run_script}"

cat "liquidsoap.${init_type}.in" | \
  sed -e "s#@liquidsoap_binary@#${liquidsoap_binary}#g" | \
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
    sudo update-rc.d liquidsoap-daemon enable 
    sudo "${initd_target}" start
  ;;
esac
