// Test Program for CO224 Lab 5


// Initializing 20 variables in memory as an array

loadi 0 X 0xFF
store 0x1A X 0

loadi 0 X 0x56
store 0x1B X 0

loadi 0 X 0xFF
store 0x1C X 0

loadi 0 X 0x56
store 0x1D X 0

loadi 0 X 0xFF
store 0x1E X 0

loadi 0 X 0x56
store 0x1F X 0

loadi 0 X 0xFF
store 0x20 X 0

loadi 0 X 0x56
store 0x21 X 0

loadi 0 X 0xFF
store 0x22 X 0

loadi 0 X 0x56
store 0x23 X 0

loadi 0 X 0x56
store 0x24 X 0

loadi 0 X 0x56
store 0x25 X 0

loadi 0 X 0x56
store 0x26 X 0

loadi 0 X 0x56
store 0x27 X 0

loadi 0 X 0x56
store 0x28 X 0

loadi 0 X 0x56
store 0x29 X 0

loadi 0 X 0x56
store 0x2A X 0

loadi 0 X 0x56
store 0x2B X 0

loadi 0 X 0x56
store 0x2C X 0

loadi 0 X 0x56
store 0x2D X 0


// Putting other parameters in registers

loadi 0 X 0x00  // Sum
loadi 2 X 0x12
loadi 3 X 0xFF
loadi 4 X 0x01
loadi 5 X 0xFE

// First loop iteration
load 6 X 0x1A // Load first array element
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x1A X 7 // Write the updated value to the array in memory
add 0 0 7 // Update Sum

// Repeating loop iterations

load 6 X 0x1B
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x1B X 7
add 0 0 7

load 6 X 0x1C
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x1C X 7
add 0 0 7

load 6 X 0x1D
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x1D X 7
add 0 0 7

load 6 X 0x1E
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x1E X 7
add 0 0 7

load 6 X 0x1F
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x1F X 7
add 0 0 7

load 6 X 0x20
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x20 X 7
add 0 0 7

load 6 X 0x21
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x21 X 7
add 0 0 7

load 6 X 0x22
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x22 X 7
add 0 0 7

load 6 X 0x23
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x23 X 7
add 0 0 7

load 6 X 0x24
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x24 X 7
add 0 0 7

load 6 X 0x25
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x25 X 7
add 0 0 7

load 6 X 0x26
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x26 X 7
add 0 0 7


load 6 X 0x27
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x27 X 7
add 0 0 7

load 6 X 0x28
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x28 X 7
add 0 0 7

load 6 X 0x29
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x29 X 7
add 0 0 7

load 6 X 0x2A
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x2A X 7
add 0 0 7

load 6 X 0x2B
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x2B X 7
add 0 0 7

load 6 X 0x2C
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x2C X 7
add 0 0 7

load 6 X 0x2D
add 7 2 6
and 7 5 7
or 7 4 7
sub 7 3 7
store 0x2D X 7
add 0 0 7

store 0xFF X 0  // Write Sum to the memory

// End


