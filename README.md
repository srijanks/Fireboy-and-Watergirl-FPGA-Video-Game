# Fireboy-and-Watergirl-FPGA-Video-Game
 
### Real-Time Dual-Player Game System on Spartan-7 FPGA with Audio & HDMI Output

A complete hardware/software co-design project implementing the game **Fireboy & Watergirl** on a Spartan-7 FPGA, featuring real-time graphics, dual-player USB keyboard control, collision physics, and PCM audio playback. This game was used for our ECE 385 final project submission.

---

## Project Overview

This project implements a fully interactive **2-player platform game** on a **Spartan-7 FPGA** using a combination of:

- **SystemVerilog hardware design**
- **MicroBlaze soft processor**
- **Real-time VGA - HDMI graphics pipeline**
- **SPI-based USB keyboard interface**
- **BRAM-based PCM audio playback**

Players control Fireboy and Watergirl simultaneously using a USB keyboard, navigate obstacles, activate levers and buttons, collect diamonds, avoid hazardous lava, and race against a 5-minute timer, all rendered at **640×480 @ 60Hz**.

---

## Technical Highlights

### Hardware–Software Co-Design
- **MicroBlaze CPU** handles USB keyboard input via **SPI (MAX3421E USB Host Controller)**
- Keycodes transferred to custom **SystemVerilog game logic** using **memory-mapped I/O**
- Entire system orchestrated using **AXI interconnect**, timers, interrupts, GPIO, and UART

### Real-Time Graphics Engine
- Custom **VGA controller** generates pixel timing & coordinates  
- **Color Mapper** performs per-pixel composition of:
  - Background
  - Sprites
  - UI elements
  - Timer
  - Game states (start, play, win, lose)
- **VGA → HDMI IP** outputs video to external monitor
- Sprite animations, scaling, transparency & layering all done in hardware

### Physics & Collision System
- Independent physics for each player (gravity, jumping, collision constraints)
- Dedicated **collision ROM** for environment detection
- Boundary collision detection for each character side (left/right/top/bottom)
- Lever & button interactions dynamically modify level geometry

### Audio Subsystem
- Audio samples stored in **BRAM** using **8-bit PCM**
- **16 kHz sample clock** generated from 100 MHz FPGA clock
- Custom **PWM audio engine** reconstructs analog audio
- Three sound channels:
  - Background Music
  - Win Sound
  - Loss / Collision Sound
- Hardware mute via FPGA switch

---

## 🎮 Game Features

- Dual-player simultaneous control  
- Multiple game states: **Start → Play → Win/Lose**
- Color-based interaction rules
- Interactive obstacles (levers, buttons, rods)
- Sprite-based animations with multi-frame rendering
- Real-time countdown timer rendered in hardware
- Audio feedback & soundtrack
- HDMI output to external display

---

## 🏗️ System Architecture
-USB Keyboard → MAX3421E → SPI → MicroBlaze
-↓
-Memory-Mapped I/O
-↓
-Character Control + Physics (SystemVerilog)
-↓
-Collision Engine + Sprite Renderer
-↓
-Color Mapper (Per-Pixel)
-↓
-VGA Controller → VGA-to-HDMI → Display

-Audio Samples (BRAM) → PWM Generator → Speaker


---

## Performance & Resource Usage

| Metric | Value |
|------|------|
| Resolution | 640×480 @ 60Hz |
| Max Frequency | 32.2 MHz |
| LUTs | 4,731 |
| Flip-Flops | 3,317 |
| BRAM Usage | 69.5 |
| DSP Blocks | 17 |
| Total Power | 0.507 W |

---

## Technologies & Tools

- SystemVerilog
- Xilinx Vivado
- MicroBlaze
- AXI / SPI / UART
- VGA / HDMI
- BRAM / ROM
- FPGA Audio (PWM DAC)
- Spartan-7 FPGA




