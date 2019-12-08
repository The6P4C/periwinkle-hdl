periwinkle-hdl
==============
Semi-complete Verilog implementation of Ike T. Sanglay Jr.'s "Periwinkle" OISC as described [on their blog](http://ikejr.com/2019/11/23/periwinkle-one-instruction-set-computer/).

Probably full of Verilog/hardware no-nos, and almost completely untested, but it (sorta) works! Too lazy to fix right now :P

## Missing features
- `STK` special-purpose register
- Carry/overflow flags
- Halt with `#1 PC`
- Probably more

## Added features
- "Reserved 0" special-purpose register is now `GPIO`, an 8-bit GPIO interface
