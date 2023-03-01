from copy import copy
import json
import path

# __registered_configs = {}
_configs = {}
_config_path = "\\config.json"

_questions = {}
_questions_path = "\\question.json"

def set_configs(new_configs):
    [set_config(k, v) for k, v in new_configs.items()]


def set_config(key, value):
    _configs[key] = value


def get_configs():
    return copy(_configs)


def get_config(key):
    if key not in _configs:
        raise Exception(f"can't find config: {key}")
    return _configs[key]


def save_config():
    with open(path.executable_path + _config_path, 'w') as config_file:
        config_file.write(json.dumps(_configs))


def read_config():
    with open(path.executable_path + _config_path, 'r') as config_file:
        global _configs
        _configs = json.load(config_file)


def get_questions():
    return copy(_questions)

def get_questions(key):
    if key not in _questions:
        raise Exception(f"can't find question:{key}")
    return _questions[key]

def read_question():
    with open(path.executable_path + _questions_path, 'r') as question_file:
        global _questions
        _questions = json.load(question_file)


read_question()

read_config()

# def subscribe(self, config_key, config_variable):
#     # config_variable = config_variable
#     if config_key in self.__registered_configs:
#         self.__registered_configs[config_key] = []
#
#     def set_config(value):
#         nonlocal config_variable
#         config_variable = value
#
#     self.__registered_configs[config_key].append(set_config)
#
# def publish_configs(self):
#     for config_key, set_configs in self.__registered_configs.items():
#         for set_config in set_configs:
#             set_config(self.__configs[config_key])
