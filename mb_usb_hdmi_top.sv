//-------------------------------------------------------------------------
//    mb_usb_hdmi_top.sv                                                 --
//    Zuofu Cheng                                                        --
//    2-29-24                                                            --
//                                                                       --
//                                                                       --
//    Spring 2024 Distribution                                           --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module mb_usb_hdmi_top(
    input logic Clk,
    input logic reset_rtl_0,
    
    //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,
        
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB,
     //audio
    output logic [1:0] pwm_out,
    input logic sw_i
    
   
);
    
    logic [31:0] keycode0_gpio, keycode1_gpio;
    logic clk_25MHz, clk_125MHz, clk, clk_100MHz, audio_clock;
    logic locked;
    logic [9:0] drawX, drawY, ballxsig, ballysig, ballsizesig;
    logic [9:0] firexsig, fireysig, firesizesig;

    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    
    logic [3:0] red_img, green_img, blue_img;
    logic [3:0] red_back, green_back, blue_back;
    logic [3:0] red_fire, green_fire, blue_fire;
    
    logic [7:0] key1, key2, key3, key4, keywater, keyfire;
    logic [7:0] keywater1, keywater2, keywater3, keywater4; //NEW
    
    logic [9:0] fireLeft, fireRight, fireTop, fireBottom; //NEW
	logic [9:0] waterLeft, waterRight, waterTop, waterBottom; //NEW
	
	logic [2:0] fLeft, fRight, fTop, fBottom; //NEW
    logic [2:0] wLeft, wRight, wTop, wBottom; //NEW
    
    logic [10:0] font_rom_addr;
    logic [10:0] font_rom_addr2;
    logic [10:0] font_rom_addr3;
    logic [10:0] font_rom_addr4;
    logic [3:0] update_timer; 
    logic [3:0] update_tens;
    logic [3:0] update_minutes;
    logic [6:0] counter;
    logic [7:0] font_rom_data;
    logic [7:0] font_rom_data2;
    logic [7:0] font_rom_data3;
    logic [7:0] font_rom_data4;
    logic [3:0] Red_timer, Green_timer, Blue_timer;
    logic [3:0] Red_timer2, Green_timer2, Blue_timer2;
    logic [3:0] Red_timer3, Green_timer3, Blue_timer3;
    logic [3:0] Red_timer4, Green_timer4, Blue_timer4;
    logic [2:0] rom_c; 
    logic [9:0] timerx;
    logic [9:0] timery;
//    logic [9:0] timerx;
    logic [9:0] timerx2;
