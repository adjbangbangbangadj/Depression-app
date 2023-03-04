from PySide6.QtCore import QObject, Slot
from vars import data_dir, logs_dir, results_dir
import subprocess

class FileUtils(QObject):
    @Slot()
    def open_results_dir(self):
        subprocess.Popen(f'explorer "{str(results_dir)}"')

    @Slot()
    def open_data_dir(self):
        subprocess.Popen(f'explorer "{str(data_dir)}"')

    @Slot()
    def open_log_dir(self):
        subprocess.Popen(f'explorer "{str(logs_dir)}"')

