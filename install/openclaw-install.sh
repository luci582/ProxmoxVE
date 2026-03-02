#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG
# Author: luci582
# License: MIT | https://github.com/luci582/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/openclaw/openclaw

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y git
msg_ok "Installed Dependencies"

NODE_VERSION="22" setup_nodejs

msg_info "Installing OpenClaw"
$STD npm install -g openclaw@latest
msg_ok "Installed OpenClaw"

msg_info "Configuring OpenClaw"
mkdir -p /root/.openclaw
cat <<EOF >/root/.openclaw/openclaw.json
{
  "gateway": {
    "controlUi": {
      "dangerouslyAllowHostHeaderOriginFallback": true
    }
  }
}
EOF
msg_ok "Configured OpenClaw"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/openclaw.service
[Unit]
Description=OpenClaw AI Gateway
After=network.target

[Service]
Type=simple
User=root
ExecStart=/bin/openclaw gateway --port 18789 --allow-unconfigured --bind lan
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now openclaw
msg_ok "Created Service"

motd_ssh
customize
cleanup_lxc
