from pathlib import Path
from configparser import ConfigParser
import logging
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
        'app_signture': 'DepressionTester',
        'if_confirm_before_test_end': False
    },
    'image_test': {
        'image_dataset': 'KDEF',
        'pos_image_num': 7,
        'neu_image_num': 6,
        'neg_image_num': 7,
        'if_same_neu_image_for_neu': True,
        'if_same_neu_image_for_background': True,
        'if_allowed_images_dup': False,
        'answer_duration': 4000,
        'interval_duration': 3000,
        'if_end_immediately_after_answer': True,
        'interval_background_color': 'black',
        'if_interval_background_fill_view': False,
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

CONFIGS_TYPE_DICT = {se:{op:get_config_type(v) for op,v in sproxy.items()}
                      for se, sproxy in DEFAULT_CONFIGS_DICT.items()}

def nested_iterator(config_dict):
    for section_name, section_proxy in config_dict.items():
        for option_name, value in section_proxy.items():
            yield (section_name, option_name, value)


class ConfigManager:
    def __init__(self, using_debug_config:bool=False):
        super().__init__()
        self.config_path = root.CONFIGS_DIR / Path('app.cfg')
        self.config: ConfigParser = ConfigParser()
        self.config.read_dict(DEFAULT_CONFIGS_DICT)
        self.config.read(self.config_path)
        if using_debug_config:
            self.config.read_dict(_DEBUG_CONFIGS_DICT)

    def load_configs(self, loaded_config, check_signture=True, strict=False, using_default=False):
        new_config = ConfigParser()
        if isinstance(loaded_config, str) or isinstance(loaded_config, Path):
            new_config.read(loaded_config)
        else: #isinstance(loaded_config, dict) or isinstance(loaded_config, ConfigParser):
            new_config.read_dict(loaded_config)
        if check_signture:
            try:
                if not new_config['general']['app_signture'] == 'DepressionTester':
                    raise RuntimeError('wrong config file. app signture dismatched.')
            except KeyError:
                raise RuntimeError('wrong config file. cannot find app signture.')
        for section, option, _ in nested_iterator(DEFAULT_CONFIGS_DICT):
            try:
                new_config[section][option]
            except KeyError:
                error_msg = 'option not find when read config: [%s][%s]' % section, option
                if strict:
                    raise RuntimeError(error_msg)
                else:
                    logging.warning(error_msg)
        if not strict and using_default:
            new_config_with_default = ConfigParser()
            new_config_with_default.read_dict(DEFAULT_CONFIGS_DICT)
            new_config = new_config_with_default.read_dict(new_config)
        self.config = new_config

    def set(self, section: str, option: str, value):
        self.config.set(section, option, str(value))

    def get(self, section: str, option: str):
        config_type = CONFIGS_TYPE_DICT[section][option]
        if config_type == bool:
            return self.config.getboolean(section, option)
        if config_type == float:
            return self.config.getfloat(section, option)
        if config_type == int:
            return self.config.getint(section, option)
        else: #config_type = str
            return self.config.get(section, option)

    def get_configs(self):
        return {se:{op:self.get(se,op) for op,_ in sproxy.items()} for se, sproxy in self.config.items()}

    def save_configs(self) -> bool:
        try:
            with open(self.config_path, 'w', encoding='UTF-8') as config_file:
                self.config.write(config_file)
            return True
        except:
            logging.warning(
                f'cannot save configs to default location f{self.config_path}')
            return False

    def import_configs(self, import_path) -> bool:
        import_path = Path(import_path)
        try:
            self.load_configs(import_path) #TODO:provide version support check
        except RuntimeError as e:
            logging.error(str(e))
            logging.error(f'cannot import configs from {import_path}')
            return False
        return True

    def export_configs(self, export_path) -> bool:
        export_path = Path(export_path)
        try:
            with open(export_path, 'w', encoding='utf-8') as config_file:
                self.config.write(config_file)
            return True
        except OSError as e:
            logging.error(f'cannot export configs to {export_path}')
            logging.error(str(e))
            return False
