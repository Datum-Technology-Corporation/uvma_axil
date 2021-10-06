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


`ifndef __UVME_AXIL_ST_WRITES_VSEQ_SV__
`define __UVME_AXIL_ST_WRITES_VSEQ_SV__


/**
 * TODO Describe uvme_axil_st_writes_vseq_c
 */
class uvme_axil_st_writes_vseq_c extends uvme_axil_st_base_vseq_c;
   
   rand uvma_axil_storage_slv_seq_c  slv_seq;
   rand int unsigned                 num_writes;
   
   
   `uvm_object_utils_begin(uvme_axil_st_writes_vseq_c)
      `uvm_field_object(slv_seq   , UVM_DEFAULT          )
      `uvm_field_int   (num_writes, UVM_DEFAULT + UVM_DEC)
   `uvm_object_utils_end
   
   
   constraint defaults_cons {
      soft num_writes == 100;
   }
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvme_axil_st_writes_vseq");
   
   /**
    * TODO Describe uvme_axil_st_writes_vseq_c::body()
    */
   extern virtual task body();
   
endclass : uvme_axil_st_writes_vseq_c


function uvme_axil_st_writes_vseq_c::new(string name="uvme_axil_st_writes_vseq");
   
   super.new(name);
   
endfunction : new


task uvme_axil_st_writes_vseq_c::body();
   
   uvma_axil_mstr_seq_item_c  _req;
   
   fork
      begin
         `uvm_do_on(slv_seq, p_sequencer.slv_sequencer)
      end
      
      begin
         repeat (num_writes) begin
            `uvm_do_on_with(_req, p_sequencer.mstr_sequencer, {
               access_type == UVMA_AXIL_ACCESS_WRITE;
            })
         end
      end
   join_any
   disable fork;
   
endtask : body


`endif // __UVME_AXIL_ST_WRITES_VSEQ_SV__
