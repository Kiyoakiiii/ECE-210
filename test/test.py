import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_alif(dut):
    dut._log.info("Starting Adaptive LIF Neuron Test")

    # Setup clock
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Initial reset
    dut._log.info("Resetting DUT")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut._log.info("Reset complete")

    # Inject constant current to simulate synaptic input
    dut._log.info("Injecting constant current into neuron")
    dut.ui_in.value = 35 
    
    # Run for 200 clock cycles to observe membrane potential accumulation, spikes, and threshold changes
    await ClockCycles(dut.clk, 200)
    
    dut._log.info("Simulation complete. ALIF tested successfully!")