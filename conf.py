from PySide6.QtCore import QObject, Slot, QUrl
# import PySide6.QtCore.QMetaType.Type.QVariant as QVariant
from pathlib import Path
import vars
from configparser import ConfigParser
import logging


_default_configs_dict = {
    'image_test':{
        'image_dataset': "CAPS",
        'pos_image_num': 7,
        'neu_image_num': 6,
        'neg_image_num': 7,
        'if_same_neu_image_for_neu':True,
        'if_same_neu_image_for_background':True,
        'if_allowed_images_dup':False,
        'answer_duration': 4000,
        'interval_duration': 3000,
        'if_end_immediately_after_answer': True,
        'background_color': "black",
        'if_background_fill_view': False,
        'if_record_video': True,
    },
    'audio_test':{
        'if_shuffle_questions': False,
        'if_record_video': True,
    }
}


class ConfigManager(QObject):
    def __init__(self):
        super().__init__()
        self.config_path = vars.configs_dir / Path('app.cfg')
        self.config:ConfigParser = ConfigParser()
        self.config.read(self.config_path)
        self.config.read_dict(_default_configs_dict)


    @Slot(str, str, result="str")
    def get(self, section_name:str, option_name:str):
        return self.config[section_name][option_name]

    @Slot(str, str)
    def set_config(self, name, value) -> None:
        self.config[name] = value

    @Slot(str)
    def save_configs(self, json) -> None:
        ...
        edited_config_dict = ...
        edited_config = ConfigParser()
        edited_config.read_dict(edited_config_dict)
        self.config = edited_config_dict
        try:
            with open(self.config_path, 'w') as config_file:
                self.config.write(config_file)
        except:
            logging.warning(f'cannot save configs to default location f{self.config_path}')


    @Slot(str, result='bool')
    def import_configs(self, import_path):
        import_path = Path(import_path)
        new_config = ConfigParser()
        new_config.read_file(vars.configs_dir / Path('app.cfg'))
        for section_name, section_proxy in self.config.items():
            for option_name in section_proxy.keys():
                if not new_config.has_option(section_name, option_name):
                    logging.warning(f'cannot import configs from {import_path}')
                    return False
        self.config = new_config
        return True

    @Slot(str, result='bool')
    def export_configs(self, export_path):
        export_path = Path(export_path)
        try:
            with open(export_path, 'w') as config_file:
                self.config.write(config_file)
            return True
        except:
            logging.warning(f'cannot export configs to f{export_path}')

    @Slot(result='QUrl')
    def get_configs_dir(self):
        return QUrl(str(vars.configs_dir))
