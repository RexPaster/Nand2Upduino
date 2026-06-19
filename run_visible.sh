#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/Nand2Upduino

./compile_verilator.sh

display_num=99
vnc_port=5900
web_port=6080
computer_pid_file=/tmp/nand2upduino-vcomputer.pid

cleanup() {
	if [[ -f "${computer_pid_file}" ]]; then
		computer_pid=$(cat "${computer_pid_file}")
		kill "${computer_pid}" >/dev/null 2>&1 || true
		rm -f "${computer_pid_file}"
	fi
	if [[ -n "${computer_pid:-}" ]]; then kill "${computer_pid}" >/dev/null 2>&1 || true; fi
	if [[ -n "${websockify_pid:-}" ]]; then kill "${websockify_pid}" >/dev/null 2>&1 || true; fi
	if [[ -n "${x11vnc_pid:-}" ]]; then kill "${x11vnc_pid}" >/dev/null 2>&1 || true; fi
	if [[ -n "${xvfb_pid:-}" ]]; then kill "${xvfb_pid}" >/dev/null 2>&1 || true; fi
}

trap cleanup EXIT

Xvfb :${display_num} -ac -screen 0 1280x720x24 >/tmp/nand2upduino-xvfb.log 2>&1 &
xvfb_pid=$!

while [[ ! -S "/tmp/.X11-unix/X${display_num}" ]]; do
	:
done

x11vnc -display :${display_num} -rfbport ${vnc_port} -forever -shared -nopw >/tmp/nand2upduino-x11vnc.log 2>&1 &
x11vnc_pid=$!

websockify --web=/usr/share/novnc ${web_port} localhost:${vnc_port} >/tmp/nand2upduino-websockify.log 2>&1 &
websockify_pid=$!

echo "Open the visible SDL session at: http://127.0.0.1:${web_port}/vnc.html?host=127.0.0.1&port=${vnc_port}"

DISPLAY=:${display_num} SDL_VIDEODRIVER=x11 ./05/obj_dir/Vcomputer &
computer_pid=$!
printf '%s\n' "${computer_pid}" > "${computer_pid_file}"

while true; do
	if ! kill -0 "${computer_pid}" >/dev/null 2>&1; then
		rm -f "${computer_pid_file}"
		echo "Simulation stopped. Run ./restart_sim.sh to start it again without closing VNC."
		computer_pid=""
		break
	fi
	sleep 1
done

echo "Type 'stop' and press Enter to shut down the simulator."

while true; do
	read -r cmd
	if [[ "$cmd" == "stop" ]]; then
		echo "Stopping..."
		break
	fi
done
