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


`ifndef __UVMA_AXIL_REG_ADAPTER_SV__
`define __UVMA_AXIL_REG_ADAPTER_SV__


/**
 * Object that converts between abstract register operations (UVM) and AXI-Lite Bus operations.
 */
class uvma_axil_reg_adapter_c extends uvml_ral_reg_adapter_c;
   
   `uvm_object_utils(uvma_axil_reg_adapter_c)
   
   
   /**
    * Default constructor
    */
   extern function new(string name="uvma_axil_reg_adapter");
   
   /**
    * Converts from UVM register operation to Advanced Peripheral Bus.
    */
   extern virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
   
   /**
    * Converts from AXI-Lite to UVM register operation.
    */
   extern virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
   
endclass : uvma_axil_reg_adapter_c


function uvma_axil_reg_adapter_c::new(string name="uvma_axil_reg_adapter");
   
   super.new(name);
   supports_byte_enable = 1;
   
endfunction : new


function uvm_sequence_item uvma_axil_reg_adapter_c::reg2bus(const ref uvm_reg_bus_op rw);
   
   uvma_axil_mstr_seq_item_c  axil_trn = uvma_axil_mstr_seq_item_c::type_id::create("axil_trn");
   
   axil_trn.access_type = (rw.kind == UVM_READ) ? UVMA_AXIL_ACCESS_READ : UVMA_AXIL_ACCESS_WRITE;
   axil_trn.address     = rw.addr;
   axil_trn.wstrobe     = rw.byte_en;
   
   if (rw.kind == UVM_WRITE) begin
      axil_trn.wdata = rw.data;
   end
   
   return axil_trn;
   
endfunction : reg2bus


function void uvma_axil_reg_adapter_c::bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
   
   uvma_axil_mstr_seq_item_c  axil_trn;
   
   if (!$cast(axil_trn, bus_item)) begin
      `uvm_fatal("AXIL_REG_ADAPTER", $sformatf("Could not cast bus_item (%s) into axil_trn (%s)", $typename(bus_item), $typename(axil_trn)))
   end
   
   rw.kind = (axil_trn.access_type == UVMA_AXIL_ACCESS_READ) ? UVM_READ : UVM_WRITE;
   rw.addr = axil_trn.address;
   rw.byte_en = axil_trn.wstrobe;
   
   case (axil_trn.access_type)
      UVMA_AXIL_ACCESS_READ : rw.data = axil_trn.rdata;
      UVMA_AXIL_ACCESS_WRITE: rw.data = axil_trn.wdata;
      
      default: `uvm_fatal("AXIL_REG_ADAPTER", $sformatf("Invalid access_type: %0d", axil_trn.access_type))
   endcase
   
   if (axil_trn.response === UVMA_AXIL_RESPONSE_OK) begin
      rw.status = UVM_IS_OK;
   end
   else begin
      rw.status = UVM_NOT_OK;
   end
   
endfunction : bus2reg


`endif // __UVMA_AXIL_REG_ADAPTER_SV__
