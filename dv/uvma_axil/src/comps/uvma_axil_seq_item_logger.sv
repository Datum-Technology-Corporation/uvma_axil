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


`ifndef __UVMA_AXIL_SEQ_ITEM_LOGGER_SV__
`define __UVMA_AXIL_SEQ_ITEM_LOGGER_SV__


/**
 * Component writing AMBA Advanced eXtensible Interface sequence items debug data to disk as plain text.
 */
class uvma_axil_seq_item_logger_c extends uvml_logs_seq_item_logger_c#(
   .T_TRN  (uvma_axil_base_seq_item_c),
   .T_CFG  (uvma_axil_cfg_c          ),
   .T_CNTXT(uvma_axil_cntxt_c        )
);
   
   `uvm_component_utils(uvma_axil_seq_item_logger_c)
   
   
   /**
    * Default constructor.
    */
   function new(string name="uvma_axil_seq_item_logger", uvm_component parent=null);
      
      super.new(name, parent);
      
   endfunction : new
   
   /**
    * Writes contents of t to disk.
    */
   virtual function void write(uvma_axil_base_seq_item_c t);
      
      uvma_axil_mstr_seq_item_c  mstr_t;
      uvma_axil_slv_seq_item_c   slv_t;
      
      case (cfg.drv_mode)
         UVMA_AXIL_MODE_MSTR: begin
            if (!$cast(mstr_t, t)) begin
               `uvm_fatal("AXIL_SEQ_ITEM_LOGGER", $sformatf("Could not cast 't' (%s) to 'mstr_t' (%s)", $typename(t), $typename(mstr_t)))
            end
            write_mstr(mstr_t);
         end
         
         UVMA_AXIL_MODE_SLV: begin
            if (!$cast(slv_t, t)) begin
               `uvm_fatal("AXIL_SEQ_ITEM_LOGGER", $sformatf("Could not cast 't' (%s) to 'slv_t' (%s)", $typename(t), $typename(slv_t)))
            end
            write_slv(slv_t);
         end
         
         default: `uvm_fatal("AXIL_SEQ_ITEM_LOGGER", $sformatf("Invalid drv_mode: %0d", cfg.drv_mode))
      endcase
      
   endfunction : write
   
   /**
    * Writes contents of mstr t to disk.
    */
   virtual function void write_mstr(uvma_axil_mstr_seq_item_c t);
      
      string access_str = "";
      string rsp_str    = "";
      string strobe_str = "";
      string data_str   = "";
      
      case (t.access_type)
         UVMA_AXIL_ACCESS_READ : access_str = "R  ";
         UVMA_AXIL_ACCESS_WRITE: access_str = "  W";
         default               : access_str = " ? ";
      endcase
      
      case (t.response)
         UVMA_AXIL_RESPONSE_OK    : rsp_str = " OK ";
         UVMA_AXIL_RESPONSE_SLVERR: rsp_str = " ERR";
         default                  : rsp_str = "  ? ";
      endcase
      
      case (t.access_type)
         UVMA_AXIL_ACCESS_READ: begin
            strobe_str = "   ";
            data_str   = $sformatf("%b", t.rdata  );
         end
         
         UVMA_AXIL_ACCESS_WRITE: begin
            strobe_str = $sformatf("%b", t.wstrobe);
            data_str   = $sformatf("%h", t.wdata  );
         end
      endcase
      
      fwrite($sformatf(" %t | %s | %s | %h | %s | %s ", $realtime(), access_str, rsp_str, t.address, strobe_str, data_str));
      
   endfunction : write_mstr
   
   /**
    * Writes contents of slv t to disk.
    */
   virtual function void write_slv(uvma_axil_slv_seq_item_c t);
      
      string access_str = "";
      string rsp_str    = "";
      string data_str   = "";
      
      case (t.access_type)
         UVMA_AXIL_ACCESS_READ : access_str = "R  ";
         UVMA_AXIL_ACCESS_WRITE: access_str = "  W";
         default               : access_str = " ? ";
      endcase
      
      case (t.response)
         UVMA_AXIL_RESPONSE_OK    : rsp_str = " OK ";
         UVMA_AXIL_RESPONSE_SLVERR: rsp_str = " ERR";
         default                  : rsp_str = "  ? ";
      endcase
      
      case (t.access_type)
         UVMA_AXIL_ACCESS_READ: begin
            data_str = $sformatf("%h", t.rdata);
         end
         
         UVMA_AXIL_ACCESS_WRITE: begin
            data_str = $sformatf("%h", t.req_trn.data  );
         end
      endcase
      
      fwrite($sformatf(" %t | %s | %s | %h |  %h | %s ", $realtime(), access_str, rsp_str, t.req_trn.address, t.req_trn.strobe, data_str));
      
   endfunction : write_slv
   
   /**
    * Writes log header to disk.
    */
   virtual function void print_header();
      
      fwrite("----------------------------------------------------");
      fwrite("        TIME        | R/W | RESP | ADDRESS  | STRB | DATA");
      fwrite("----------------------------------------------------");
      
   endfunction : print_header
   
endclass : uvma_axil_seq_item_logger_c


/**
 * Component writing AMBA Advanced eXtensible Interface monitor transactions debug data to disk as JavaScript Object Notation (JSON).
 */
class uvma_axil_seq_item_logger_json_c extends uvma_axil_seq_item_logger_c;
   
   `uvm_component_utils(uvma_axil_seq_item_logger_json_c)
   
   
   /**
    * Set file extension to '.json'.
    */
   function new(string name="uvma_axil_seq_item_logger_json", uvm_component parent=null);
      
      super.new(name, parent);
      fextension = "json";
      
   endfunction : new
   
   /**
    * Writes contents of t to disk.
    */
   virtual function void write(uvma_axil_base_seq_item_c t);
      
      // TODO Implement uvma_axil_seq_item_logger_json_c::write()
      // Ex: fwrite({"{",
      //       $sformatf("\"time\":\"%0t\",", $realtime()),
      //       $sformatf("\"a\":%h,"        , t.a        ),
      //       $sformatf("\"b\":%b,"        , t.b        ),
      //       $sformatf("\"c\":%d,"        , t.c        ),
      //       $sformatf("\"d\":%h,"        , t.c        ),
      //     "},"});
      
   endfunction : write
   
   /**
    * Empty function.
    */
   virtual function void print_header();
      
      // Do nothing: JSON files do not use headers.
      
   endfunction : print_header
   
endclass : uvma_axil_seq_item_logger_json_c


`endif // __UVMA_AXIL_SEQ_ITEM_LOGGER_SV__
