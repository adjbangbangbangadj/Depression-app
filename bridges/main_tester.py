from PySide6.QtCore import QObject, Slot
from utils.video_recorder import VideoCaptureThread
from pathlib import Path
import json
import logging
import root

_USERNAME_PLACEHOLDER = '[not entered]'
_IF_RECORD_VIDEO_CONFIG_NAME = 'if_record_video'

TEST_LIST = ['image_test','audio_test']

class MainTester(QObject):
    def __init__(self):
        super().__init__()
        self.video_record_skiped = []
        for test_name in TEST_LIST:
            self.video_record_skiped.append(not root.configuration.get(test_name,_IF_RECORD_VIDEO_CONFIG_NAME))


    @Slot(str)
    def test_start(self, username):
        self.video_recorder = None
        root.test_info = root.TestInfo(username)
        logging.info('test started. username:%s begin_time:%s',
                     username or _USERNAME_PLACEHOLDER, root.test_info.begin_time)

    @Slot(str)
    def subtest_start(self, test_name):
        if test_name not in TEST_LIST:
            logging.warning(f'unexpected test_name argument: {test_name}')
        logging.info('%s test started. username:%s begin_time:%s', test_name,
                     root.test_info.username or _USERNAME_PLACEHOLDER, root.test_info.begin_time)
        root.neuracle_trigger.mark(test_name + '_start')
        if test_name not in self.video_record_skiped:
            if self.video_recorder and self.video_recorder.is_alive():
                logging.warning(
                    'try to start capturing video when already started')
                return
            self.video_recorder = VideoCaptureThread(
                root.test_info.result_dir / Path(test_name + '.avi'))
            self.video_recorder.start()

    @Slot(str)
    def subtest_end(self, test_name):
        # self.completed_tests.append(test_name)
        if test_name not in TEST_LIST:
            logging.warning(f'unexpected test_name argument: {test_name}')
        logging.info('%s test finished. user_id:%s begin_time:%s\nresults saved to %s',
                     test_name, root.test_info.username or _USERNAME_PLACEHOLDER,
                     root.test_info.begin_time, root.test_info.result_dir)
        root.neuracle_trigger.mark(test_name + '_end')
        if test_name not in self.video_record_skiped:
            if not (self.video_recorder and self.video_recorder.is_alive()):
                logging.warning('try to end capturing video when already ended')
                return
            try:
                self.video_recorder.end()
            except:
                logging.error('error happend in ending capturing video.')
                raise

    @Slot(result='QString')
    def get_tests(self)->str:
        return json.dumps(TEST_LIST)
