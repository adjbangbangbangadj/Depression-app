# This Python file uses the following encoding: utf-8

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

import argparse
# import configparser
import logging
import sys
from pathlib import Path

import vars

if __name__ == "__main__":
    # logging
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)

    # console_handler = logging.StreamHandler(sys.stdout)
    # file_handler = logging.FileHandler()

    # logger.addHandler(console_handler)
    # logger.addHandler(file_handler)

    # argparse
    parser = argparse.ArgumentParser()
    args = parser.parse_args()


    # qtquick start
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    context = engine.rootContext()
    # context.setContextProperty("$test", controller.test_controller)
    context.setContextProperty("$config", vars.config)
    engine.addImageProvider("test", vars.image_provider)
    engine.load(str(vars.executable_path / Path("qml/test_main.qml")))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
