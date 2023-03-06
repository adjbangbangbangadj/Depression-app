from PySide6.QtCore import QObject, Slot, QUrl, Property, Signal
from functools import partial
import logging
import root
import conf


def init_properties(cls,_set,_get):
    for section, option in conf.DEFAULT_CONFIGS_KEYS:
        qtype = conf.CONFIGS_TYPE_DICT[section][option]
        qsignal = Signal(qtype)
        _get = Slot(qtype)(_get)
        _set = Slot(result='qtype' )(_set)
        setattr(cls, section + '__' + option + 'Cnanged', qsignal)
        setattr(cls, section + '__' + option, Property(conf.CONFIGS_TYPE_DICT[section][option],
            partial(_set, section=section, option=option),
            partial(_get, section=section, option=option), notify = qsignal))

class ConfigController(QObject):
    def __init__(self):
        super().__init__()
        self.config_dict: dict[str, dict] = conf.DEFAULT_CONFIGS_DICT

    def _get(self, section, option):
        try:
            return self.config_dict[section][option]
        except KeyError:
            return root.configuration.get(section, option)

    def _set(self, section, option, value):
        if self._get(section, option) == value:
            return
        getattr(self,section+'__'+option+'Changed').emit(value)
        try:
            self.config_dict[section][option] = value
        except KeyError:
            logging.error('Unexpected config value: section=%s option=%s value=%s', section, option, value)
            raise


    @Slot(result='bool')
    def save_changes(self) -> bool:
        root.configuration.load_configs(self.config_dict)
        return root.configuration.save_configs()

    @Slot(str, result='bool')
    def import_configs(self, import_path) -> bool:
        return self.config.import_configs(import_path)

    @Slot(str, result='bool')
    def export_configs(self, export_path) -> bool:
        return self.config.export_configs(export_path)

    @Slot(result='QUrl')
    def get_configs_dir(self):
        return QUrl(str(root.CONFIGS_DIR))

init_properties(ConfigController, ConfigController._set, ConfigController._get)
