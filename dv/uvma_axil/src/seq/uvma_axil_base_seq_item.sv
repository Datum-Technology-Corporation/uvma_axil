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


`ifndef __UVMA_AXIL_BASE_SEQ_ITEM_SV__
`define __UVMA_AXIL_BASE_SEQ_ITEM_SV__


/**
 * Object created by AMBA Advanced eXtensible Interface agent sequences extending uvma_axil_seq_base_c.
 */
class uvma_axil_base_seq_item_c extends uvml_seq_item_c;
   
   // Data
   rand uvma_axil_access_type_enum  access_type;
   
   // Metadata
   uvma_axil_mode_enum  mode;
   int unsigned         addr_bus_width; ///< Measured in bytes (B)
   int unsigned         data_bus_width; ///< Measured in bytes (B)
   rand int unsigned    addr_latency  ; ///< Measured in clock cycles
   rand int unsigned    data_latency  ; ///< Measured in clock cycles
   rand int unsigned    rsp_latency   ; ///< Measured in clock cycles
   rand int unsigned    hold_duration ; ///< Measured in clock cycles
   rand int unsigned    tail_duration ; ///< Measured in clock cycles
   
   
   `uvm_object_utils_begin(uvma_axil_base_seq_item_c)
      `uvm_field_enum(uvma_axil_mode_enum       , mode       , UVM_DEFAULT)
      `uvm_field_enum(uvma_axil_access_type_enum, access_type, UVM_DEFAULT)
   `uvm_object_utils_end
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvma_axil_base_seq_item");
   
endclass : uvma_axil_base_seq_item_c


function uvma_axil_base_seq_item_c::new(string name="uvma_axil_base_seq_item");
   
   super.new(name);
   
endfunction : new


`endif // __UVMA_AXIL_BASE_SEQ_ITEM_SV__
