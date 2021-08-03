Minecraft_ComputerCraft
=======================

mc
--

file manager for competer

mcc
---

file manager for color competer

tunnel33
--------

turtle digs a tunnel 3 on 3 blocks, the first parameter - the length of the tunnel

in the first slot to put torches in the second boxes

tunnel55
--------

turtle digs a tunnel 5 on 5 blocks, the first parameter - the length of the tunnel

in the first slot to put torches in the second boxes

dig55
-----

Turtle will dig quarry 5x5 blocks to the desired depth.

use:

dig depth

depth - depth career.

Example: dig 20 - turtle will dig down into 20 blocks.

To work you need to fill bug (programa not check the required level of consumption, so that the throw with a reserve) and put behind her empty chest to unload nakopanogo. Recommended to fill the workplace with water, in order to dig obsidian.

When filling Inventor bug interrupt work, back to the trunk to unload, and then come back and continue to dig from the same place.

Better not indicate depth below adminium, otherwise we will have to descend into the mine for the bug.


light
-----

Illuminator career 

Use: light depth [interval] 

depth - depth career. 

interval - (optional) Set the unit lighting every interval blocks. 

Example: light April 20 - Illuminate the mine at a depth of 20, putting every 3 unit on the fourth, a special unit lighting. 

In slot 1 bug put the basic building blocks for lining (you can not put, but then dug turtle fill mined trash or leave holes). 

Slot 2: If the second parameter (interval) is put here glowing block. This can be a pumpkin-light, light painting unit or conventional torch (although this is less reliable).

tunnel3355
----------

Construction of tunnels 

Turtle digs a tunnel given length of 3x3 block lined or tunnel of circular cross section (without corner blocks) 5x5. 

use: 

tunnel distance [interval] 

distance - length of the tunnel. 

interval - (optional) If this parameter is specified, then the turtle lighting supply unit for every interval blocks. 

To configure first 8 slots: 

Slot # 1: If before starting work in this slot, there are blocks that will bug stoning these blocks left wall. 

Slot # 2: Similar, but for the right wall. 

Slot # 3: Similarly, for the ceiling. 

Slot # 4: Similarly, for flor. 

If the second parameter (interval): 

Slot # 5: If you are in this slot blocks, then every interval blocks, install bug in the center of the left wall, a block from the slot. Typically, this lighting unit. 

Slot # 6: Similarly, for the right wall. 

Slot # 7: Similarly, for the ceiling. 

Slot # 8: Similarly, for flor. 


Example 1: tunnel 20 - turtle will dig a tunnel 20 dyne blocks. 

Example 2: tunnel April 20 - turtle will dig a tunnel dyne 20 blocks, each block will be the fourth illumination unit (slot 5-8). 

Should stand behind the turtle chest in which it unloads all the blocks from the inventory at the end of work. 

If you are building a lined tunnel, it is not recommended to specify the length of more than 21 block. 21 * 3 = 63 -> almost stack, more in the slot will not fit. If you're out casing blocks, the turtle will coat the mined waste. 

At overflow inventory bug back and unload the excess in the chest, and then continue to work. Blocks reserved for lining / lighting will not be unloaded (only at the end of the work). 

During the construction of underwater and lava liquid will penetrate the distal end of the tunnel. To avoid this, before the start of the program in slot # 9 need to put 9 pcs. blocks. Of these bug build plug at the end of the tunnel.
