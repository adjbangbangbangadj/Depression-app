from PySide6.QtQml import QQmlImageProviderBase
from PySide6.QtQuick import QQuickImageProvider
from pathlib import Path
import sys
import logging
import traceback
import argparse

from collections import namedtuple
from datetime import datetime, date

EXECUTABLE_PATH = Path(sys.argv[0]).parent
DATA_DIR = EXECUTABLE_PATH / Path('data')
LOGS_DIR = EXECUTABLE_PATH / Path('logs')
CONFIGS_DIR = EXECUTABLE_PATH / Path('conf')
RESULTS_DIR = EXECUTABLE_PATH / Path('results')


def check_dir(path: Path, raise_if_nonexsit: bool = False):
    if not path.is_dir():
        if raise_if_nonexsit:
            raise OSError(f'can not find {path} directory')
        else:
            try:
                path.mkdir()
            except OSError:
                logging.error(f'can not create {path} directory')
                raise


for d in [DATA_DIR, LOGS_DIR, CONFIGS_DIR, RESULTS_DIR]:
    check_dir(d)


neuracle_trigger = None
configuration = None


def start():
    argparser = argparse.ArgumentParser()
    argparser.add_argument('--debug', action='store_true', help='using debug config')
    argparser.add_argument('--verbose', action='store_true', help='output debug info to console')
    argv, qt_argv = argparser.parse_known_args(sys.argv)

    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    formatter = logging.Formatter('[%(asctime)s] %(levelname)s: %(message)s')
    file_logger = logging.FileHandler(
        LOGS_DIR / Path(date.today().strftime("%Y-%m") + '.log'))
    file_logger.setFormatter(formatter)
    file_logger.setLevel(logging.WARNING)
    logger.addHandler(file_logger)
    console_logger = logging.StreamHandler()
    console_logger.setFormatter(formatter)
    if argv.verbose:
        console_logger.setLevel(logging.DEBUG)
    else:
        console_logger.setLevel(logging.INFO)
    logger.addHandler(console_logger)
    return argv, qt_argv

argv, qt_argv = start()

def excepthook(exc_type, exc_value, exc_traceback):
    logging.error("".join(traceback.format_exception(
        exc_type, exc_value, exc_traceback)))


sys.excepthook = excepthook


def TestInfo(username, begin_time=None):
    begin_time = begin_time or datetime.now()
    dir_name = '_'.join(
        [x for x in [username, begin_time.strftime('%Y-%m-%d_%H-%M-%S')] if x])
    result_dir = RESULTS_DIR / Path(dir_name)
    try:
        result_dir.mkdir()
    except OSError:
        raise
    return namedtuple('TestInfo', ['username', 'begin_time', 'result_dir'])(username, begin_time, result_dir)


test_info = None


class ImageProvider(QQuickImageProvider):
    def __init__(self):
        super().__init__(QQmlImageProviderBase.Image)
        self.images: dict = {}

    def requestImage(self, id, size, requestedSize):
        return self.images[id]

    def set_image(self, name, value):
        self.images[str(name)] = value


image_provider = ImageProvider()



