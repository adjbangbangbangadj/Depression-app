from PySide6.QtQml import QQmlImageProviderBase
from PySide6.QtQuick import QQuickImageProvider
from pathlib import Path
import sys
import logging
import conf
from collections import namedtuple
from datetime import datetime


executable_path = Path(sys.argv[0]).parent
result_parent_dir = executable_path / Path('result')


if not result_parent_dir.is_dir():
    try:
        result_parent_dir.mkdir()
    except OSError:
        logging.error('can not create ./result dir')
        raise


config_dir = executable_path / Path('config.ini')


config = conf.conf_manager
try:
    config_file = open('config.ini','r')
    # config.read_file(config_file)
except Exception as e:
    logging.warning('Could not read config.ini file!')
    raise


test_info = ...

def TestInfo(username, begin_time = None):
    begin_time = begin_time or datetime.now()
    dir_name = '_'.join([x for x in [username, begin_time.strftime('%Y-%m-%d_%H-%M-%S')] if x])
    result_dir = executable_path / Path(dir_name)
    try:
        result_dir.mkdir()
    except OSError:
        raise
    return namedtuple('TestInfo',[username, begin_time, result_dir])(username, begin_time, result_dir)


class ImageProvider(QQuickImageProvider):
    def __init__(self):
        super().__init__(QQmlImageProviderBase.Image)
        self.images:dict = {}

    def requestImage(self, id, size, requestedSize):
        return self.images['id']
        # if id == "background":
            # return vars.interval_background
        # return vars.get_pic(int(id))

image_provider = ImageProvider()
