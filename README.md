# Digital-Safe - Nexys A7-50T

## 👥 Team members 
> [Hynek Svoboda](https://github.com/HynekSvoboda), 
> [Dávid Szalay](https://github.com/Szalo03), 
> [Daniel Vana](https://github.com/DanVanex)

## ⚽ Main goal
Implement a 4-digit code entry system with visual feedback. Store entered codes in registers and compare to the preset combination to indicate success or failure.

## 🚀 Functionality and Features

* **Code Entry:** The system allows entering a 4-digit code. Each position holds a 4-bit value (0–15), which is set primarily using hardware switches.
* **Slot Navigation:** The user can freely move between individual code positions (slots) using buttons and edit them in any order.
* **Real-Time Display:** The currently assembled code is continuously shown on a seven-segment display, including an indication of the position currently being edited.
* **Immediate Evaluation:** The hardware compares the entered code in memory with the secret password on every clock cycle. The status is indicated by colored LEDs.
* **Debouncing:** All mechanical button inputs are debounced, ensuring accurate reading of button presses without unwanted multiple registrations.


## 🗺️ System Schematic
![Digital Safe Schematic](Image/Schematic.png)

## 📟 Hardware Interface

| Signal Name | Direction | Width | Physical Hardware | Description |
|:--- |:---:|:---:|:--- |:--- |
| **clk** | Input | 1 | Onboard 100MHz | Main system clock |
| **btnd** | Input | 1 | BTND (Down) | Confirmation / Save digit |
| **btnl** | Input | 1 | BTNL (Left) | Increment slot index (Move Left) |
| **btnr** | Input | 1 | BTNR (Right) | Decrement slot index (Move Right) |
| **btnu** | Input | 1 | BTNU (Up) | System Reset |
| **sw** | Input | 4 | SW(3:0) | 4-bit binary input for digits |
| **seg** | Output | 7 | 7-Segment Cathodes | Pattern for numbers 0-9 |
| **an** | Output | 4 | 7-Segment Anodes | Active-low display selectors |
| **dp** | Output | 1 | Decimal Point | Cursor indicating active digit |
| **led_g** | Output | 1 | LED16 (Green) | Logic High when safe is OPEN |
| **led_r** | Output | 1 | LED17 (Red) | Logic High when safe is LOCKED |

## 🧪 Testbench & Simulation

A testbench is a crucial simulation environment used to verify the functionality of the digital design before deploying it to the physical FPGA board. The testbench code is never uploaded to the hardware itself; instead, it acts as a virtual laboratory.

**Key purposes of the testbench in this project:**
* **Stimuli Generation:** It artificially generates all necessary input signals, such as the system clock (`clk`) and simulated user interactions (button presses and switch toggles).
* **Logic Verification:** It runs predefined test scenarios to check if the circuit behaves as expected (e.g., verifying the lock states for correct and incorrect password entries).
* **Deep Debugging:** It allows viewing detailed time waveforms of all internal signals, making it much easier to find and fix logic errors without needing the physical development board.

## 🧪 Debounce Testbench

This specific testbench verifies the reliability of the button debouncing logic by simulating real-world mechanical switch behavior. Key test scenarios include:

* **Clean Presses:** Verifies that a normal, stable button press generates exactly one clean output pulse.
* **Overlapping Inputs:** Ensures the logic correctly handles multiple buttons being pressed simultaneously without interference.
* **Mechanical Bouncing:** Simulates rapid, unstable signal fluctuations (switch noise) to confirm the module effectively filters out the noise and prevents false, multiple triggers.
* ![Debounce Test Bench](TestBenches/debounce.png)
