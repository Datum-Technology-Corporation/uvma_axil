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


`ifndef __UVMA_AXIL_DRV_SV__
`define __UVMA_AXIL_DRV_SV__


/**
 * Component driving an AMBA Advanced eXtensible Interface virtual interface (uvma_axil_if).
 */
class uvma_axil_drv_c extends uvm_driver#(
   .REQ(uvma_axil_base_seq_item_c),
   .RSP(uvma_axil_mon_trn_c      )
);
   
   // Objects
   uvma_axil_cfg_c    cfg;
   uvma_axil_cntxt_c  cntxt;
   
   // TLM
   uvm_analysis_port     #(uvma_axil_mstr_seq_item_c)  mstr_ap;
   uvm_analysis_port     #(uvma_axil_slv_seq_item_c )  slv_ap ;
   uvm_tlm_analysis_fifo #(uvma_axil_mon_trn_c      )  mon_trn_fifo;
   
   // Handles to virtual interface modport
   virtual uvma_axil_if.active_mstr_mp  vif_mstr_mp;
   virtual uvma_axil_if.active_slv_mp   vif_slv_mp ;
   
   
   `uvm_component_utils_begin(uvma_axil_drv_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvma_axil_drv", uvm_component parent=null);
   
   /**
    * 1. Ensures cfg & cntxt handles are not null.
    * 2. Builds ap.
    */
   extern virtual function void build_phase(uvm_phase phase);
   
   /**
    * Oversees driving, depending on the reset state, by calling drv_<pre|in|post>_reset() tasks.
    */
   extern virtual task run_phase(uvm_phase phase);
   
   /**
    * Called by run_phase() while agent is in pre-reset state.
    */
   extern virtual task drv_pre_reset(uvm_phase phase);
   
   /**
    * Called by run_phase() while agent is in reset state.
    */
   extern virtual task drv_in_reset(uvm_phase phase);
   
   /**
    * Called by run_phase() while agent is in post-reset state.
    */
   extern task drv_post_reset(uvm_phase phase);
   
   /**
    * Drives the interface's (cntxt.vif) signals using req's contents.
    */
   extern task get_next_item(output uvma_axil_mstr_seq_item_c req);
   
   /**
    * Drives the interface's (cntxt.vif) signals using req's contents.
    */
   extern task drv_mstr_req(ref uvma_axil_mstr_seq_item_c req);
   
   /**
    * Drives the interface's (cntxt.vif) signals using req's contents.
    */
   extern virtual task drv_mstr_read_req(ref uvma_axil_mstr_seq_item_c req);
   
   /**
    * Drives the interface's (cntxt.vif) signals using req's contents.
    */
   extern virtual task drv_mstr_write_req(ref uvma_axil_mstr_seq_item_c req);
   
   /**
    * Drives the interface's (cntxt.vif) signals using req's contents.
    */
   extern task drv_slv_req(ref uvma_axil_slv_seq_item_c req);
   
   /**
    * Drives the interface's (cntxt.vif) signals using req's contents.
    */
   extern virtual task drv_slv_read_req(ref uvma_axil_slv_seq_item_c req);
   
   /**
    * Drives the interface's (cntxt.vif) signals using req's contents.
    */
   extern virtual task drv_slv_write_req(ref uvma_axil_slv_seq_item_c req);
   
   /**
    * TODO Describe uvma_axil_drv_c::wait_for_rsp()
    */
   extern task wait_for_rsp(output uvma_axil_mon_trn_c rsp);
   
   /**
    * TODO Describe uvma_axil_drv_c::process_mstr_rsp()
    */
   extern virtual task process_mstr_rsp(ref uvma_axil_mstr_seq_item_c req, ref uvma_axil_mon_trn_c rsp);
   
   /**
    * TODO Describe uvma_axil_drv_c::drv_mstr_idle()
    */
   extern virtual task drv_mstr_idle(uvma_axil_access_type_enum access_type);
   
   /**
    * TODO Describe uvma_axil_drv_c::drv_slv_idle()
    */
   extern virtual task drv_slv_idle(uvma_axil_access_type_enum access_type);
   
endclass : uvma_axil_drv_c


function uvma_axil_drv_c::new(string name="uvma_axil_drv", uvm_component parent=null);
   
   super.new(name, parent);
   
endfunction : new


function void uvma_axil_drv_c::build_phase(uvm_phase phase);
   
   super.build_phase(phase);
   
   void'(uvm_config_db#(uvma_axil_cfg_c)::get(this, "", "cfg", cfg));
   if (!cfg) begin
      `uvm_fatal("CFG", "Configuration handle is null")
   end
   uvm_config_db#(uvma_axil_cfg_c)::set(this, "*", "cfg", cfg);
   //vif_mstr_mp = cntxt.vif.active_mstr_mp;
   //vif_slv_mp  = cntxt.vif.active_slv_mp ;
   
   void'(uvm_config_db#(uvma_axil_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (!cntxt) begin
      `uvm_fatal("CNTXT", "Context handle is null")
   end
   uvm_config_db#(uvma_axil_cntxt_c)::set(this, "*", "cntxt", cntxt);
   
   mstr_ap      = new("mstr_ap"     , this);
   slv_ap       = new("slv_ap"      , this);
   mon_trn_fifo = new("mon_trn_fifo", this);
   
endfunction : build_phase


task uvma_axil_drv_c::run_phase(uvm_phase phase);
   
   super.run_phase(phase);
   
   forever begin
      wait (cfg.enabled && cfg.is_active);
      
      fork
         begin
            case (cntxt.reset_state)
               UVMA_AXIL_RESET_STATE_PRE_RESET : drv_pre_reset (phase);
               UVMA_AXIL_RESET_STATE_IN_RESET  : drv_in_reset  (phase);
               UVMA_AXIL_RESET_STATE_POST_RESET: drv_post_reset(phase);
               
               default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid reset_state: %0d", cntxt.reset_state))
            endcase
         end
         
         begin
            wait (!(cfg.enabled && cfg.is_active));
         end
      join_any
      disable fork;
   end
   
endtask : run_phase


task uvma_axil_drv_c::drv_pre_reset(uvm_phase phase);
   
   case (cfg.drv_mode)
      UVMA_AXIL_MODE_MSTR: @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
      UVMA_AXIL_MODE_SLV : @(cntxt.vif./*active_slv_mp.*/drv_slv_cb );
      
      default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid drv_mode: %0d", cfg.drv_mode))
   endcase
   
endtask : drv_pre_reset


task uvma_axil_drv_c::drv_in_reset(uvm_phase phase);
   
   case (cfg.drv_mode)
      UVMA_AXIL_MODE_MSTR: @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
      UVMA_AXIL_MODE_SLV : @(cntxt.vif./*active_slv_mp.*/drv_slv_cb );
      
      default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid drv_mode: %0d", cfg.drv_mode))
   endcase
   
endtask : drv_in_reset


task uvma_axil_drv_c::drv_post_reset(uvm_phase phase);
   
   uvma_axil_mstr_seq_item_c  mstr_req;
   uvma_axil_slv_seq_item_c   slv_req;
   uvma_axil_mon_trn_c        mstr_rsp;
   uvma_axil_mon_trn_c        slv_rsp;
   
   case (cfg.drv_mode)
      UVMA_AXIL_MODE_MSTR: begin
         // 1. Get next req from sequence and drive it on the vif
         get_next_item(req);
         if (!$cast(mstr_req, req)) begin
            `uvm_fatal("AXIL_DRV", $sformatf("Could not cast 'req' (%s) to 'mstr_req' (%s)", $typename(req), $typename(mstr_req)))
         end
         `uvm_info("AXIL_DRV", $sformatf("Got mstr_req:\n%s", mstr_req.sprint()), UVM_HIGH)
         drv_mstr_req(mstr_req);
         
         // 2. Wait for the monitor to send us the slv's rsp with the results of the req
         wait_for_rsp(slv_rsp);
         process_mstr_rsp(mstr_req, slv_rsp);
         
         // 3. Send port out to TLM and tell sequencer we're ready for the next sequence item
         mstr_ap.write(mstr_req);
         seq_item_port.item_done();
      end
      
      UVMA_AXIL_MODE_SLV: begin
         // 1. Get next req from sequence to reply to mstr and drive it on the vif
         get_next_item(req);
         if (!$cast(slv_req, req)) begin
            `uvm_fatal("AXIL_DRV", $sformatf("Could not cast 'req' (%s) to 'slv_req' (%s)", $typename(req), $typename(slv_req)))
         end
         `uvm_info("AXIL_DRV", $sformatf("Got slv_req:\n%s", slv_req.sprint()), UVM_HIGH)
         drv_slv_req(slv_req);
         
         // 2. Send out to TLM and tell sequencer we're ready for the next sequence item
         wait_for_rsp(slv_rsp);
         slv_req.req_trn = slv_rsp;
         slv_ap.write(slv_req);
         seq_item_port.item_done();
      end
      
      default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid drv_mode: %0d", cfg.drv_mode))
   endcase
   
endtask : drv_post_reset


task uvma_axil_drv_c::get_next_item(output uvma_axil_base_seq_item_c req);
   
   seq_item_port.get_next_item(req);
   `uvml_hrtbt()
   
   // Copy cfg fields
   req.mode           = cfg.drv_mode;
   req.addr_bus_width = cfg.addr_bus_width;
   req.data_bus_width = cfg.data_bus_width;
   
