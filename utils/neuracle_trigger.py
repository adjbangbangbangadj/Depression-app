from utils.neuracle_lib import TriggerBox
import logging


_trigger_box = None

class NeuracleTrigger():
    def __init__(self):
        self.connect()

    def connect(self)-> bool:
        global _trigger_box
        if not _trigger_box:
            try:
                _trigger_box = TriggerBox("COM4")
                return True
            except:
                logging.warning('Cannot init the Neuracle trigger box.')
                return False

    def mark(self, value: int) -> bool:
        logging.debug(f'Try to send event data {value} to the Neuracle trigger box.')
        if _trigger_box:
            return self._mark(value)
        else:
            logging.warning("the Neuracle trigger box didn't init correctly. retry to init.")
            if self.connect():
                return self._mark(value)
            else:
                return False

    def _mark(self, value) -> bool:
        try:
            _trigger_box.output_event_data(value)
            return True
        except:
            logging.warning(f'Cannot send the Neuracle trigger box. Event_data: {value}.')
            return False
