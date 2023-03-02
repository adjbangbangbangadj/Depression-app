import os
from csv import DictWriter
import path
from data_service import repo

_label_en2ch_dict = {"pos": u"积极", "neu": u"中性", "neg": u"消极", "nil": u"未作答"}
_key_en2ch_dict = {"user-label": u"用户回答", "label": u"图片分类", "duration": u"作答时间(单位：毫秒)", "name": u"图片名称"}
_results_dir = "\\results\\"


def save_result(username: str, test_time: str, pics_with_mark: list, *, if_ch_header: bool = False,
                if_ch_contents: bool = False) -> None:
    # pics = pics_with_mark.copy()
    pics = pics_with_mark
    # print(pics)
    for pic in pics:
        del pic['pic']
        if 'user-label' not in pic:
            pic['user-label'], pic['duration'] = "nil", 0
        # if if_ch_contents:
        #     pic['user-label'], pic['label'] = _label_en2ch_dict[pic['user-label']], _label_en2ch_dict[
        #         pic['label']]
        # if if_ch_header:
        #     for k in _key_en2ch_dict.keys():
        #         pic[_key_en2ch_dict[k]] = pic.pop(k)
        # currentPath = _results_dir + repo.folder + "\\"
    with open(path.executable_path + repo.currentPath + ((username + '  ') if username != "" else "") +
              test_time.replace(':', ';') + '.csv', 'w', encoding='utf-8-sig') as save_file:
        writer = DictWriter(save_file,
                            fieldnames=pics[0].keys(),
                            # fieldnames=_key_en2ch_dict.values() if if_ch_header else _key_en2ch_dict.keys(),
                            lineterminator='\n')
        writer.writeheader()
        writer.writerows(pics)

