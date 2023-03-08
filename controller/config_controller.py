from PySide6.QtCore import QObject, Slot, QUrl, Property, Signal
from functools import partial
import root
import conf

_PROPERTY_NAME = '{section}__{option}'
_SIGNAL_NAME = _PROPERTY_NAME + 'Changed'
_SETTER_NAME = 'set__' + _PROPERTY_NAME
_GETTER_NAME = 'get__' + _PROPERTY_NAME
_QTYPE_PARAM2RESULT = {'str':'QString'}


def init_properties(namespace, _set, _get):
    for section, option, _ in conf.nested_iterator(conf.DEFAULT_CONFIGS_DICT):
        param_qtype = conf.CONFIGS_TYPE_DICT[section][option]
        result_qtype = _QTYPE_PARAM2RESULT.get(param_qtype.__name__, param_qtype.__name__)
        qsignal = Signal(param_qtype)
        qgetter = Slot(result=result_qtype)(partial(_get, section=section, option=option))
        qsetter = Slot(param_qtype)(partial(_set, section=section, option=option))
        namespace[_SIGNAL_NAME.format(section=section, option=option)]=qsignal
        namespace[_GETTER_NAME.format(section=section, option=option)]=qgetter
        namespace[_SETTER_NAME.format(section=section, option=option)]=qsetter
        namespace[_PROPERTY_NAME.format(section=section, option=option)]=\
            Property(result_qtype, qgetter, qsetter, notify = qsignal)

class ConfigController(QObject):
    def __init__(self):
        super().__init__()
        self.config_dict: dict[str, dict] = {}

    def _get(self, section, option):
        try:
            return self.config_dict[section][option]
        except KeyError:
            return root.configuration.get(section, option)

    def _set(self, value, section, option):
        if self._get(section, option) == value:
            return
        try:
            self.config_dict[section]
        except KeyError:
            self.config_dict[section] = {option: value}
        else:
            self.config_dict[section][option]=value
        getattr(self, _SIGNAL_NAME.format(section=section, option=option)).emit(value)

    init_properties(locals(), _set, _get)

    def reset_configs(self, new_configs):
        for section_name,section_proxy in new_configs.items():
            for option_name, value in section_proxy.items():
                getattr(self, _SETTER_NAME.format(section=section_name, option=option_name))(self, value)

    @Slot()
    def reset_to_default(self):
        self.reset_configs(conf.DEFAULT_CONFIGS_DICT)

    @Slot()
    def cancel_changes(self):
        self.reset_configs(root.configuration.get_configs())


    @Slot(result='bool')
    def save_changes(self) -> bool:
        for section_name,section_proxy in self.config_dict.items():
            for option_name, value in section_proxy.items():
                root.configuration.set(section_name, option_name, value)
        return root.configuration.save_configs()

    @Slot(str, result='bool')
    def import_configs(self, import_path) -> bool:
        return root.configuration.import_configs(QUrl(import_path).toLocalFile())

    @Slot(str, result='bool')
    def export_configs(self, export_path) -> bool:
        return root.configuration.export_configs(QUrl(export_path).toLocalFile())

    @Slot(result='QUrl')
    def get_configs_dir(self):
        return QUrl(str(root.CONFIGS_DIR))

