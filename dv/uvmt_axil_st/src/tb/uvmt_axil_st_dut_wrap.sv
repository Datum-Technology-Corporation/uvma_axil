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


`ifndef __UVMT_AXIL_ST_DUT_WRAP_SV__
`define __UVMT_AXIL_ST_DUT_WRAP_SV__


/**
 * Module wrapper for AMBA Advanced eXtensible Interface RTL DUT. All ports are SV interfaces.
 */
module uvmt_axil_st_dut_wrap(
   uvma_axil_if  mstr_if,
   uvma_axil_if  slv_if
);
   
   assign slv_if .awaddr  = mstr_if.awaddr ;
   assign slv_if .awvalid = mstr_if.awvalid;
   assign mstr_if.awready = slv_if .awready;
   
   assign slv_if .wdata  = mstr_if.wdata  ;
   assign slv_if .wstrb  = mstr_if.wstrb  ;
   assign slv_if .wvalid = mstr_if.wvalid ;
   assign mstr_if.wready = slv_if .wready ;
   
   assign mstr_if.bresp  = slv_if .bresp ;
   assign mstr_if.bvalid = slv_if .bvalid;
   assign slv_if .bready = mstr_if.bready;
   
   assign slv_if .araddr  = mstr_if.araddr ;
   assign slv_if .arvalid = mstr_if.arvalid;
   assign mstr_if.arready = slv_if .arready;
   
   assign mstr_if.rdata  = slv_if .rdata ;
   assign mstr_if.rresp  = slv_if .rresp ;
   assign mstr_if.rvalid = slv_if .rvalid;
   assign slv_if .rready = mstr_if.rready;
   
endmodule : uvmt_axil_st_dut_wrap


`endif // __UVMT_AXIL_ST_DUT_WRAP_SV__