endtask : get_next_item


task uvma_axil_drv_c::drv_mstr_req(ref uvma_axil_mstr_seq_item_c req);
   
   case (req.access_type)
      UVMA_AXIL_ACCESS_READ: begin
         drv_mstr_read_req(req);
      end
      
      UVMA_AXIL_ACCESS_WRITE: begin
         drv_mstr_write_req(req);
      end
      
      default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid access_type: %0d", req.access_type))
   endcase
   
endtask : drv_mstr_req


task uvma_axil_drv_c::drv_mstr_read_req(ref uvma_axil_mstr_seq_item_c req);
   
   // Address and Data phase can happen simultaneously
   fork
      // Address Channel
      begin
         // Address Latency cycles
         repeat (req.addr_latency) begin
            @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
         end
         // Address phase
         cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.arvalid <= 1'b1;
         for (int unsigned ii=0; ii<cfg.addr_bus_width; ii++) begin
            cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.araddr[ii] <= req.address[ii];
         end
      end
      
      // Data Channel
      begin
         // Data Latency cycles
         repeat (req.data_latency) begin
            @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
         end
         cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.rready <= 1'b1;
      end
   join
   
   // Wait for 'slv' ready
   while (cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.arready !== 1'b1) begin
      @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
   end
   
   // Wait for 'slv' rvalid
   while (cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.rvalid !== 1'b1) begin
      @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
   end
   
   // Readback
   cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.arvalid <= 1'b0;
   drv_mstr_idle(UVMA_AXIL_ACCESS_READ);
   
   // Readback Hold Cycles
   repeat (req.hold_duration) begin
      @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
   end
   
   // Tail
   cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.rready <= 1'b0;
   repeat (req.tail_duration) begin
      @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
   end
   
endtask : drv_mstr_read_req


task uvma_axil_drv_c::drv_mstr_write_req(ref uvma_axil_mstr_seq_item_c req);
   
   // Address and Data phase can happen simultaneously
   fork
      // Address Channel
      begin
         // Latency cycles
         repeat (req.addr_latency) begin
            @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
         end
         // Address phase
         cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.awvalid <= 1'b1;
         for (int unsigned ii=0; ii<cfg.addr_bus_width; ii++) begin
            cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.awaddr[ii] <= req.address[ii];
         end
         
         // Wait for 'slv' ready
         while (cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.awready !== 1'b1) begin
            @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
         end
         `uvm_info("AXIL_DRV", $sformatf("Finished write address phase for req:\n%s", req.sprint()), UVM_DEBUG)
      end
      
      // Data Channel
      begin
         // Latency cycles
         repeat (req.data_latency) begin
            @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
         end
         cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wvalid <= 1'b1;
         for (int unsigned ii=0; ii<cfg.data_bus_width; ii++) begin
            cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wdata[ii] <= req.wdata[ii];
         end
         for (int unsigned ii=0; ii<cfg.strobe_bus_width; ii++) begin
            cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wstrb[ii] <= req.wstrobe[ii];
         end
         
         // Wait for 'slv' ready
         while (cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wready !== 1'b1) begin
            @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
         end
         `uvm_info("AXIL_DRV", $sformatf("Finished write data phase for req:\n%s", req.sprint()), UVM_DEBUG)
      end
      
      // Response Channel
      begin
         // Latency cycles
         repeat (req.rsp_latency) begin
            @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
         end
         cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.bready <= 1'b1;
      end
   join
   
   // Wait for 'slv' bvalid
   while (cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.bvalid !== 1'b1) begin
      @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
   end
   `uvm_info("AXIL_DRV", $sformatf("Finished waiting for bvalid for req:\n%s", req.sprint()), UVM_DEBUG)
   
   // Readback Hold Cycles
   repeat (req.hold_duration) begin
      @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
   end
   `uvm_info("AXIL_DRV", $sformatf("Finished response hold cycles (%0d) for req:\n%s", req.hold_duration, req.sprint()), UVM_DEBUG)
   
   // Tail
   cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.awvalid <= 1'b0;
   cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wvalid  <= 1'b0;
   cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.bready  <= 1'b0;
   drv_mstr_idle(UVMA_AXIL_ACCESS_WRITE);
   repeat (req.tail_duration) begin
      @(cntxt.vif./*active_mstr_mp.*/drv_mstr_cb);
   end
   `uvm_info("AXIL_DRV", $sformatf("Finished tail cycles (%0d) for req:\n%s", req.tail_duration, req.sprint()), UVM_DEBUG)
   
endtask : drv_mstr_write_req


task uvma_axil_drv_c::drv_slv_req(ref uvma_axil_slv_seq_item_c req);
   
   case (req.access_type)
      UVMA_AXIL_ACCESS_READ: begin
         drv_slv_read_req(req);
      end
      
      UVMA_AXIL_ACCESS_WRITE: begin
         drv_slv_write_req(req);
      end
      
      default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid access_type: %0d", req.access_type))
   endcase
   
endtask : drv_slv_req


task uvma_axil_drv_c::drv_slv_read_req(ref uvma_axil_slv_seq_item_c req);
   
   // Latency cycles
   repeat (req.addr_latency) begin
      @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
   end
   
   // Address phase
   cntxt.vif./*active_slv_mp.*/drv_slv_cb.arready <= 1'b1;
   repeat (req.data_latency) begin
      @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
   end
   
   // Read back phase
   while (cntxt.vif./*active_slv_mp.*/drv_slv_cb.rready !== 1'b1) begin
      @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
   end
   cntxt.vif./*active_slv_mp.*/drv_slv_cb.rvalid <= 1'b1;
   cntxt.vif./*active_slv_mp.*/drv_slv_cb.rresp  <= req.response;
   for (int unsigned ii=0; ii<cfg.data_bus_width; ii++) begin
      cntxt.vif./*active_slv_mp.*/drv_slv_cb.rdata[ii] <= req.rdata[ii];
   end
   
   // Hold cycles
   repeat (req.hold_duration) begin
      @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
   end
   
   // Idle
   repeat (req.tail_duration) begin
      @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
      drv_slv_idle(UVMA_AXIL_ACCESS_READ);
   end
   
endtask : drv_slv_read_req


task uvma_axil_drv_c::drv_slv_write_req(ref uvma_axil_slv_seq_item_c req);
   
   // Address and Data phase can happen simultaneously
   fork
      // Address Channel
      begin
         // Address Latency cycles
         repeat (req.addr_latency) begin
            @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
         end
         
         // Address phase
         cntxt.vif./*active_slv_mp.*/drv_slv_cb.awready <= 1'b1;
      end
      
      // Data Channel
      begin
         // Data Latency cycles
         repeat (req.data_latency) begin
            @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
         end
         
         // Data phase
         while (cntxt.vif./*active_slv_mp.*/drv_slv_cb.wvalid !== 1'b1) begin
            @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
         end
         cntxt.vif./*active_slv_mp.*/drv_slv_cb.wready <= 1'b1;
      end
   join
   
   // Wait for 'mstr' to be ready for the response
   while (cntxt.vif./*active_slv_mp.*/drv_slv_cb.bready !== 1'b1) begin
      @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
   end
   
   // Response latency
   repeat (req.rsp_latency) begin
      @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
   end
   
   // Write back response and hold cycles
   cntxt.vif./*active_slv_mp.*/drv_slv_cb.bvalid <= 1'b1;
   cntxt.vif./*active_slv_mp.*/drv_slv_cb.bresp  <= req.response;
   repeat (req.hold_duration) begin
      @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
   end
   
   // Idle
   repeat (req.tail_duration) begin
      @(cntxt.vif./*active_slv_mp.*/drv_slv_cb);
      drv_slv_idle(UVMA_AXIL_ACCESS_WRITE);
   end
   
endtask : drv_slv_write_req


task uvma_axil_drv_c::wait_for_rsp(output uvma_axil_mon_trn_c rsp);
   
   mon_trn_fifo.get(rsp);
   
endtask : wait_for_rsp


task uvma_axil_drv_c::process_mstr_rsp(ref uvma_axil_mstr_seq_item_c req, ref uvma_axil_mon_trn_c rsp);
   
   req.rdata     = rsp.data ;
   req.response  = rsp.response;
   
endtask : process_mstr_rsp


task uvma_axil_drv_c::drv_mstr_idle(uvma_axil_access_type_enum access_type);
   
   case (access_type)
      UVMA_AXIL_ACCESS_READ: begin
         case (cfg.drv_idle)
            UVMA_AXIL_DRV_IDLE_SAME: ;// Do nothing;
            
            UVMA_AXIL_DRV_IDLE_ZEROS : cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.araddr <= '0;
            UVMA_AXIL_DRV_IDLE_RANDOM: cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.araddr <= $urandom();
            UVMA_AXIL_DRV_IDLE_X     : cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.araddr <= 'X;
            UVMA_AXIL_DRV_IDLE_Z     : cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.araddr <= 'Z;
            
            default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid drv_idle: %0d", cfg.drv_idle))
         endcase
      end
      
      UVMA_AXIL_ACCESS_WRITE: begin
         case (cfg.drv_idle)
            UVMA_AXIL_DRV_IDLE_SAME: ;// Do nothing;
            
            UVMA_AXIL_DRV_IDLE_ZEROS: begin
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.awaddr <= '0;
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wdata  <= '0;
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wstrb  <= '0;
            end
            
            UVMA_AXIL_DRV_IDLE_RANDOM: begin
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.araddr <= $urandom();
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wdata  <= $urandom();
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wstrb  <= $urandom();
            end
            
            UVMA_AXIL_DRV_IDLE_X: begin
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.araddr <= 'X;
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wdata  <= 'X;
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wstrb  <= 'X;
            end
            
            UVMA_AXIL_DRV_IDLE_Z: begin
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.araddr <= 'Z;
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wdata  <= 'Z;
               cntxt.vif./*active_mstr_mp.*/drv_mstr_cb.wstrb  <= 'Z;
            end
            
            default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid drv_idle: %0d", cfg.drv_idle))
         endcase
      end
      
      default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid access_type: %0d", access_type))
   endcase
   
endtask : drv_mstr_idle


task uvma_axil_drv_c::drv_slv_idle(uvma_axil_access_type_enum access_type);
   
   case (access_type)
      UVMA_AXIL_ACCESS_READ: begin
         cntxt.vif./*active_slv_mp.*/drv_slv_cb.arready <= '0;
         cntxt.vif./*active_slv_mp.*/drv_slv_cb.rvalid  <= '0;
         
         case (cfg.drv_idle)
            UVMA_AXIL_DRV_IDLE_SAME: ;// Do nothing;
            
            UVMA_AXIL_DRV_IDLE_ZEROS: begin
               cntxt.vif./*active_slv_mp.*/drv_slv_cb.rdata <= '0;
               cntxt.vif./*active_slv_mp.*/drv_slv_cb.rresp <= '0;
            end
            
            UVMA_AXIL_DRV_IDLE_RANDOM: begin
               cntxt.vif./*active_slv_mp.*/drv_slv_cb.rdata <= $urandom();
               cntxt.vif./*active_slv_mp.*/drv_slv_cb.rresp <= $urandom();
            end
            
            UVMA_AXIL_DRV_IDLE_X: begin
               cntxt.vif./*active_slv_mp.*/drv_slv_cb.rdata <= 'X;
               cntxt.vif./*active_slv_mp.*/drv_slv_cb.rresp <= 'X;
            end
            
            UVMA_AXIL_DRV_IDLE_Z: begin
               cntxt.vif./*active_slv_mp.*/drv_slv_cb.rdata <= 'Z;
               cntxt.vif./*active_slv_mp.*/drv_slv_cb.rresp <= 'Z;
            end
            
            default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid drv_idle: %0d", cfg.drv_idle))
         endcase
      end
      
      UVMA_AXIL_ACCESS_WRITE: begin
         cntxt.vif./*active_slv_mp.*/drv_slv_cb.awready <= '0;
         cntxt.vif./*active_slv_mp.*/drv_slv_cb.wready  <= '0;
         cntxt.vif./*active_slv_mp.*/drv_slv_cb.bvalid  <= '0;
         
         case (cfg.drv_idle)
            UVMA_AXIL_DRV_IDLE_SAME  : ;// Do nothing;
            UVMA_AXIL_DRV_IDLE_ZEROS : cntxt.vif./*active_slv_mp.*/drv_slv_cb.bresp <= '0;
            UVMA_AXIL_DRV_IDLE_RANDOM: cntxt.vif./*active_slv_mp.*/drv_slv_cb.bresp <= $urandom();
            UVMA_AXIL_DRV_IDLE_X     : cntxt.vif./*active_slv_mp.*/drv_slv_cb.bresp <= 'X;
            UVMA_AXIL_DRV_IDLE_Z     : cntxt.vif./*active_slv_mp.*/drv_slv_cb.bresp <= 'Z;
            
            default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid drv_idle: %0d", cfg.drv_idle))
         endcase
      end
      
      default: `uvm_fatal("AXIL_DRV", $sformatf("Invalid access_type: %0d", access_type))
   endcase
   
endtask : drv_slv_idle


`endif // __UVMA_AXIL_DRV_SV__
