from PySide6.QtCore import QObject,  Slot
# import PySide6.QtCore.QMetaType.Type.QVariant as QVariant
from pathlib import Path
from configparser import ConfigParser
import logging



class ConfigManager(QObject):
    def __init__(self):
        self.config:ConfigParser = ConfigParser()

        self.config.read_file
        self.current_config_set = ...
        self.config_sets: dict[str,Path] = ...


    def _load_config(self):
        self

    def _save_config():
        ...

    @Slot(str, result="QString")
    def get(self, name):
        return self.config[name]

    @Slot(str, str)
    def set_config(self, name, value) -> None:
        self.config[name] = value

    def _load_config_sets(self):
        ...

    @Slot(result="QString")
    def get_config_sets(self):
        return list(self.config_sets.keys())

    @Slot(str)
    def delete_config_set(self, deleted:str) -> None:
        self.config_sets.index(deleted)
        try:
            ...
        except:
            ...

    @Slot(str)
    def create_config_set(self) -> None:
        # create
        ...

    @Slot(str)
    def rename_config_set(self) -> None:
        #

        ...

conf_manager = ConfigManager
