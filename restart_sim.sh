#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/Nand2Upduino

display_num=99
computer_pid_file=/tmp/nand2upduino-vcomputer.pid

if [[ -f "${computer_pid_file}" ]]; then
	old_pid=$(cat "${computer_pid_file}")
	kill "${old_pid}" >/dev/null 2>&1 || true
	rm -f "${computer_pid_file}"
fi

DISPLAY=:${display_num} SDL_VIDEODRIVER=x11 ./05/obj_dir/Vcomputer &
new_pid=$!
printf '%s\n' "${new_pid}" > "${computer_pid_file}"
echo "Restarted simulation on DISPLAY=:${display_num} with PID ${new_pid}."
