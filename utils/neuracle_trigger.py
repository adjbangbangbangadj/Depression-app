from utils.neuracle_lib import TriggerBox
import logging


_trigger_box = None

class NeuracleTrigger():
    def __init__(self):
        self.connect()

    def connect(self):
        global _trigger_box
        if not _trigger_box:
            try:
                _trigger_box = TriggerBox("COM4")
            except:
                logging.warning('Cannot init the Neuracle trigger box.')

    def mark(self, value: str) -> None:
        if _trigger_box:
            try:
                _trigger_box.output_event_data(value)
            except:
                logging.warning('Cannot init the Neuracle trigger box.')
        else:
            logging.warning('NeuracleTrigger not connected. Cannot send event data.')
