
create_clock -name clk -period 11 -waveform {0 5} [get_ports "clk"]
set_clock_transition -rise 0.1 [get_clocks "clk"]
set_clock_transition -fall 0.1 [get_clocks "clk"]
set_clock_uncertainty 0.01 [get_clocks "clk"]

# Input delay for reset signal (assuming active-high reset)
set_input_delay -max 1.0 [get_ports "rst"] -clock [get_clocks "clk"]

# Input delay for operation code
set_input_delay -max 1.0 [get_ports "op"] -clock [get_clocks "clk"]

# Input delays for operands
set_input_delay -max 1.0 [get_ports "operand_a"] -clock [get_clocks "clk"]
set_input_delay -max 1.0 [get_ports "operand_b"] -clock [get_clocks "clk"]

# Output delay for result
set_output_delay -max 1.0 [get_ports "result"] -clock [get_clocks "clk"]

# Output delay for zero flag
set_output_delay -max 1.0 [get_ports "zero"] -clock [get_clocks "clk"]


]
