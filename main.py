# This Python file uses the following encoding: utf-8

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType
from pathlib import Path
import sys

import vars
from bridges.image_tester import ImageTester
from bridges.audio_tester import AudioTester
from bridges.main_tester import MainTester
from controller.file_utils import FileUtils
from controller.neuracle_trigger import NeuracleTrigger


if __name__ == "__main__":
    file_utils = FileUtils()
    neuracle_trigger = NeuracleTrigger()

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    qmlRegisterType(ImageTester, 'main', 1, 0, 'ImageTester')
    qmlRegisterType(AudioTester, 'main', 1, 0, 'AudioTester')
    qmlRegisterType(MainTester, 'main', 1, 0, 'MainTester')

    context = engine.rootContext()
    context.setContextProperty("$file_utils", file_utils)
    context.setContextProperty("$trigger", neuracle_trigger)
    context.setContextProperty("$config", vars.config)

    engine.addImageProvider("main", vars.image_provider)
    engine.load(str(vars.executable_path / Path("app/main.qml")))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
