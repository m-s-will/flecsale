#give the container id as a second argument to this script
mpiexec --allow-run-as-root -n 2 /home/docker/flecsale_build/bin/hydro_3d -m /home/docker/flecsale//apps/catalyst_adaptor/catalyst_scripts/hydro3d_live.py
