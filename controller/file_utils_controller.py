from PySide6.QtCore import QObject, Slot
from root import DATA_DIR, LOGS_DIR, RESULTS_DIR
import subprocess

class FileUtilsController(QObject):
    @Slot()
    def open_results_dir(self):
        subprocess.Popen(f'explorer "{str(RESULTS_DIR)}"')

    @Slot()
    def open_data_dir(self):
        subprocess.Popen(f'explorer "{str(DATA_DIR)}"')

    @Slot()
    def open_log_dir(self):
        subprocess.Popen(f'explorer "{str(LOGS_DIR)}"')

