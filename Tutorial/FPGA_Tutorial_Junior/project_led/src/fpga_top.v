//****************************************************************************************************  
//---------------Copyright (c) 2019 FPGA1988 | wangboworks@126.com All rights reserved----------------
//
//                   --              It to be defined               --
//                   --                    ...                      --
//                   --                    ...                      --
//                   --                    ...                      --
//**************************************************************************************************** 
//File Information
//**************************************************************************************************** 
//File Name      : fpga_top.v 
//Project Name   : project_led
//Description    : the fpga top module.
//VC Address     : https://github.com/FPGA1988/My_FPGA/Tutorial/FPGA_Tutorial_Junior/project_led
//License        : MIT
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 2019-05-29 15:50
//First Author   : FPGA1988
//Last Modify    : 2019-05-21916:00
//Last Author    : FPGA1988
//**************************************************************************************************** 
//Change History(latest change first)
//yyyy.mm.dd - Author - Your log of change
//**************************************************************************************************** 
//2019.05.29 - FPGA1988 - The first version : add io and module structure.
//----------------------------------------------------------------------------------------------------
//`timescale 1ns/1ps
module fpga_top(
    //1.clock and reset interface
    input   wire                fpga_clk            ,//fpga clock signal,100MHz
    input   wire                fpga_reset          ,//fpga reset signal,High active
    //2.Button and switch
    input   wire                mgtclk_p            ,//Differential +ve of reference clock for MGT: 125MHz; very high quality.
    input   wire                mgtclk_n            ,//Differential -ve of reference clock for MGT: 125MHz; very high quality.                   
    input   wire                rxp                 ,//Differential +ve of serial transmission from PMA to PMD.
    input   wire                rxn                 ,//Differential -ve of serial transmission from PMA to PMD.
    //3.LED
    output  wire                mii_tx_clk           
    `endif
    //3.led interface
    //input   wire                led_sw              ,//the led output control
    //output  wire    [03:00]     ledr                ,//the red led
    //output  wire    [07:00]     ledg                 //the green led
);

    
    // ************************************************************************************
    // 1.parameter and constant definition
    // ************************************************************************************

    //`define DEBUG 1
    //`define POR_CONFIG_EN
    //`define METAL_DEVICE_ADDRESS_EN
    //`define METAL_SWP_EN
    //`define METAL_WBUSY_DLY_EN
    

    // ------------------------------------------------------------------------------------
    // 1.2 The EEPROM Feature Define
    // ------------------------------------------------------------------------------------      
    //
    //`define EE_TR7_EN   0

    parameter   EE_ADDR_WIDTH       = 15                            ;
    parameter   MAIN_ADDR_WIDTH     = EE_ADDR_WIDTH                 ;
    parameter   MAIN_BYTE_SIZE      = 2**MAIN_ADDR_WIDTH            ;
    parameter   PAGE_ADDR_WIDTH     = 6                             ; 
    parameter   PAGE_SIZE           = 2**PAGE_ADDR_WIDTH            ;
    parameter   WL_ADDR_WIDTH       = 8                             ;
    parameter   EE_WL_NUM           = 2**WL_ADDR_WIDTH              ;
    parameter   EE_WL_BYTE          = PAGE_SIZE*2                   ;
    parameter   MAX_EVEN_WL         = EE_WL_NUM - 2                 ;
    parameter   MAX_ODD_WL          = EE_WL_NUM - 1                 ;
    parameter   EE_BIT_WIDTH        = 3                             ;
    parameter   EE_BYTE_WIDTH       = 2**EE_BIT_WIDTH               ;
    parameter   MAIN_BIT_SIZE       = MAIN_BYTE_SIZE*EE_BYTE_WIDTH  ;
    parameter   DATA_IN_WIDTH       = 8                             ;
    parameter   DATA_OUT_WIDTH      = 1                             ;
    parameter   EE_OPTION_WIDTH     = 8                             ;
    // ************************************************************************************
    // 2.registers and wire declaration
    // ************************************************************************************
    wire                                sys_led             ;//
    wire                                clk_200mhz          ;

    // ************************************************************************************
    // 3.main code
    // ************************************************************************************
    
    // ------------------------------------------------------------------------------------
    // 3.1 The fpga version number
    // ------------------------------------------------------------------------------------      
    
    assign fpga_version = 8'h07;
    
    // ------------------------------------------------------------------------------------
    // 4.2 The led assignment
    // ------------------------------------------------------------------------------------  
    //sw = on = 0,off = 1
    //sw0 = s7.1
    //led : 0 = on,1=off

    // ------------------------------------------------------------------------------------
    // 4.3 The udp clock and reset
    // ------------------------------------------------------------------------------------ 
    
    assign udp_clk      = user_clk;
    assign udp_reset    = ~por_rst_n;
    assign pc_init_done = 1'b1;


    //assign src_ip_addr = 32'h00_11_22_33;
    //assign dst_ip_addr = 32'h55_66_77_88;
    //assign src_app_port = 16'h1234;
    //assign dst_app_port = 16'h9876;

    //assign src_mac_addr = 48'hac_de_f0_12_34_56;
    // ************************************************************************************
    // 4.sub-module instantiation
    // ************************************************************************************

    // ------------------------------------------------------------------------------------
    // 4.1 The fpga clock and reset module
    // ------------------------------------------------------------------------------------  



    fpga_clk_rst_module fpga_clk_rst_inst(
        .fpga_clk               (fpga_clk           ),//1   In
        .fpga_reset             (fpga_reset         ),//1   In
        .user_clk               (user_clk           ),//1   Out
        .sys_led                (sys_led            ),//1   Out
        .por_rst_n              (por_rst_n          ) //1   Out
    );

    // ------------------------------------------------------------------------------------
    // 4.2 The udp speed test
    // ------------------------------------------------------------------------------------  
    key_debounce_module key_debounce_inst(
        .clk                    (udp_clk                ),      
        .udp_rx_data            (udp_rx_data            ),
        .src_ip_addr            (src_ip_addr            ),
        .dst_ip_addr            (dst_ip_addr            ),
        .src_app_port           (src_app_port           ),
        .dst_app_port           (dst_app_port           ),
        .src_mac_addr           (src_mac_addr           )
    );

    // ------------------------------------------------------------------------------------
    // 5.3 The udp ip stack core
    // ------------------------------------------------------------------------------------ 
    
    led_display_module led_display_inst(
        .clk                	(clk			),      
        .reset			(reset			),
        .led_out		(led_out		) 
    );


endmodule

// ************************************************************************************
// End of Module
// ************************************************************************************
