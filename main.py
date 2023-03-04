# This Python file uses the following encoding: utf-8

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType

import logging
import sys
from pathlib import Path

import vars
from controller.file_utils import FileUtils
from controller.neuracle_trigger import NeuracleTrigger


if __name__ == "__main__":
    # logging
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)

    # console_handler = logging.StreamHandler(sys.stdout)
    # file_handler = logging.FileHandler()

    # logger.addHandler(console_handler)
    # logger.addHandler(file_handler)

    # qmlRegisterType(NumberGenerator, 'Generators', 1, 0, 'NumberGenerator')

    # qtquick start
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # context.setContextProperty("$test", controller.test_controller)
    context = engine.rootContext()
    context.setContextProperty("$file_utils", FileUtils)
    context.setContextProperty("$neuracle_trigger", NeuracleTrigger)
    # context.setContextProperty("$", vars.config)
    # context.setContextProperty("$", vars.config)
    engine.addImageProvider("root", vars.image_provider)
    engine.load(str(vars.executable_path / Path("app/main.qml")))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
