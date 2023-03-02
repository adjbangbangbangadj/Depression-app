from csv import DictWriter
from pathlib import Path

def save_csv(result_dict: list, file_dir:Path, file_name: str=None):
    file_name = file_name or file_dir.name
    with open(file_dir / Path(file_name).with_suffix('.csv'), 'w', encoding='utf-8-sig') as save_file:
        writer = DictWriter(save_file, fieldnames=result_dict[0].keys(), lineterminator='\n')
        writer.writeheader()
        writer.writerows(result_dict)
