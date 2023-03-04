from PySide6.QtCore import QObject, Slot
from utils.audio_recorder import AudioRecorderThread
from pathlib import Path
import vars
import logging

class AudioTester(QObject):
    def __init__(self):
        super().__init__()
        self.question: list = []
        # opennnnnnnnne

    @Slot(result='str')
    def get_questiion(self, index):
        return self.question[index]

    @Slot(str)
    def start_record(self) -> None:
        if self.recorder:
            logging.warning()
            return
        self.recorder = AudioRecorderThread(vars. / output_file)
        self.recorder.start()
        ...

    @Slot()
    def end_record(self) -> None:
        if not self.recorder:
            logging.warning()
            return
        self.recorder.end()


