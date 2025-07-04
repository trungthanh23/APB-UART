/*******************************************************************************
 *    Copyright (C) 2023 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : dti_apb_macros.svh
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_vip
 *    Author      : phuongnd0
 *    Module/Class: dti_apb_macros
 *    Create Date : Sep 11th 2023
 *    Last Update : Sep 11th 2023
 *    Description : macros for apb
 ******************************************************************************
  History:

 ******************************************************************************/

/**
 * This file includes some macros related to APB system,
 * including address bus width and data bus width
 * */

`ifndef APB_ADDR_WIDTH
	`define APB_ADDR_WIDTH 32
`endif

`ifndef APB_DATA_WIDTH
	`define APB_DATA_WIDTH 32
`endif

`ifndef APB_STRB_WIDTH
	`define APB_STRB_WIDTH `APB_DATA_WIDTH/8
`endif
