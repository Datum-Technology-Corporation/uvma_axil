#! /bin/bash
########################################################################################################################
## Copyright 2021 Datum Technology Corporation
## SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
########################################################################################################################


# Launched from uvma_axil project sim dir
shopt -s expand_aliases
source ~/.bashrc
mio cpel    uvmt_axil_st
mio sim     uvmt_axil_st -t reads      -s 1 -c
mio sim     uvmt_axil_st -t writes     -s 1 -c
mio sim     uvmt_axil_st -t all_access -s 1 -c
mio results uvmt_axil_st results
mio cov     uvmt_axil_st
