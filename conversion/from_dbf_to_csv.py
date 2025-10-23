from dbfread import DBF
import pandas as pd

from typing import List, Tuple

files_to_convert = [
    ("conversion/legacy/CARRERAS.DBF", "conversion/converted/CARRERAS.csv"),
    ("conversion/legacy/MATERIAS.DBF", "conversion/converted/MATERIAS.csv"),
    ("conversion/legacy/PLANES.DBF", "conversion/converted/PLANES.csv")

]

def from_dbf_to_csv(files: List[Tuple]):
    for input_file, output_file in files:
        table = DBF(input_file, encoding='latin1')
        df = pd.DataFrame(iter(table))
        df.to_csv(output_file, index=False, encoding='utf-8-sig')
        print(f"Archivo convertido correctamente: {output_file}")

from_dbf_to_csv(files_to_convert)


