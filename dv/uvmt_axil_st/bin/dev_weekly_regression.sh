#! /bin/bash
########################################################################################################################
## Copyright 2021-2022 Datum Technology Corporation
## SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
########################################################################################################################


# Launched from uvma_axil project sim dir
mio sim     uvmt_axil_st -CE
mio sim     uvmt_axil_st -S -t reads      -s 1 -c
mio sim     uvmt_axil_st -S -t writes     -s 1 -c
mio sim     uvmt_axil_st -S -t all_access -s 1 -c
mio results uvmt_axil_st results
mio cov     uvmt_axil_st
