from neuracle_lib.triggerBox import TriggerBox

_trigger_box = None

def mark(index:int):
    _trigger_box.output_event_data(index)

def start():
    global _trigger_box
    _trigger_box = TriggerBox("COM4")
    mark(0)
