from PySide6.QtCore import QObject, Slot
import root
import subprocess

class UtilsController(QObject):
    @Slot()
    def open_results_dir(self):
        subprocess.Popen(f'explorer "{str(root.RESULTS_DIR)}"')

    @Slot()
    def open_data_dir(self):
        subprocess.Popen(f'explorer "{str(root.DATA_DIR)}"')

    @Slot()
    def open_log_dir(self):
        subprocess.Popen(f'explorer "{str(root.LOGS_DIR)}"')

    @Slot()
    def mark_test(self):
        root.neuracle_trigger.mark(0)

