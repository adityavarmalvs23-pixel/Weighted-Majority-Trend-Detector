import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer

@cocotb.test()
async def trend_detector_test(dut):
    """Cocotb test for Weighted Majority Voter"""

    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    dut.ena.value = 1
    dut.rst_n.value = 1
    await Timer(20, units="ns")
    dut.rst_n.value = 0
    await Timer(20, units="ns")
    dut.rst_n.value = 1

    # Send 0s
    for _ in range(4):
        dut.ui_in.value = 0
        await ClockCycles(dut.clk, 1)

    # Send 1s
    for _ in range(5):
        dut.ui_in.value = 1
        await ClockCycles(dut.clk, 1)

    # Send 0s again
    for _ in range(6):
        dut.ui_in.value = 0
        await ClockCycles(dut.clk, 1)

    # Check final trend
    dut._log.info(f"Final trend: {dut.uo_out.value}")
