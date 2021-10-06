// Copyright 2021 Datum Technology Corporation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may not use this file except in compliance
// with the License, or, at your option, the Apache License version 2.0.  You may obtain a copy of the License at
//                                        https://solderpad.org/licenses/SHL-2.1/
// Unless required by applicable law or agreed to in writing, any work distributed under the License is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_AXIL_TDEFS_SV__
`define __UVMA_AXIL_TDEFS_SV__


typedef enum {
   UVMA_AXIL_MODE_MSTR,
   UVMA_AXIL_MODE_SLV
} uvma_axil_mode_enum;

typedef enum {
   UVMA_AXIL_RESET_STATE_PRE_RESET ,
   UVMA_AXIL_RESET_STATE_IN_RESET  ,
   UVMA_AXIL_RESET_STATE_POST_RESET
} uvma_axil_reset_state_enum;

typedef enum {
   UVMA_AXIL_DRV_IDLE_SAME  ,
   UVMA_AXIL_DRV_IDLE_ZEROS ,
   UVMA_AXIL_DRV_IDLE_RANDOM,
   UVMA_AXIL_DRV_IDLE_X     ,
   UVMA_AXIL_DRV_IDLE_Z
} uvma_axil_drv_idle_enum;

typedef enum {
   UVMA_AXIL_PHASE_INACTIVE,
   UVMA_AXIL_PHASE_SETUP   ,
   UVMA_AXIL_PHASE_ACCESS
} uvma_axil_phases_enum;


typedef enum bit {
   UVMA_AXIL_ACCESS_READ  = 0,
   UVMA_AXIL_ACCESS_WRITE = 1
} uvma_axil_access_type_enum;

typedef enum bit [1:0] {
   UVMA_AXIL_RESPONSE_OK     = 2'b00,
   UVMA_AXIL_RESPONSE_SLVERR = 2'b10
} uvma_axil_response_enum;



`endif // __UVMA_AXIL_TDEFS_SV__
