---
title: Adaptive Leaky Integrate-and-Fire Neuron
author: Hanwen Chen
slack_handle: ""
---

## How it works

This project implements a digital Adaptive Leaky Integrate-and-Fire (ALIF) neuron. It receives an 8-bit synaptic input current via the dedicated input pins. The membrane potential integrates this current while constantly leaking (implemented via a hardware-efficient bit-shift). When the membrane potential reaches a dynamic threshold, the neuron fires a spike (sets `uo_out[0]` high) and resets its membrane potential to zero. To model biological adaptation, the threshold increases after every spike and slowly decays back to a base level over time.

## How to test

To test the neuron, apply an active-low reset signal (`rst_n = 0`) and then enable the chip (`ena = 1`). Inject a constant value into the `ui_in` pins to simulate synaptic current. Observe `uo_out[0]` for the generated spikes. You can also monitor `uo_out[7:1]` to see the dynamic threshold value adapting (increasing after spikes and decaying otherwise).

## External hardware

No external hardware is strictly required. A microcontroller or FPGA can be used to drive the input currents and record the spike outputs.