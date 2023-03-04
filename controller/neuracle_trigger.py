from utils.neuracle_lib import TriggerBox
from PySide6.QtCore import QObject, Slot
import logging


_trigger_box = None

class NeuracleTrigger(QObject):

    @Slot(result='bool')
    def init(self):
        global _trigger_box
        if not _trigger_box:
            try:
                _trigger_box = TriggerBox("COM4")
            except:
                raise RuntimeError(
                    'Cannot init the Neuracle trigger box. may cause by the disconnection to the Neuracle')

    @Slot(str)
    def mark(self, value: str) -> None:
        if _trigger_box:
            _trigger_box.output_event_data(value)
        else:
            logging.warning(
                'Cannot not send event data to Neuracle device. NeuracleTrigger not initialized!')
