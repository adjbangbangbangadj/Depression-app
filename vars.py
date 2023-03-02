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


config_path = executable_path / Path('config.ini')
try:
    config_file = open('config.ini','r')
    conf.read_file(config_file)
except Exception as e:
    logging.warning('Could not read config.ini file!')
    raise
config = conf

curr_test_info = ...

# interval_background = ...

def testinfo(username, begin_time = None):
    begin_time = begin_time or datetime.now()
    result_dir = '_'.join([x for x in [username, begin_time.strftime('%Y-%m-%d_%H-%M-%S')] if x])
    try:
        result_dir.mkdir()
    except OSError:
        raise
    return namedtuple('TestInfo',[username, begin_time, result_dir])(username, begin_time, result_dir)
