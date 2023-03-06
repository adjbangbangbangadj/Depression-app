from pathlib import Path
from configparser import ConfigParser
import logging
import json
from typing import overload, Union
import root

_DEBUG_CONFIGS_DICT = {
    'image_test': {
        'pos_image_num': 2,
        'neu_image_num': 2,
        'neg_image_num': 2,
        'answer_duration': 2000,
        'interval_duration': 1000,
    }
}

DEFAULT_CONFIGS_DICT = {
    'general':{
        'comform_before_test_end': False
    },
    'image_test': {
        'image_dataset': 'CAPS',
        'pos_image_num': 7,
        'neu_image_num': 6,
        'neg_image_num': 7,
        'if_same_neu_image_for_neu': True,
        'if_same_neu_image_for_background': True,
        'if_allowed_images_dup': False,
        'answer_duration': 4000,
        'interval_duration': 3000,
        'if_end_immediately_after_answer': True,
        'background_color': 'black',
        'if_background_fill_view': False,
        'if_record_video': True,
    },
    'audio_test': {
        'if_shuffle_questions': False,
        'if_record_video': True,
    }
}

def get_config_type(value):
    if type(value) is int:
        return int
    if type(value) is str:
        return str
    if type(value) is bool:
        return bool
    if type(value) is float:
        return float

CONFIGS_TYPE_DICT = {k1:{k2:get_config_type(v2) for k2,v2 in v1.items()} for k1,v1 in DEFAULT_CONFIGS_DICT.items()}

def get_config_keys(config_dict) -> list[tuple[str,str]]:
    config_keys = set()
    for section_name, section_proxy in config_dict.items():
        for option_name in section_proxy.keys():
            config_keys.add((section_name, option_name))
    return config_keys

DEFAULT_CONFIGS_KEYS = get_config_keys(DEFAULT_CONFIGS_DICT)

class ConfigManager:
    def __init__(self, using_debug_config:bool=False):
        super().__init__()
        self.config_path = root.CONFIGS_DIR / Path('app.cfg')
        self.config: ConfigParser = ConfigParser()
        self.config.read_dict(DEFAULT_CONFIGS_DICT)
        self.config.read(self.config_path)
        if using_debug_config:
            self.config.read_dict(_DEBUG_CONFIGS_DICT)

    def load_configs(self, new_config, strict=False, using_default=False):
        new_config = ConfigParser()
        if not strict and using_default:
            new_config.read_dict(DEFAULT_CONFIGS_DICT)
        if isinstance(new_config, str):
            new_config.read(new_config)
        else: # ConfigParser, dict
            new_config.read_dict(new_config)
        new_config_keys = get_config_keys(new_config)
        for i in DEFAULT_CONFIGS_KEYS:
            if i not in new_config_keys:
                error_msg = 'option not find when read config: [%s][%s]' % i
                if strict:
                    raise RuntimeError(error_msg)
                else:
                    logging.warning(error_msg)
        self.config = new_config

    def get(self, section_name: str, option_name: str):
        return CONFIGS_TYPE_DICT[section_name][option_name](self.config[section_name][option_name])

    def save_configs(self) -> bool:
        try:
            with open(self.config_path, 'w') as config_file:
                self.config.write(config_file)
            return True
        except:
            logging.warning(
                f'cannot save configs to default location f{self.config_path}')
            return False

    def import_configs(self, import_path) -> bool:
        import_path = Path(import_path)
        new_config = ConfigParser()
        new_config.read_file(root.CONFIGS_DIR / Path('app.cfg'))
        try:
            self.load_configs(new_config, strict=True)
        except RuntimeError as e:
            logging.error(str(e))
            logging.error(f'cannot import configs from {import_path}')
            return False
        return True

    def export_configs(self, export_path) -> bool:
        export_path = Path(export_path)
        try:
            with open(export_path, 'w') as config_file:
                self.config.write(config_file)
            return True
        except:
            logging.error(f'cannot export configs to f{export_path}')
            return False
