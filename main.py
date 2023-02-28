# This Python file uses the following encoding: utf-8

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine

import sys
import path
import controller

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    context = engine.rootContext()
    context.setContextProperty("$test", controller.test_controller)
    context.setContextProperty("$config", controller.config_controller)
    engine.addImageProvider("test", controller.test_image_provider)
    engine.load(path.executable_path + "\\qml\\main.qml")

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
