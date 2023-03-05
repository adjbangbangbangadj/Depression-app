from PySide6.QtCore import QObject, Slot
from utils.video_recorder import VideoCaptureThread
from pathlib import Path
import logging
import vars

class MainTester(QObject):
    @Slot(str)
    def test_start(self, username):
        self.video_recorder = None
        vars.test_info = vars.TestInfo(username)
        logging.info(f'test started. user:f{username}')

    @Slot(str)
    def subtest_start(self, test_name):
        if self.video_recorder:
            logging.warning('try to start recording when already recording')
            return
        self.video_recorder = VideoCaptureThread(vars.test_info.result_dir / Path(test_name + '.avi'))
        self.video_recorder.start()
        logging.info(f'{test_name} test started. user:f{vars.test_info.username}')

    @Slot(str)
    def subtest_end(self, test_name):
        if not self.video_recorder:
            logging.warning('try to end recording when not recording')
            return
        self.video_recorder.end()
        logging.info(f'{test_name} test finished. user:{vars.test_info.username}'
                     f'\nresults saved to {vars.test_info.result_dir}')
