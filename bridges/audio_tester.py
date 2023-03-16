from PySide6.QtCore import QObject, Slot
from utils.audio_recorder import AudioRecorderThread
from pathlib import Path
from functools import partial
from collections import namedtuple
import logging
import root

QUESTION_DIR = root.DATA_DIR / Path('questions/')
root.check_dir(QUESTION_DIR)

Question = namedtuple('Question', ['name', 'question'])


class AudioTester(QObject):
    def __init__(self):
        super().__init__()
        self.conf = partial(root.configuration.get, 'audio_test')
        self.question: list = []
        self.current_index = 0
        self.recorder:AudioRecorderThread = None
        question_files = list(QUESTION_DIR.glob('*.txt')) # return value of glob() is in arbitrary order
        if not self.conf('if_shuffle_questions'):
            question_files.sort()
        for i in QUESTION_DIR.glob('*.txt'):
            try:
                with open(i, 'r', encoding='UTF-8') as file:
                    self.question.append(Question(i.stem, file.read()))
            except OSError:
                logging.warning(
                    f'cannot read question file {i}. skiped the file.')

    @Slot(result='int')
    def question_num(self):
        return len(self.question)

    @Slot(int, result='QString')
    def get_question(self, index): # TODO:优化前端使其不再触发IndexError
        try:
            return self.question[index].question
        except:
            return 'IndexError: list index out of range'

    @Slot(int)
    def start_record(self, question_index) -> None:
        logging.debug(f'AudioTester started record: question_index={question_index}')
        self.current_index = question_index
        file_name = self.question[question_index].name
        if self.recorder and self.recorder.is_alive():
            logging.warning('try to start recording audio when already started')
            return
        self.recorder = AudioRecorderThread(
            root.test_info.result_dir / Path(file_name + '.wav'))
        # root.neuracle_trigger.mark(f'question_{question_index}_start')
        root.neuracle_trigger.mark(3)
        self.recorder.start()

    @Slot()
    def end_record(self) -> None:
        logging.debug(f'AudioTester ended record')
        if not(self.recorder and self.recorder.is_alive()):
            logging.warning('try to end recording audio when already ended')
            return
        # root.neuracle_trigger.mark(f'question_{self.current_index}_end')
        root.neuracle_trigger.mark(4)
        try:
            self.recorder.end()
        except:
            logging.error('error happend in ending recording audio.')
            raise


