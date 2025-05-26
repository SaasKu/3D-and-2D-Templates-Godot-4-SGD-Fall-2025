extends Node

# The SignalBus is a singleton design pattern that we use
# to organize our signals in our games

# Think of signals as the messages several components of our games
# send to communicate to each other

# To use a signal bus:
# 1) Create a file named SignalBus.gd
# 2) Add it to the globals section under Project/Project settings in the top bar
# 3) Within the node that emits a signal, emit the signal by typing
#    - SignalBus.emit_signal("my_signal", parameter)
#      - The parameters are optional, but if you need to check values, do that
#    - Within the receiving node, in the _ready() function, connect the signal to a function
#    - SignalBus.connect("my_signal", signal_function)


# Menu Signals

# Attack signals
signal enemy_hit(damage, enemy_name)