//    logic [9:0] timerx;
    logic [9:0] timery2;
    logic [9:0] timerx3;
    logic [9:0] timery3;
    logic [9:0] timerx4;
    logic [9:0] timery4;
    logic [18:0] rom_address_c;
    
    //sprites
    logic [3:0] Red_rd, Green_rd, Blue_rd;
    logic [3:0] Red_rd2, Green_rd2, Blue_rd2;
    logic [3:0] Red_rd3, Green_rd3, Blue_rd3;
    logic [3:0] Red_bd, Green_bd, Blue_bd;
    logic [3:0] Red_bd2, Green_bd2, Blue_bd2;
    logic [3:0] Red_bd3, Green_bd3, Blue_bd3;
    logic [3:0] Red_button, Green_button, Blue_button;
    logic [3:0] Red_lever, Green_lever, Blue_lever;
    logic [3:0] Red_rod1, Green_rod1, Blue_rod1;
    logic [3:0] Red_rod2, Green_rod2, Blue_rod2;
    logic [3:0] Red_start, Blue_start, Green_start;
    logic [3:0] Red_end, Blue_end, Green_end;
    logic [1:0] animation_frame;
    logic [1:0] wanimation_frame;
    logic lever_flipped;
    logic button_pressed; 
    logic time_out;
    assign reset_ah = reset_rtl_0;
    logic  fright_moving;
    logic  fleft_moving;
    logic  wright_moving;
    logic  wleft_moving;
    logic game_won;
    logic game_lost;
 
 //-------------------------------------sound-------------------
 
  logic [1:0] pwm_out_bgm;
  logic [1:0] pwm_out_no;
  logic [1:0] pwm_out_yay;
 
 always_comb begin
    pwm_out = pwm_out_bgm;
    
    if(sw_i == 1'b1) begin
        pwm_out = 2'b00;
      end
    else if(game_won == 1'b1) begin
            pwm_out = pwm_out_yay;
        end
    else if((game_lost == 1'b1)||(fTop == 1'b0) ||(wTop == 1'b0) )
         begin
            pwm_out = pwm_out_no;
         end
    else begin
        pwm_out = pwm_out_bgm;
    end
 
 end
 
 
 top_audio_playback top_audio_playback (
    .clk_in(audio_clock), 
    .reset_btn(reset_rtl_0),
    
    
    .pwm_out(pwm_out_bgm) 
);
audio_no_top audio_no_top (
    .clk_in(audio_clock), 
    .reset_btn(reset_rtl_0),

    .pwm_out(pwm_out_no) 
);
 audio_yay audio_yay (
    .clk_in(audio_clock), 
    .reset_btn(reset_rtl_0),
    .pwm_out(pwm_out_yay) 
);

 //-----------------------------------sound end ---------------   
    
    
    //Keycode HEX drivers
    hex_driver HexA (
        .clk(Clk),
        .reset(reset_ah),
        .in({fTop[2:0], fireysig[9:8], fireysig[7:4], fireysig[3:0]}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );
    
    hex_driver HexB (
        .clk(Clk),
        .reset(reset_ah),
        .in({0, firexsig[9:8], firexsig[7:4], firexsig[3:0]}),
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)
    );
    
    mb_block mb_block_i (
        .clk_100MHz(Clk),
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(~reset_ah), //Block designs expect active low reset, all other modules are active high
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
    );
        
    //clock wizard configured with a 1x and 5x clock for HDMI
    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
        .clk_out2(clk_125MHz),
        .clk_out3(audio_clock),
        .reset(reset_ah),
        .locked(locked),
        .clk_in1(Clk)
    );
    
    //VGA Sync signal generator
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_ah),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );    

    //Real Digital VGA to HDMI converter
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        //Reset is active LOW
        .rst(reset_ah),
        //Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        
        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        
        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );
    
    //assign keycodes so MSB is checked first since they get shifted up
    assign key1 = keycode0_gpio[31:24];
    assign key2 = keycode0_gpio[23:16];
    assign key3 = keycode0_gpio[15:8];
    assign key4 = keycode0_gpio[7:0];
    
    always_comb begin
    
        keyfire = 8'h0;
        keywater = 8'h0;
        
        //for watergirl
        // NEW changed
        if(key1 == 8'h1A || key1 == 8'h16 || key1 == 8'h04 || key1 == 8'h07) 
            keywater = key1;
        else if(key2 == 8'h1A || key2 == 8'h16 || key2 == 8'h04 || key2 == 8'h07)
            keywater = key2;
        else if(key3 == 8'h1A || key3 == 8'h16 || key3 == 8'h04 || key3 == 8'h07)
            keywater = key3;
        else if(key4 == 8'h1A || key4 == 8'h16 || key4 == 8'h04 || key4 == 8'h07)
            keywater = key4;
        
        
        //for fireboy    NEW change
        if(key1 == 8'h52 || key1 == 8'h51 || key1 == 8'h50 || key1 == 8'h4f) 
            keyfire = key1;
        else if(key2 == 8'h52 || key2 == 8'h51 || key2 == 8'h50 || key2 == 8'h4f)
            keyfire = key2;
        else if(key3 == 8'h52 || key3 == 8'h51 || key3 == 8'h50 || key3 == 8'h4f)
            keyfire = key3;
        else if(key4 == 8'h52 || key4 == 8'h51 || key4 == 8'h50 || key4 == 8'h4f)
            keyfire = key4;
     end
    
    //Ball Module
    ball ball_instance(
        .Reset(reset_ah),
        .frame_clk(vsync),                    //Figure out what this should be so that the ball will move
        .keycode(keywater),    //Notice: only one keycode connected to ball by default
        .BallX(ballxsig),
        .BallY(ballysig),
        .BallS(ballsizesig),
        .BallL(waterLeft), 
        .BallR(waterRight), 
        .BallT(waterTop), 
        .BallB(waterBottom),
        .wLeft(wLeft),
        .wRight(wRight),
        .wTop(wTop),
        .wBottom(wBottom),
        .lever_flipped(lever_flipped),
        .button_pressed(button_pressed),
        .animation_frame(wanimation_frame),
        .right_moving(wright_moving),
        .left_moving(wleft_moving)
        
    );
    
    fire fire_instance(
        .Reset(reset_ah),
        .frame_clk(vsync),                    
        .keycode(keyfire),
        .BallX(firexsig),
        .BallY(fireysig),
        .BallS(firesizesig),
        .BallL(fireLeft), 
        .BallR(fireRight), 
        .BallT(fireTop), 
        .BallB(fireBottom),
        .fLeft(fLeft),
        .fRight(fRight),
        .fTop(fTop),
        .fBottom(fBottom),
        .lever_flipped(lever_flipped),
        .button_pressed(button_pressed),
        .animation_frame(animation_frame),
        .right_moving(fright_moving),
        .left_moving(fleft_moving)
    );
    
    //Color Mapper Module   
    color_mapper color_instance(
        .BallX(ballxsig),
        .BallY(ballysig),
        .DrawX(drawX),
        .DrawY(drawY),
        .Ball_size(ballsizesig),
        .FireX(firexsig),
        .FireY(fireysig),
        .Fire_size(firesizesig),
        .Red_img(red_img),
        .Green_img(green_img),
        .Blue_img(blue_img),
        .Red_back(red_back),
        .Green_back(green_back),
        .Blue_back(blue_back),
        .Red_fire(red_fire),
        .Green_fire(green_fire),
        .Blue_fire(blue_fire),
        .Red(red),
        .Green(green),
        .Blue(blue),
        .Red_timer(Red_timer),
        .Green_timer(Green_timer),
        .Blue_timer(Blue_timer),
        .timerX(timerx),
        .timerY(timery),
        .Red_timer2(Red_timer2),
        .Green_timer2(Green_timer2),
        .Blue_timer2(Blue_timer2),
        .timerX2(timerx2),
        .timerY2(timery2),
        .Red_timer3(Red_timer3),
        .Green_timer3(Green_timer3),
        .Blue_timer3(Blue_timer3),
        .timerX3(timerx3),
        .timerY3(timery3),
        .Red_timer4(Red_timer4),
        .Green_timer4(Green_timer4),
        .Blue_timer4(Blue_timer4),
        .timerX4(timerx4),
        .timerY4(timery4),
        .Red_rd(Red_rd),
        .Green_rd(Green_rd),
        .Blue_rd(Blue_rd),
        .Red_rd2(Red_rd2),
        .Green_rd2(Green_rd2),
        .Blue_rd2(Blue_rd2),
        .Red_rd3(Red_rd3),
        .Green_rd3(Green_rd3),
        .Blue_rd3(Blue_rd3),
        .Red_bd(Red_bd), 
        .Green_bd(Green_bd), 
        .Blue_bd(Blue_bd),  
        .Red_bd2(Red_bd2), 
        .Green_bd2(Green_bd2), 
        .Blue_bd2(Blue_bd2),
        .Red_bd3(Red_bd3), 
        .Green_bd3(Green_bd3), 
        .Blue_bd3(Blue_bd3),               
        .Red_button(Red_button), .Green_button(Green_button), .Blue_button(Blue_button),
        .Red_lever(Red_lever), .Green_lever(Green_lever), .Blue_lever(Blue_lever),
        .Red_rod1(Red_rod1), .Green_rod1(Green_rod1), .Blue_rod1(Blue_rod1),
        .Red_rod2(Red_rod2), .Green_rod2(Green_rod2), .Blue_rod2(Blue_rod2),
        .Red_start(Red_start), .Green_start(Green_start), .Blue_start(Blue_start),
        .Red_end(Red_end), .Green_end(Green_end), .Blue_end(Blue_end),
        .vsync(vsync),
        .reset(reset_ah),
        .lever_flipped(lever_flipped),
        .keycode(key4),
        .button_pressed(button_pressed),  
        .time_out(time_out),
        .game_started(game_started),
        .game_won(game_won),
        .game_lost(game_lost)
    );

