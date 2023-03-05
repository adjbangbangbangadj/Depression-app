from PySide6.QtCore import QObject, Slot
from utils.audio_recorder import AudioRecorderThread
from pathlib import Path
from vars import configuration, data_dir
import logging

_question_dir = data_dir / Path ('questions/')

class AudioTester(QObject):
    def __init__(self):
        super().__init__()
        self.question: list = []
        for i in _question_dir.glob('*.txt'):
            ...
        # opennnnnnnnn questions

    @Slot(result='QString')
    def get_questiion(self, index):
        return self.question[index]

    @Slot(str)
    def start_record(self, file_name) -> None:
        if self.recorder:
            logging.warning()
            return
        self.recorder = AudioRecorderThread(vars.test_info.result_dir / Path(file_name + '.wav'))
        self.recorder.start()

    @Slot()
    def end_record(self) -> None:
        if not self.recorder:
            logging.warning()
            return
        self.recorder.end()


