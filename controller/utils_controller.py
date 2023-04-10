from PySide6.QtCore import QObject, Slot
import root
import subprocess
# from utils.neuracle_trigger import NeuracleTrigger

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

    @Slot(result='bool')
    def mark_test(self):
        return root.neuracle_trigger.mark(0)

