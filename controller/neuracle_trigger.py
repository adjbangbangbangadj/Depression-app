from utils.neuracle_lib import TriggerBox
from PySide6.QtCore import QObject, Slot
import logging


class NeuracleTrigger(QObject):
    _trigger_box = None

    @Slot(result='bool')
    def init(self):
        if not NeuracleTrigger._trigger_box:
            try:
                NeuracleTrigger._trigger_box = TriggerBox("COM4")
            except:
                raise RuntimeError(
                    'Cannot init the Neuracle trigger box. may cause by the disconnection to the Neuracle')

    @Slot(str)
    def mark(self, value: str) -> None:
        if NeuracleTrigger._trigger_box:
            NeuracleTrigger._trigger_box.output_event_data(value)
        else:
            logging.warning(
                'Cannot not send event data to Neuracle device. NeuracleTrigger not initialized!')
