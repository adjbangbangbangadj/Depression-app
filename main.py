# This Python file uses the following encoding: utf-8

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType
from pathlib import Path
import sys

import root
import conf
from bridges.image_tester import ImageTester
from bridges.audio_tester import AudioTester
from bridges.main_tester import MainTester
from utils.neuracle_trigger import NeuracleTrigger
from controller.utils_controller import UtilsController
from controller.config_controller import ConfigController


if __name__ == "__main__":
    root.neuracle_trigger = NeuracleTrigger()
    root.configuration = conf.ConfigManager(root.argv.debug)

    utils_controller = UtilsController()
    config_controller = ConfigController()

    app = QGuiApplication(root.qt_argv)
    engine = QQmlApplicationEngine()

    qmlRegisterType(ImageTester, 'Main', 1, 0, 'ImageTester')
    qmlRegisterType(AudioTester, 'Main', 1, 0, 'AudioTester')
    qmlRegisterType(MainTester, 'Main', 1, 0, 'MainTester')

    context = engine.rootContext()
    context.setContextProperty("$utils", utils_controller)
    context.setContextProperty("$config", config_controller)

    engine.addImageProvider("main", root.image_provider)
    engine.load(str(root.EXECUTABLE_PATH / Path("app/main.qml")))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
