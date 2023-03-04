from neuracle_lib.triggerBox import TriggerBox

_trigger_box = None

def neuracle_api():
    global _trigger_box
    if not _trigger_box:
        _trigger_box = TriggerBox("COM4")
    return _trigger_box


@QmlElement
class NeuracleBridge:
    def __init__(self):
        self.trigger_box = neuracle_api()

    @slot(str)
    def mark(self, value: str) -> None:
        self.trigger_box.output_event_data(value)

