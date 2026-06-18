cd 05
rm -rf obj_dir
verilator -Wall -Wno-PROCASSINIT --cc computer.sv -I../01 -I../02 -I../03 -I../05 --exe ../../computer.cpp -LDFLAGS "-lSDL2"
cd obj_dir
make -f Vcomputer.mk
cd ../../
mkdir -p /tmp/xdg-runtime
export XDG_RUNTIME_DIR=/tmp/xdg-runtime
export SDL_VIDEODRIVER=dummy
echo "Build complete - binary at ./05/obj_dir/Vcomputer (run manually if desired)"
