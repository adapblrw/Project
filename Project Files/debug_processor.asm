# ------------------------------------------------------------------------------
# Program debug_processor.asm
# This program performs some simple tests of the processor reading from and
# writing to the data bus.
#
# Required instructions:
# load, store, and, add, shr, bz, jump
#
# Note: SW0 is the reset switch.
#
# Expected functionality (# == LED on, . == LED off, + == LED blinking):
# After reset, LEDs 0 to 7 are turned on:
#   ########
#
# Pushing the rotary encoder knob lets LED0 and LED7 blink with 1Hz and turns
# LEDs 1,2,5 and 6 off again:
#   ########
# <push>
#   +..##..+
#
# Pushing the knob again turns LED0 and LED7 off again (pushing toggles blinking
# of LED 0 and 7):
#   +..##..+
# <push>
#   ...##...
# <push>
#   +..##..+
# <push>
#   ...##...
#
# Turning the knob will move the bar (LEDs 3 and 4 are on) accross LEDs 1 to 6
# and wrap around on the borders.
#   ...##...
# <turnLeft>
#   ..##....
# <turnLeft>
#   .##.....
# <push>
#   +##....+
# <turnLeft>
#   +#....#+
# <turnLeft>
#   +....##+
# <turnLeft>
#   +...##.+
# <turnRight>
#   +....##+
# <turnRight>
#   +#....#+
# <turnRight>
#   +##....+
# <turnRight>
#   +.##...+
# <turnRight>
#   +..##..+
# <turnRight>
#   +...##.+
# <turnRight>
#   +....##+
#
# Hints for debugging:
# - All LEDs stay off:
#		Did the configuration download work? Then check the led connections from
#		the debug_module to the toplevel.
# - LEDs show pattern "10101010":
#		Check reset polarity, the clock signal, IO- and bus-connections. The
#		first two instructions (load+store) might also be the cause of the
#		problem.
# - All LEDs stay on:
#   	The load/store instructions seems to work, but one of the others
#		doesn't. Try to figure out which instruction fails by using some
#		additional stores for writing different values to the LEDs.
#
# You can extend this program to test your peripherials and other instructions,
# once it works as expected.
# ------------------------------------------------------------------------------

.section  .data

.section  .text

_start:   .global _start

          .global init
          .type init, @function
# -----------------------------------------------------
# initialization
# -----------------------------------------------------

init:
    # turn on all leds
    load    maskLEDs
    store   debugAddr
initloop:
    # poll the knob button
    load    debugAddr
    and     maskRotEvent
    bz      initloop # knob not pushed or rotated
    # knob pushed or rotated
    load    maskBlinkLEDs
    store   varBlinkLEDs
    add     varLEDs
    store   debugAddr
    jump    mainloop

# -----------------------------------------------------
# main loop
# -----------------------------------------------------

mainloop:
    # read debug register
    load    debugAddr
    store   varEvents
checkRotPush:
    # check if the rotary encoder knob was pushed
    and     bitRotPush
    bz      checkRotLeft # RotPush bit not present
    # knob was pushed, toggle BlinkLED bits
toggleBitsFast:
    # two possible start conditions:  case1 (enabled),  case2 (disabled)
    load    varBlinkLEDs            # 0x8100            0x0000
    add     maskBlinkLEDs           # 0x0200 (+OV)      0x8100
    and     maskBlinkLEDs           # 0x0000 (disab.),  0x8100 (enabled)
    store   varBlinkLEDs
    jump    writeLEDs # update debug register
checkRotLeft:
    load    varEvents
    and     bitRotLeft
    bz      checkRotRight # RotLeft bit not present
    # knob rotated to the left, shift bar left one bit
    load    varLEDs
    add     varLEDs
    store   varLEDs
    and     maskLEDBarOV
    bz      writeLEDs # no overflow, update debug register
    # overflow detected, remove highest bit and push it in on the right side
    load    varLEDs
    and     maskLEDBar
    add     bitLEDBarLow
    store   varLEDs
    jump    writeLEDs # update debug register
checkRotRight:
    load    varEvents
    and     bitRotRight
    bz      mainloop # RotRight bit not present
    # knob rotated to the right, shift bar right by one bit
    load    varLEDs
    shr
    store   varLEDs
    and     maskLEDBarUN
    bz      writeLEDs # no underflow, update debug register
    # underflow detected, remove lowest bit and push it in on the left side
    load    varLEDs
    and     maskLEDBar
    add     bitLEDBarHigh
    store   varLEDs
#    jump    writeLEDs
writeLEDs:
    # update debug register with new values for
    load    varBlinkLEDs
    add     varLEDs
    store   debugAddr
    jump    mainloop


# ------------------------------------------------------------------------------
# constants
# ------------------------------------------------------------------------------
.set    debugAddr,  0x0FFF << 1 # bus address (12 bit) of the debug_module.vhd

maskRotEvent:   .word   0xE000  # mask either rotary knob event
bitRotPush:     .word   0x8000  # rotary knob pushed
bitRotLeft:     .word   0x4000  # rotary knob turned left
bitRotRight:    .word   0x2000  # rotary knob turned right

# LED masks, high byte is blink_enable, low byte is for direct LED access as
# long as blink_enable for the particular LEDs is not set
maskBlinkLEDs:  .word   0x8100  # mask for LEDs which are turned into blinking
                                # mode on a rotary knob push, set bits have to
                                # be non-adjacient for the fast-toggle trick to
                                # work (see toggleBitsFast label)
maskLEDs:       .word   0x00FF  # mask for directly switching leds on and off
maskLEDBar:     .word   0x007E  # mask for LEDs which are part of the moving bar

# constants used for over/under-flow handling of the moving bar
maskLEDBarUN:   .word   0x0001  # underflow
bitLEDBarLow:   .word   0x0002  # lowest bit of the bar
bitLEDBarHigh:  .word   0x0040  # highest bit of the bar
maskLEDBarOV:   .word   0x0080  # overflow


# ------------------------------------------------------------------------------
# variables
# ------------------------------------------------------------------------------
varBlinkLEDs:   .word   0x0000  # LEDs that are currently blinking
                                # (either 0x8100 or 0x0000)
varLEDs:        .word   0x0018  # initial LED value defining the bar
varEvents:      .word   0x0000  # temporary storage of the pushed buttons/events

