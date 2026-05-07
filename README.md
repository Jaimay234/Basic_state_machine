# Collatz Collation State Machine
#### Disclaimer & Description
This was a project that needed to be done for a VHDL progrmaming class. It is a very simple state machine that will cycle through a couple of states and then it will store the value and stop after a while.
## Overview
This is a basic implementation of a state machine in VHDL. It follows the Collatz conjecture, depending on if the number is even or odd it will either have 3n+1 or n/2 for even and odd respectively. This was performed and simulated on a xilinx FPGA board and then demonstrated. Each operation has a simple instruction or state wether to compare or to store or to multiply and add or divide. The system will run until it hits the first one to stop after 9 individual iteraations.

