from PySide6.QtQml import QQmlImageProviderBase
from PySide6.QtQuick import QQuickImageProvider
from pathlib import Path
import sys
import logging
import traceback

from collections import namedtuple
from datetime import datetime, date

executable_path = Path(sys.argv[0]).parent
data_dir = executable_path / Path('data')
logs_dir = executable_path / Path('logs')
configs_dir = executable_path / Path('conf')
results_dir = executable_path / Path('results')

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
formatter = logging.Formatter('[%(asctime)s] %(levelname)s: %(message)s')
file_logger = logging.FileHandler(logs_dir / Path(date.today().strftime("%Y-%m") + '.log'))
file_logger.setFormatter(formatter)
file_logger.setLevel(logging.INFO)
logger.addHandler(file_logger)
console_logger = logging.StreamHandler()
console_logger.setFormatter(formatter)
console_logger.setLevel(logging.DEBUG)
logger.addHandler(console_logger)

def excepthook(exc_type, exc_value, exc_traceback):
    logging.error("".join(traceback.format_exception(exc_type, exc_value, exc_traceback)))
sys.excepthook = excepthook

def check_dir(path:Path, raise_if_nonexsit:bool = False):
    if not path.is_dir():
        if raise_if_nonexsit:
            raise OSError(f'can not find {path} directory')
        else:
            try:
                results_dir.mkdir()
            except OSError:
                logging.error(f'can not create {path} directory')
                raise

for d in [data_dir, logs_dir, configs_dir, results_dir]:
    check_dir(d)


configuration = None
test_info = None

def TestInfo(username, begin_time = None):
    begin_time = begin_time or datetime.now()
    dir_name = '_'.join([x for x in [username, begin_time.strftime('%Y-%m-%d_%H-%M-%S')] if x])
    result_dir = results_dir / Path(dir_name)
    try:
        result_dir.mkdir()
    except OSError:
        raise
    return namedtuple('TestInfo',['username', 'begin_time', 'result_dir'])(username, begin_time, result_dir)


class ImageProvider(QQuickImageProvider):
    def __init__(self):
        super().__init__(QQmlImageProviderBase.Image)
        self.images:dict = {}

    def requestImage(self, id, size, requestedSize):
        return self.images[id]
        # if id == "background":
            # return vars.interval_background
        # return vars.get_pic(int(id))

    def set_image(self, name, value):
        self.images[str(name)] = value

image_provider = ImageProvider()
