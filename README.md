# About
## [Home Page](https://datum-technology-corporation.github.io/uvma_axil/)
The Moore.io UVM Advanced eXtensible Interface (AXI)-Lite Agent is a compact, sequence-based solution to Driving/Monitoring both sides of an AXI-Lite interface.  This project consists of the agent (`uvma_axil_pkg`), the self-testing UVM environment (`uvme_axil_st_pkg`) and the test bench (`uvmt_axil_st_pkg`) to verify the agent against itself.

## IP
* DV
> * uvma_axil
> * uvme_axil_st
> * uvmt_axil_st
* RTL
* Tools


# Simulation
```
cd ./sim
cat ./README.md
./setup_project.py
source ./setup_terminal.sh
export VIVADO=/path/to/vivado/install
dvm --help
clear && dvm all uvmt_axil_st -t all_access -s 1 -w
```
