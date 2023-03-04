from PySide6.QtCore import QObject, Slot
from utils.video_recorder import VideoCaptureThread
from pathlib import Path
import logging
import vars

class MainTester(QObject):
    @Slot(str)
    def test_start(self, username):
        self.videoRecorder = None
        vars.test_info = vars.TestInfo(username)
        logging.info(f'test started. user:f{username}')

    @Slot(str)
    def subtest_start(self, test_name):
        if self.recorder:
            logging.warning()
            return
        self.recorder = VideoCaptureThread(vars.test_info.result_dir / Path(test_name + '.avi'))
        self.recorder.start()
        logging.info(f'{test_name} test started. user:f{vars.test_info.username}')

    @Slot(str)
    def subtest_end(self, test_name):
        if not self.recorder:
            logging.warning()
            return
        self.recorder.end()
        logging.info(f'{test_name} test finished. user:{vars.test_info.username}'
                     f'\nresults saved to {vars.test_info.result_dir}')
