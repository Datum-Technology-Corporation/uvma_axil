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


`ifndef __UVME_AXIL_ST_COV_MODEL_SV__
`define __UVME_AXIL_ST_COV_MODEL_SV__


/**
 * Component encapsulating AMBA Advanced eXtensible Interface Self-Test Environment functional
 * coverage model.
 */
class uvme_axil_st_cov_model_c extends uvma_axil_cov_model_c;
   
   `uvm_component_utils(uvme_axil_st_cov_model_c)
   
   
   /*covergroup axil_st_cfg_cg;
      // TODO Implement axil_st_cfg_cg
      //      Ex: abc_cpt : coverpoint cfg.abc;
      //          xyz_cpt : coverpoint cfg.xyz;
   endgroup : axil_st_cfg_cg
   
   covergroup axil_st_cntxt_cg;
      // TODO Implement axil_st_cntxt_cg
      //      Ex: abc_cpt : coverpoint cntxt.abc;
      //          xyz_cpt : coverpoint cntxt.xyz;
   endgroup : axil_st_cntxt_cg
   
   covergroup axil_st_mstr_seq_item_cg;
      // TODO Implement axil_st_mstr_seq_item_cg
      //      Ex: abc_cpt : coverpoint mstr_seq_item.abc;
      //          xyz_cpt : coverpoint mstr_seq_item.xyz;
   endgroup : axil_st_mstr_seq_item_cg
   
   covergroup axil_st_slv_seq_item_cg;
      // TODO Implement axil_st_slv_seq_item_cg
      //      Ex: abc_cpt : coverpoint slv_seq_item.abc;
      //          xyz_cpt : coverpoint slv_seq_item.xyz;
   endgroup : axil_st_slv_seq_item_cg
   
   covergroup axil_st_mstr_mon_trn_cg;
      // TODO Implement axil_st_mstr_mon_trn_cg
      //      Ex: abc_cpt : coverpoint mon_trn.abc;
      //          xyz_cpt : coverpoint mon_trn.xyz;
   endgroup : axil_st_mstr_mon_trn_cg
   
   covergroup axil_st_slv_mon_trn_cg;
      // TODO Implement axil_st_slv_mon_trn_cg
      //      Ex: abc_cpt : coverpoint mon_trn.abc;
      //          xyz_cpt : coverpoint mon_trn.xyz;
   endgroup : axil_st_slv_mon_trn_cg*/
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvme_axil_st_cov_model", uvm_component parent=null);
   
   /**
    * TODO Describe uvme_axil_st_cov_model_c::sample_cfg()
    */
   extern virtual function void sample_cfg();
   
   /**
    * TODO Describe uvme_axil_st_cov_model_c::sample_cntxt()
    */
   extern virtual function void sample_cntxt();
   
   /**
    * TODO Describe uvme_axil_st_cov_model_c::sample_mon_trn()
    */
   extern virtual function void sample_mon_trn();
   
   /**
    * TODO Describe uvme_axil_st_cov_model_c::sample_seq_item()
    */
   extern virtual function void sample_seq_item();
   
   /**
    * TODO Describe uvme_axil_st_cov_model_c::sample_mstr_mon_trn()
    */
   extern virtual function void sample_mstr_mon_trn();
   
   /**
    * TODO Describe uvme_axil_st_cov_model_c::sample_mstr_seq_item()
    */
   extern virtual function void sample_mstr_seq_item();
   
   /**
    * TODO Describe uvme_axil_st_cov_model_c::sample_slv_mon_trn()
    */
   extern virtual function void sample_slv_mon_trn();
   
   /**
    * TODO Describe uvme_axil_st_cov_model_c::sample_slv_seq_item()
    */
   extern virtual function void sample_slv_seq_item();
   
endclass : uvme_axil_st_cov_model_c


function uvme_axil_st_cov_model_c::new(string name="uvme_axil_st_cov_model", uvm_component parent=null);
   
   super.new(name, parent);
   
endfunction : new


function void uvme_axil_st_cov_model_c::sample_cfg();
   
   // TODO Implement uvme_axil_st_cov_model_c::sample_cfg();
   
endfunction : sample_cfg


function void uvme_axil_st_cov_model_c::sample_cntxt();
   
   // TODO Implement uvme_axil_st_cov_model_c::sample_cntxt();
   
endfunction : sample_cntxt


function void uvme_axil_st_cov_model_c::sample_mon_trn();
   
   // TODO Implement uvme_axil_st_cov_model_c::sample_mon_trn();
   
endfunction : sample_mon_trn


function void uvme_axil_st_cov_model_c::sample_seq_item();
   
   // TODO Implement uvme_axil_st_cov_model_c::sample_seq_item();
   
endfunction : sample_seq_item


function void uvme_axil_st_cov_model_c::sample_mstr_mon_trn();
   
   // TODO Implement uvme_axil_st_cov_model_c::sample_mstr_mon_trn();
   
endfunction : sample_mstr_mon_trn


function void uvme_axil_st_cov_model_c::sample_mstr_seq_item();
   
   // TODO Implement uvme_axil_st_cov_model_c::sample_mstr_seq_item();
   
endfunction : sample_mstr_seq_item


function void uvme_axil_st_cov_model_c::sample_slv_mon_trn();
   
   // TODO Implement uvme_axil_st_cov_model_c::sample_slv_mon_trn();
   
endfunction : sample_slv_mon_trn


function void uvme_axil_st_cov_model_c::sample_slv_seq_item();
   
   // TODO Implement uvme_axil_st_cov_model_c::sample_slv_seq_item();
   
endfunction : sample_slv_seq_item


`endif // __UVME_AXIL_ST_COV_MODEL_SV__
