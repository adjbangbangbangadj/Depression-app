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
        logging.debug(f'Try to send event data {value} to the Neuracle trigger box.')
        if _trigger_box:
            try:
                _trigger_box.output_event_data(value)
            except:
                logging.warning('Cannot init the Neuracle trigger box.')
        else:
            logging.warning('The Neuracle trigger box not connected. Cannot send event data.')
