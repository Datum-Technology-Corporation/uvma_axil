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


`ifndef __UVMA_AXIL_IF_SV__
`define __UVMA_AXIL_IF_SV__


/**
 * Encapsulates all signals and clocking of AMBA Advanced eXtensible Interface interface. Used by
 * monitor (uvma_axil_mon_c) and driver (uvma_axil_drv_c).
 */
interface uvma_axil_if (
   input logic clk    ,
   input logic reset_n
);
   
   // Write Address Channel Signals
   wire [(`UVMA_AXIL_ADDR_MAX_SIZE-1):0]  awaddr ;
   wire                                   awvalid;
   wire                                   awready;
   
   // Write Data Channel Signals
   wire [    (`UVMA_AXIL_DATA_MAX_SIZE-1):0]  wdata ;
   wire [((`UVMA_AXIL_DATA_MAX_SIZE/8)-1):0]  wstrb ;
   wire                                       wvalid;
   wire                                       wready;
   
   // Write Response Channel Signals
   wire [1:0]  bresp ;
   wire        bvalid;
   wire        bready;
   
   // Read Address Channel Signals
   wire [(`UVMA_AXIL_ADDR_MAX_SIZE-1):0]  araddr ;
   wire                                   arvalid;
   wire                                   arready;
   
   // Read Data Channel Signals
   wire [(`UVMA_AXIL_DATA_MAX_SIZE-1):0]  rdata ;
   wire                            [1:0]  rresp ;
   wire                                   rvalid;
   wire                                   rready;
   
   
   /**
    * Used by DUT in 'mstr' mode.
    */
   clocking dut_mstr_cb @(posedge clk);
      input   awready,
              wready ,
              bresp  ,
              bvalid ,
              arready,
              rdata  ,
              rresp  ,
              rvalid ;
      output  awaddr ,
              awvalid,
              wdata  ,
              wstrb  ,
              wvalid ,
              bready ,
              araddr ,
              arvalid,
              rready ;
   endclocking : dut_mstr_cb
   
   /**
    * Used by DUT in 'slv' mode.
    */
   clocking dut_slv_cb @(posedge clk);
      output  awready,
              wready ,
              bresp  ,
              bvalid ,
              arready,
              rdata  ,
              rresp  ,
              rvalid ;
      input   awaddr ,
              awvalid,
              wdata  ,
              wstrb  ,
              wvalid ,
              bready ,
              araddr ,
              arvalid,
              rready ;
   endclocking : dut_slv_cb
   
   /**
    * Used by uvma_axil_drv_c.
    */
   clocking drv_mstr_cb @(posedge clk);
      input   awready,
              wready ,
              bresp  ,
              bvalid ,
              arready,
              rdata  ,
              rresp  ,
              rvalid ;
      output  awaddr ,
              awvalid,
              wdata  ,
              wstrb  ,
              wvalid ,
              bready ,
              araddr ,
              arvalid,
              rready ;
   endclocking : drv_mstr_cb
   
   /**
    * Used by uvma_axil_drv_c.
    */
   clocking drv_slv_cb @(posedge clk);
      output  awready,
              wready ,
              bresp  ,
              bvalid ,
              arready,
              rdata  ,
              rresp  ,
              rvalid ;
      input   awaddr ,
              awvalid,
              wdata  ,
              wstrb  ,
              wvalid ,
              bready ,
              araddr ,
              arvalid,
              rready ;
   endclocking : drv_slv_cb
   
   /**
    * Used by uvma_axil_mon_c.
    */
   clocking mon_cb @(posedge clk);
      input   awaddr ,
              awready,
              awvalid,
              wdata  ,
              wstrb  ,
              wvalid ,
              wready ,
              bresp  ,
              bvalid ,
              bready ,
              araddr ,
              arvalid,
              arready,
              rdata  ,
              rresp  ,
              rvalid ,
              rready ;
   endclocking : mon_cb
   
   
   modport dut_mstr_mp   (clocking dut_mstr_cb);
   modport dut_slv_mp    (clocking dut_slv_cb );
   modport active_mstr_mp(clocking drv_mstr_cb);
   modport active_slv_mp (clocking drv_slv_cb );
   modport passive_mp    (clocking mon_cb     );
   
endinterface : uvma_axil_if


`endif // __UVMA_AXIL_IF_SV__