//    butterfly_example butterfly_example(
//        .vga_clk(clk_25MHz),
//        .DrawX(drawX),
//        .DrawY(drawY),
//        .blank(vde),
//        .red(red),
//        .green(green),
//        .blue(blue)    
//    );

red_diamond_example red_diamond_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .x_d(10'd338),
        .y_d(10'd424),
        .blank(vde),
        .red(Red_rd),
        .green(Green_rd),
        .blue(Blue_rd)    
    );
    
    red_diamond_example red_diamond_example_2(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .x_d(10'd176),
        .y_d(10'd224),
        .blank(vde),
        .red(Red_rd2),
        .green(Green_rd2),
        .blue(Blue_rd2)    
    );
    
    red_diamond_example red_diamond_example_3(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .x_d(10'd53),
        .y_d(10'd71),
        .blank(vde),
        .red(Red_rd3),
        .green(Green_rd3),
        .blue(Blue_rd3)    
    );
 
 blue_diamond_example blue_diamond_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .x_d(10'd470),
        .y_d(10'd424),
        .blank(vde),
        .red(Red_bd),
        .green(Green_bd),
        .blue(Blue_bd)    
    );
    
    blue_diamond_example blue_diamond_example2(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .x_d(10'd518),
        .y_d(10'd160),
        .blank(vde),
        .red(Red_bd2),
        .green(Green_bd2),
        .blue(Blue_bd2)    
    );
    
       blue_diamond_example blue_diamond_example3(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .x_d(10'd320),
        .y_d(10'd92),
        .blank(vde),
        .red(Red_bd3),
        .green(Green_bd3),
        .blue(Blue_bd3)    
    );
    

button_example button_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        .red(Red_button),
        .green(Green_button),
        .blue(Blue_button)    
    );

lever_off_example lever_off_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        .red(Red_lever),
        .green(Green_lever),
        .blue(Blue_lever), 
        .lever_flipped(lever_flipped)   
    );
 
 rod1_example rod1_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        .red(Red_rod1),
        .green(Green_rod1),
        .blue(Blue_rod1)    
    );
    
    
  rod2_example rod2_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        .red(Red_rod2),
        .green(Green_rod2),
        .blue(Blue_rod2)    
    );

start_screen_endgame_example start_screen_endgame_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        .red(Red_start),
        .green(Green_start),
        .blue(Blue_start)    
    );
    
  end_screen_half_example  end_screen_half_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        .red(Red_end),
        .green(Green_end),
        .blue(Blue_end)    
    );
dl_girl_example dl_girl_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        .BallX(ballxsig),
        .BallY(ballysig),   
        .red(red_img),
        .green(green_img),
        .blue(blue_img),
        .animation_frame(wanimation_frame),
        .right_moving(wright_moving),
        .left_moving(wleft_moving)    
    );
    
     zuofu_cheng_example  zuofu_cheng_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        .FireX(firexsig),
        .FireY(fireysig),       
        .red(red_fire),
        .green(green_fire),
        .blue(blue_fire),
        .animation_frame(animation_frame),
        .right_moving(fright_moving),
        .left_moving(fleft_moving)
            
    );
    
//   fireboy_watergirl_final_example fireboy_watergirl_final_example(
//	.vga_clk(clk_25MHz),
//	.DrawX(drawX), 
//	.DrawY(drawY),
//	.blank(vde),
//	.FireX(firexsig), 
//	.FireY(fireysig),
//	.BallX(ballxsig), 
//	.BallY(ballysig),
//	.red(red_fire), 
//	.green(green_fire), 
//	.blue(blue_fire),
//	.red_g(red_img), 
//	.green_g(green_img), 
//	.blue_g(blue_img)
//);
    
//    background_example background_example(
//        .vga_clk(clk_25MHz),
//        .DrawX(drawX),
//        .DrawY(drawY),
//        .blank(vde),
////        .red(red),
////        .green(green),
////        .blue(blue)
        
//        .red(red_back),
//        .green(green_back),
//        .blue(blue_back)    
//    );

//backnew_example backnew_example(
//        .vga_clk(clk_25MHz),
//        .DrawX(drawX),
//        .DrawY(drawY),
//        .blank(vde),
////        .red(red),
////        .green(green),
////        .blue(blue)
        
//        .red(red_back),
//        .green(green_back),
//        .blue(blue_back)    
//    );

 background_notext_example  background_notext_example(
        .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        .red(red_back),
        .green(green_back),
        .blue(blue_back)
    );

collision_endgame_example collision_endgame_example(
	    .vga_clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .blank(vde),
        .fireLeft(fireLeft), 
        .fireRight(fireRight), 
        .fireTop(fireTop), 
        .fireBottom(fireBottom),
        .waterLeft(waterLeft), 
        .waterRight(waterRight), 
        .waterTop(waterTop), 
        .waterBottom(waterBottom),
        .fLeft(fLeft),
        .fRight(fRight),
        .fTop(fTop),
        .fBottom(fBottom),
        .wLeft(wLeft),
        .wRight(wRight),
        .wTop(wTop),
        .wBottom(wBottom),
        .rom_c(rom_c),
        .rom_address_c(rom_address_c)
);


 // ----------- timer ------------------------
 
 
// logic [10:0] font_rom_addr;
// logic [3:0] update_timer; 
// logic [6:0] counter;
// logic [7:0] font_rom_data;
// logic [3:0] Red_timer, Green_timer, Blue_timer;
 
 font_rom font_rom_instance(
        .addr(font_rom_addr),
        .data(font_rom_data)
 );
 font_rom font_rom_instance2(
        .addr(font_rom_addr2),
        .data(font_rom_data2)
 );
  font_rom font_rom_instance3(
        .addr(font_rom_addr3),
        .data(font_rom_data3)
 );
   font_rom font_rom_instance4(
        .addr(font_rom_addr4),
        .data(font_rom_data4)
 );
 
 
 always_ff @ ( posedge vsync)     // 60 times per sec
    begin
        if(reset_ah ==1'b1)
            begin
                counter <= 60; // 61 for safety
                update_timer <= 0;
                update_tens <= 0;
                update_minutes <=0;
                time_out <= 0;
            end
         else if(counter == 0)
            begin
                counter <= 60; 
                if(update_timer == 9)
                    begin
                        update_timer <= 0; 
                        if(update_tens == 5)
                            begin
                                update_tens <= 0;
                                if(update_minutes == 4)
                                    begin
                                        update_minutes <= 0;
                                        time_out <= 1;
                                    end
                                 else
                                    begin
                                        update_minutes <= update_minutes + 1;
                                    end
                            end
                        else
                            begin
                                update_tens = update_tens + 1;
                            end
                    end 
                else 
                    begin
                        update_timer <= update_timer + 1 ;
                     end 
            end
         else
            begin
                counter <= counter - 1; 
            end
    end
    
logic [9:0] temp;
logic [9:0] temp_x;
assign temp = (drawY - timery);
assign temp_x = (drawX - timerx); 
assign timerx = 12'h147;   // send this to color mapper as well 
assign timery = 12'ha;  // top center    a
assign font_rom_addr[10:4] = (7'h30 + update_timer) ; // code for 0 
assign font_rom_addr[3:0] = temp[3:0] ; 

always_comb
  begin  
  if(font_rom_data[7- temp_x[2:0]] == 1'b1)
            begin
   
               Red_timer = 4'hf; // white
               Green_timer = 4'hf; 
                Blue_timer = 4'hf;
            end
    else
        begin
                Red_timer = 4'h0; // black
               Green_timer = 4'h0; 
                Blue_timer = 4'h0;
        end
  end
logic [9:0] temp2;
logic [9:0] temp_x2;
assign temp2 = (drawY - timery2);
assign temp_x2 = (drawX - timerx2); 
assign timerx2 = 12'h140;   // send this to color mapper as well 
assign timery2 = 12'ha;  // top center    a
assign font_rom_addr2[10:4] = (7'h30 + update_tens) ; // code for 0 
assign font_rom_addr2[3:0] = temp2[3:0] ; 

always_comb
  begin  
  if(font_rom_data2[7- temp_x2[2:0]] == 1'b1)
            begin
   
               Red_timer2 = 4'hf; // white
               Green_timer2 = 4'hf; 
                Blue_timer2 = 4'hf;
            end
    else
        begin
                Red_timer2 = 4'h0; // black
               Green_timer2 = 4'h0; 
                Blue_timer2 = 4'h0;
        end
  end
logic [9:0] temp3;
logic [9:0] temp_x3;
assign temp3 = (drawY - timery3);
assign temp_x3 = (drawX - timerx3); 
assign timerx3 = 12'h132;   // send this to color mapper as well 
assign timery3 = 12'ha;  // top center    a
assign font_rom_addr3[10:4] = (7'h30 + update_minutes) ; // code for 0 
assign font_rom_addr3[3:0] = temp3[3:0] ; 

always_comb
  begin  
  if(font_rom_data3[7- temp_x3[2:0]] == 1'b1)
            begin
   
               Red_timer3 = 4'hf; // white
               Green_timer3 = 4'hf; 
                Blue_timer3 = 4'hf;
            end
    else
        begin
                Red_timer3 = 4'h0; // black
               Green_timer3 = 4'h0; 
                Blue_timer3 = 4'h0;
        end
  end

logic [9:0] temp4;
logic [9:0] temp_x4;
assign temp4 = (drawY - timery4);
assign temp_x4 = (drawX - timerx4); 
assign timerx4 = 12'h139;   // send this to color mapper as well 
assign timery4 = 12'ha;  // top center    a
assign font_rom_addr4[10:4] = (7'h3a) ; // code for 0 
assign font_rom_addr4[3:0] = temp4[3:0] ; 

always_comb
  begin  
  if(font_rom_data4[7- temp_x4[2:0]] == 1'b1)
            begin
   
               Red_timer4 = 4'hf; // white
               Green_timer4 = 4'hf; 
                Blue_timer4 = 4'hf;
            end
    else
        begin
                Red_timer4 = 4'h0; // black
               Green_timer4 = 4'h0; 
                Blue_timer4 = 4'h0;
        end
  end
 // rom_address = (DrawX - (timerx - 13)) + (DrawY - (timery - 13)) * 25  // 25 by 25
 


 
 
endmodule
