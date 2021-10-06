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


`ifndef __UVMA_AXIL_SLV_SEQ_ITEM_SV__
`define __UVMA_AXIL_SLV_SEQ_ITEM_SV__


/**
 * Object created by AMBA Advanced eXtensible Interface agent sequences
 * extending uvma_axil_seq_base_c.
 */
class uvma_axil_slv_seq_item_c extends uvma_axil_base_seq_item_c;
   
   // Data
   rand bit [(`UVMA_AXIL_DATA_MAX_SIZE-1):0]  rdata   ;
   rand uvma_axil_response_enum               response;
   
   // Metadata
   rand int unsigned    resp_latency ; ///< Measured in clock cycles
   uvma_axil_mon_trn_c  req_trn      ; ///< Monitored transaction to which this seq_item is responding
   
   
   `uvm_object_utils_begin(uvma_axil_slv_seq_item_c)
      `uvm_field_int (                         rdata   , UVM_DEFAULT)
      `uvm_field_enum(uvma_axil_response_enum, response, UVM_DEFAULT)
      
      `uvm_field_int(addr_latency , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(data_latency , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(rsp_latency  , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(hold_duration, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(tail_duration, UVM_DEFAULT + UVM_DEC)
      
      `uvm_field_object(req_trn, UVM_DEFAULT + UVM_NOCOMPARE)
   `uvm_object_utils_end
   
   
   constraint defaults_cons {
      /*soft*/ response      == UVMA_AXIL_RESPONSE_OK;
      /*soft*/ addr_latency  == 1;
      /*soft*/ data_latency  == 1;
      /*soft*/ rsp_latency   == 1;
      /*soft*/ hold_duration == 1;
      /*soft*/ tail_duration == 1;
   }
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvma_axil_slv_seq_item");
   
endclass : uvma_axil_slv_seq_item_c


function uvma_axil_slv_seq_item_c::new(string name="uvma_axil_slv_seq_item");
   
   super.new(name);
   
endfunction : new


`endif // __UVMA_AXIL_SLV_SEQ_ITEM_SV__
