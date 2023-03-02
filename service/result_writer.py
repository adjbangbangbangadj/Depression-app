from csv import DictWriter
import path

_results_dir = "\\results\\"


def ...():



def save_result(file_name: str, pics_with_mark: list, *, if_ch_header: bool = False,
                if_ch_contents: bool = False) -> None:
    pics = pics_with_mark.copy()

    for pic in pics:
        del pic['pic']
        if 'user-label' not in pic:
            pic['user-label'], pic['duration'] = "nil", 0

    with open(path.executable_path + _results_dir + ((username + 'v') if username != "" else "") +
              test_time.replace(':', ';') + '.csv', 'w', encoding='utf-8-sig') as save_file:
        writer = DictWriter(save_file, fieldnames=pics[0].keys(), lineterminator='\n')
        writer.writeheader()
        writer.writerows(pics)
