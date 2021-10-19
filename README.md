# About
## [Home Page](https://datum-technology-corporation.github.io/uvma_axil/)
The Moore.io Arm® AMBA® IP Suite's Advanced eXtensible Interface (AXI)-Lite UVM Agent is a compact, sequence-based solution to Driving/Monitoring both sides of an AXI-Lite interface.  This project consists of the agent (`uvma_axil_pkg`), the self-testing UVM environment (`uvme_axil_st_pkg`) and the test bench (`uvmt_axil_st_pkg`) to verify the agent against itself.

## IP
* DV
> * uvma_axil
> * uvme_axil_st
> * uvmt_axil_st
* RTL
* Tools


# Simulation
**1. Change directory to 'sim'**
This is from where all jobs will be launched.
```
cd ./sim
```

**2. Project Setup**
Only needs to be done once, or when libraries must be updated.
```
./setup_project.py
```

**3. Terminal Setup**
```
export VIVADO=/path/to/vivado/install/bin # Set locaton of Vivado installation
source ./setup_terminal.sh
```

**4. Launch**
```
dvm --help
clear && dvm all uvmt_axil_st -t all_access -s 1 -w
```
