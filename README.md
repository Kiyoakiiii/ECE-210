# ECE-210 Brain-Inspired Chip Design: Adaptive Leaky Integrate-and-Fire (ALIF) Neuron

## Project Overview
This project implements a digital neuromorphic circuit based on the Adaptive Leaky Integrate-and-Fire (ALIF) neuron model. It was designed for the ECE-210 chip design assignment. While a standard LIF neuron uses a static threshold for spike generation, this ALIF design introduces biological adaptation: the firing threshold dynamically increases immediately after a spike is emitted and exponentially decays back to a baseline over time. This prevents hyper-excitability and models the biological refractory period and fatigue.

## How it Works
The core logic (`src/project.v`) contains an 8-bit membrane potential register and an 8-bit dynamic threshold register. 
1. **Integration:** The 8-bit input (`ui_in`) represents incoming synaptic current, which is added to the membrane potential every clock cycle.
2. **Leak:** A hardware-efficient right-shift (`membrane_v >> 3`) acts as the leak factor, slowly draining the membrane potential.
3. **Spike Generation:** When the membrane potential exceeds the dynamic threshold, a spike is emitted on `uo_out[0]`.
4. **Adaptation:** Upon spiking, the membrane potential resets to 0, and the threshold increases by a fixed step. If no spike occurs, the threshold slowly leaks back to its base value.

## Pinout
* **Inputs (`ui_in`)**: 8-bit Synaptic Current Input
* **Outputs (`uo_out`)**: 
  * `uo_out[0]`: Spike Output
  * `uo_out[7:1]`: Top 7 bits of the dynamic threshold (for observability)

## Verification
The design includes a cocotb testbench (`test/test.py`) that injects constant current and verifies the membrane potential accumulation, spike firing, and threshold adaptation over 200 clock cycles.