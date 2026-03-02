#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/luci582/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2026 community-scripts ORG
# Author: luci582
# License: MIT | https://github.com/luci582/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/openclaw/openclaw

APP="OpenClaw"
var_tags="${var_tags:-ai;assistant}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-8}"
var_os="${var_os:-debian}"
var_version="${var_version:-13}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -f /usr/local/bin/openclaw ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  if check_for_gh_release "openclaw" "openclaw/openclaw"; then
    msg_info "Stopping Service"
    systemctl stop openclaw
    msg_ok "Stopped Service"

    msg_info "Updating OpenClaw"
    $STD npm install -g openclaw@latest
    msg_ok "Updated OpenClaw"

    msg_info "Starting Service"
    systemctl start openclaw
    msg_ok "Started Service"
    msg_ok "Updated successfully!"
  fi
  exit
}

start
build_container
description

msg_ok "Completed successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:18789${CL}"
