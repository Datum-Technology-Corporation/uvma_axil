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


`ifndef __UVMA_AXIL_MON_TRN_SV__
`define __UVMA_AXIL_MON_TRN_SV__


/**
 * Object rebuilt from the AMBA Advanced eXtensible Interface monitor Analog of uvma_axil_seq_item_c.
 */
class uvma_axil_mon_trn_c extends uvml_mon_trn_c;
   
   // Data
   uvma_axil_access_type_enum                  access_type;
   logic [(`UVMA_AXIL_ADDR_MAX_SIZE-1):0]      address    ;
   logic [(`UVMA_AXIL_DATA_MAX_SIZE-1):0]      data       ;
   logic [((`UVMA_AXIL_DATA_MAX_SIZE/8)-1):0]  strobe     ;
   uvma_axil_response_enum                     response   ;
   
   // Metadata
   int unsigned  addr_bus_width; // Measured in bytes (B)
   int unsigned  data_bus_width; // Measured in bytes (B)
   int unsigned  latency       ; // Measured in clock cycles
   
   
   `uvm_object_utils_begin(uvma_axil_mon_trn_c)
      `uvm_field_enum(uvma_axil_access_type_enum, access_type, UVM_DEFAULT + UVM_NOCOMPARE)
      `uvm_field_int (                            address    , UVM_DEFAULT + UVM_NOCOMPARE)
      `uvm_field_int (                            data       , UVM_DEFAULT + UVM_NOCOMPARE)
      `uvm_field_int (                            strobe     , UVM_DEFAULT + UVM_NOCOMPARE)
      `uvm_field_enum(uvma_axil_response_enum,    response   , UVM_DEFAULT + UVM_NOCOMPARE)
   `uvm_object_utils_end
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvma_axil_mon_trn");
   
   /**
    * TODO Describe uvma_axil_mon_trn_c::do_compare()
    */
   extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
   
endclass : uvma_axil_mon_trn_c


function uvma_axil_mon_trn_c::new(string name="uvma_axil_mon_trn");
   
   super.new(name);
   
endfunction : new


function bit uvma_axil_mon_trn_c::do_compare(uvm_object rhs, uvm_comparer comparer);
   
   uvma_axil_mon_trn_c  rhs_;
   
   if (!$cast(rhs_, rhs)) begin
      `uvm_fatal("UVME_AXIL_ST_E2E_MON_TRN", $sformatf("Could not cast 'rhs' (%s) to 'rhs_' (%s)", $typename(rhs), $typename(rhs_)))
   end
   
   do_compare = 1;
   do_compare &= comparer.compare_field_int("access_type", access_type, rhs_.access_type, $bits(access_type));
   do_compare &= comparer.compare_field_int("address"    , address    , rhs_.address    , addr_bus_width    );
   do_compare &= comparer.compare_field_int("data"       , data       , rhs_.data       , data_bus_width    );
   do_compare &= comparer.compare_field_int("strobe"     , strobe     , rhs_.strobe     , data_bus_width/8  );
   do_compare &= comparer.compare_field_int("response"   , response   , rhs_.response   , $bits(response)   );
   
endfunction : do_compare


`endif // __UVMA_AXIL_MON_TRN_SV__
