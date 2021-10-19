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


`ifndef __UVMA_AXIL_MON_SV__
`define __UVMA_AXIL_MON_SV__


/**
 * Component sampling transactions from a AMBA Advanced eXtensible Interface virtual interface (uvma_axil_if).
 */
class uvma_axil_mon_c extends uvml_mon_c;
   
   // Objects
   uvma_axil_cfg_c    cfg  ; ///< 
   uvma_axil_cntxt_c  cntxt; ///< 
   
   // TLM
   uvm_analysis_port#(uvma_axil_mon_trn_c)  ap          ; ///< 
   uvm_analysis_port#(uvma_axil_mon_trn_c)  sequencer_ap; ///< 
   
   virtual uvma_axil_if.passive_mp  vif_passive_mp; ///< Handles to virtual interface modport
   
   
   `uvm_component_utils_begin(uvma_axil_mon_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvma_axil_mon", uvm_component parent=null);
   
   /**
    * 1. Ensures cfg & cntxt handles are not null.
    * 2. Builds ap.
    */
   extern virtual function void build_phase(uvm_phase phase);
   
   /**
    * TODO Describe uvma_axil_mon_c::run_phase()
    */
   extern virtual task run_phase(uvm_phase phase);
   
   /**
    * Updates the context's reset state.
    */
   extern task observe_reset();
   
   /**
    * TODO Describe uvma_axil_mon_c::mon_pre_reset()
    */
   extern task mon_pre_reset(uvm_phase phase);
   
   /**
    * TODO Describe uvma_axil_mon_c::mon_in_reset()
    */
   extern task mon_in_reset(uvm_phase phase);
   
   /**
    * TODO Describe uvma_axil_mon_c::mon_read_post_reset()
    */
   extern task mon_read_post_reset(uvm_phase phase);
   
   /**
    * TODO Describe uvma_axil_mon_c::mon_write_post_reset()
    */
   extern task mon_write_post_reset(uvm_phase phase);
   
   /**
    * TODO Describe uvma_axil_mon_c::mon_read()
    */
   extern task mon_read(output uvma_axil_mon_trn_c trn);
   
   /**
    * TODO Describe uvma_axil_mon_c::mon_fsm_inactive()
    */
   extern task mon_write(output uvma_axil_mon_trn_c trn);
   
   /**
    * TODO Describe uvma_axil_mon_c::process_trn()
    */
   extern function void process_trn(ref uvma_axil_mon_trn_c trn);
   
   /**
    * TODO Describe uvma_axil_mon_c::send_trn_to_sequencer()
    */
   extern task send_trn_to_sequencer(ref uvma_axil_mon_trn_c trn);
   
   /**
    * TODO Describe uvma_axil_mon_c::check_signals_same()
    */
   extern task check_signals_same(ref uvma_axil_mon_trn_c trn);
   
   /**
    * TODO Describe uvma_axil_mon_c::sample_read_trn_from_vif()
    */
   extern task sample_read_trn_from_vif(output uvma_axil_mon_trn_c trn);
   
   /**
    * TODO Describe uvma_axil_mon_c::sample_write_trn_from_vif()
    */
   extern task sample_write_trn_from_vif(output uvma_axil_mon_trn_c trn);
   
endclass : uvma_axil_mon_c


function uvma_axil_mon_c::new(string name="uvma_axil_mon", uvm_component parent=null);
   
   super.new(name, parent);
   
endfunction : new


function void uvma_axil_mon_c::build_phase(uvm_phase phase);
   
   super.build_phase(phase);
   
   void'(uvm_config_db#(uvma_axil_cfg_c)::get(this, "", "cfg", cfg));
   if (cfg == null) begin
      `uvm_fatal("CFG", "Configuration handle is null")
   end
   
   void'(uvm_config_db#(uvma_axil_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (cntxt == null) begin
      `uvm_fatal("CNTXT", "Context handle is null")
   end
   vif_passive_mp = cntxt.vif.passive_mp;
   
   ap           = new("ap"          , this);
   sequencer_ap = new("sequencer_ap", this);
  
endfunction : build_phase


task uvma_axil_mon_c::run_phase(uvm_phase phase);
   
   super.run_phase(phase);
   
   fork
      observe_reset();
      
      // Read
      begin
         forever begin
            wait (cfg.enabled);
            
            fork
               begin
                  case (cntxt.reset_state)
                     UVMA_AXIL_RESET_STATE_PRE_RESET : mon_pre_reset      (phase);
                     UVMA_AXIL_RESET_STATE_IN_RESET  : mon_in_reset       (phase);
                     UVMA_AXIL_RESET_STATE_POST_RESET: mon_read_post_reset(phase);
                  endcase
               end
               
               begin
                  wait (!cfg.enabled);
               end
            join_any
            disable fork;
         end
      end
      
      // Write
      begin
         forever begin
            wait (cfg.enabled);
            
            fork
               begin
                  case (cntxt.reset_state)
                     UVMA_AXIL_RESET_STATE_PRE_RESET : mon_pre_reset       (phase);
                     UVMA_AXIL_RESET_STATE_IN_RESET  : mon_in_reset        (phase);
                     UVMA_AXIL_RESET_STATE_POST_RESET: mon_write_post_reset(phase);
                  endcase
               end
               
               begin
                  wait (!cfg.enabled);
               end
            join_any
            disable fork;
         end
      end
   join_none
   
endtask : run_phase


task uvma_axil_mon_c::observe_reset();
   
   forever begin
      wait (cfg.enabled);
      
      fork
         begin
            wait (cntxt.vif.reset_n === 0);
            cntxt.reset_state = UVMA_AXIL_RESET_STATE_IN_RESET;
            wait (cntxt.vif.reset_n === 1);
            cntxt.reset_state = UVMA_AXIL_RESET_STATE_POST_RESET;
         end
         
         begin
            wait (!cfg.enabled);
         end
      join_any
      disable fork;
   end
   
endtask : observe_reset


task uvma_axil_mon_c::mon_pre_reset(uvm_phase phase);
   
   @(cntxt.vif./*passive_mp.*/mon_cb);
   
endtask : mon_pre_reset


task uvma_axil_mon_c::mon_in_reset(uvm_phase phase);
   
   @(cntxt.vif./*passive_mp.*/mon_cb);
   
endtask : mon_in_reset


task uvma_axil_mon_c::mon_read_post_reset(uvm_phase phase);
   
   uvma_axil_mon_trn_c  trn;
   
   mon_read(trn);
   `uvm_info("AXIL_MON", $sformatf("monitored read:\n%s", trn.sprint()), UVM_HIGH)
   process_trn(trn);
   ap.write   (trn);
   `uvml_hrtbt()
   
endtask : mon_read_post_reset


task uvma_axil_mon_c::mon_write_post_reset(uvm_phase phase);
   
   uvma_axil_mon_trn_c  trn;
   
   mon_write(trn);
   `uvm_info("AXIL_MON", $sformatf("monitored write:\n%s", trn.sprint()), UVM_HIGH)
   process_trn(trn);
   ap.write   (trn);
   `uvml_hrtbt()
   
endtask : mon_write_post_reset


task uvma_axil_mon_c::mon_read(output uvma_axil_mon_trn_c trn);
   
   // Address Channel
   while (cntxt.vif./*passive_mp.*/mon_cb.arvalid !== 1'b1) begin
      @(cntxt.vif./*passive_mp.*/mon_cb);
   end
   sample_read_trn_from_vif(trn);
   if (cfg.enabled && cfg.is_active && (cfg.drv_mode == UVMA_AXIL_MODE_SLV)) begin
      send_trn_to_sequencer(trn);
   end
   while (cntxt.vif./*passive_mp.*/mon_cb.arready !== 1'b1) begin
      @(cntxt.vif./*passive_mp.*/mon_cb);
   end
   
   // Data Channel
   while ((cntxt.vif./*passive_mp.*/mon_cb.rvalid !== 1'b1) || (cntxt.vif./*passive_mp.*/mon_cb.rready !== 1'b1)) begin
      @(cntxt.vif./*passive_mp.*/mon_cb);
   end
   
   // Capture response
   sample_read_trn_from_vif(trn);
   trn.__timestamp_end = $realtime();
   trn.response = uvma_axil_response_enum'(cntxt.vif./*passive_mp.*/mon_cb.rresp);
   
   // Wait for idle
   while ((cntxt.vif./*passive_mp.*/mon_cb.rvalid === 1'b1) && (cntxt.vif./*passive_mp.*/mon_cb.rready === 1'b1)) begin
      @(cntxt.vif./*passive_mp.*/mon_cb);
   end
   
endtask : mon_read


task uvma_axil_mon_c::mon_write(output uvma_axil_mon_trn_c trn);
   
   // Wait until valid is high for both address and data channels
   fork
      // Address Channel
      begin
         while (cntxt.vif./*passive_mp.*/mon_cb.awvalid !== 1'b1) begin
            @(cntxt.vif./*passive_mp.*/mon_cb);
         end
      end
      
      // Data Channel
      begin
         while (cntxt.vif./*passive_mp.*/mon_cb.wvalid !== 1'b1) begin
            @(cntxt.vif./*passive_mp.*/mon_cb);
         end
      end
   join
   
   // 'slv' sequence needs "early" trn in order to respond to it (and drive the rest of the exchange)
   sample_write_trn_from_vif(trn);
   if (cfg.enabled && cfg.is_active && (cfg.drv_mode == UVMA_AXIL_MODE_SLV)) begin
      send_trn_to_sequencer(trn);
   end
   
   // Wait until ready is high for both address and data channels
   fork
      // Address Channel
      begin
         while (cntxt.vif./*passive_mp.*/mon_cb.awready !== 1'b1) begin
            @(cntxt.vif./*passive_mp.*/mon_cb);
         end
      end
      
      // Data Channel
      begin
         while (cntxt.vif./*passive_mp.*/mon_cb.wready !== 1'b1) begin
            @(cntxt.vif./*passive_mp.*/mon_cb);
         end
      end
   join
   
   // Wait for response
   while ((cntxt.vif./*passive_mp.*/mon_cb.bvalid !== 1'b1) || (cntxt.vif./*passive_mp.*/mon_cb.bready !== 1'b1)) begin
      @(cntxt.vif./*passive_mp.*/mon_cb);
      trn.latency++;
   end
   
   // Capture response
   sample_write_trn_from_vif(trn);
   trn.__timestamp_end = $realtime();
   trn.response = uvma_axil_response_enum'(cntxt.vif./*passive_mp.*/mon_cb.rresp);
   
   // Wait for idle
   while ((cntxt.vif./*passive_mp.*/mon_cb.bvalid === 1'b1) && (cntxt.vif./*passive_mp.*/mon_cb.bready === 1'b1)) begin
      @(cntxt.vif./*passive_mp.*/mon_cb);
   end
   
endtask : mon_write


function void uvma_axil_mon_c::process_trn(ref uvma_axil_mon_trn_c trn);
   
   // TODO Implement uvma_axil_mon_c::process_trn()
   
endfunction : process_trn


task uvma_axil_mon_c::send_trn_to_sequencer(ref uvma_axil_mon_trn_c trn);
   
   sequencer_ap.write(trn);
   
endtask : send_trn_to_sequencer


task uvma_axil_mon_c::check_signals_same(ref uvma_axil_mon_trn_c trn);
   
   // TODO Implement uvma_axil_mon_c::check_signals_same()
   
endtask : check_signals_same


task uvma_axil_mon_c::sample_read_trn_from_vif(output uvma_axil_mon_trn_c trn);
   
   trn = uvma_axil_mon_trn_c::type_id::create("trn");
   trn.set_initiator(this);
   trn.access_type = UVMA_AXIL_ACCESS_READ;
   
   for (int unsigned ii=0; ii<cfg.addr_bus_width; ii++) begin
      trn.address[ii] = cntxt.vif./*passive_mp.*/mon_cb.araddr[ii];
   end
   for (int unsigned ii=0; ii<cfg.data_bus_width; ii++) begin
      trn.data[ii] = cntxt.vif./*passive_mp.*/mon_cb.rdata[ii];
   end
   
endtask : sample_read_trn_from_vif


task uvma_axil_mon_c::sample_write_trn_from_vif(output uvma_axil_mon_trn_c trn);
   
   trn = uvma_axil_mon_trn_c::type_id::create("trn");
   trn.set_initiator(this);
   trn.access_type = UVMA_AXIL_ACCESS_WRITE;
   
   for (int unsigned ii=0; ii<cfg.addr_bus_width; ii++) begin
      trn.address[ii] = cntxt.vif./*passive_mp.*/mon_cb.awaddr[ii];
   end
   for (int unsigned ii=0; ii<cfg.strobe_bus_width; ii++) begin
      trn.strobe[ii] = cntxt.vif./*passive_mp.*/mon_cb.wstrb[ii];
   end
   for (int unsigned ii=0; ii<cfg.data_bus_width; ii++) begin
      trn.data[ii] = cntxt.vif./*passive_mp.*/mon_cb.wdata[ii];
   end
   
endtask : sample_write_trn_from_vif


`endif // __UVMA_AXIL_MON_SV__
