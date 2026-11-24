import os
import openpyxl
import random
import yaml
from robot.api.deco import keyword
import  faker_utils


default_columns = [
    "شماره موبایل",
    "نام",
    "نام خانوادگی",
    "جنسیت",
    "امتیاز کمپانی‌پی",
    "میزان اعتبار (ریال)",
    "تعداد اقساط",
    "شماره شناسنامه",
    "تاریخ تولد",
    "کد ملی",
    "کدپستی",
    "استان",
    "شهر",
    "آدرس",
    "پلاک",
    "واحد",
    "شماره تماس ثابت"
]

@keyword
def create_dump(values, save_path, headers=None):
    """
    This function creates a dump file with the provided values and headers.
    Appends each row of values to the existing dump file or creates a new dump file if it does not exist.

    Inputs:
        values: List, the values for the row.
        save_path: String, the location and the file name of the dump file.
        headers: List, the header columns of the file which can be None.
    """
    if os.path.exists(save_path):
        wb = openpyxl.load_workbook(save_path)
        ws = wb.active
    else:
        wb = openpyxl.Workbook()
        ws = wb.active
        ws.title = "Dump"
        if headers is not None:
            ws.append(headers)

    ws.append(values)
    wb.save(save_path)

@keyword
def create_template(inst_count,
                        amount,
                        save_path,
                        default_information,
                        CRN=None,
                        cell_number = faker_utils.fake_cell_number(),
                        national_code = faker_utils.fake_national_code(),
                        **kwargs):
    """
    A function to create an individual-user or organizational template for import=allocation.

    Input:
        inst_count:  Int; the installment count.
        amount:  Int; the amount of the loan.
        save_path: String; the location of the (to be) saved template.
        default_information: String; the location of the default import values (must be a yaml file).
        CRN: None or Int; If is None, then the allocation is individual and if the CRN is Int, the allocation is organizational.
        cell_number: String or None; if None then a randomly generated cellNumber will be used.
        national_code: String or None; if None then a randomly generated SSN will be used.
        kwargs: Dictionary or None; if it is given, then the template is created using those information. Here are the optional kwargs:
            "name": String; The name of the user. For example کاربر
            "surname": String; The surname of the user. For example  تست
            "gender": String; The gender of the user. For example مرد
            "score": String; The platform score of the user. For example 800
            "birthdate": String;  The birthdate  of the user with the YYYY/MM/DD format. For example 1313/12/31.  
            "postal_code": String; The postal code of the user. For example 1461755535
            "provenance": String; The provenance of the user. For example تهران
            "city": String; The city of the user. For example تهران
            "address": String; The address of the user. For example تهران - شرکت کمپانی‌پی
            "number": String; The number of the user. For example  2
            "unit": String; The unit of the user. For example 3
            "phone_number": String; The phone number of the user, not to be confused with the user's cell_number. For example 02133438607
    """
    
    with open(default_information, 'r', encoding='utf-8') as file:
        config = yaml.safe_load(file)
    data = [
        cell_number,
        config["name"] if "name" not in kwargs else kwargs["name"],
        config["surname"] if "surname" not in kwargs else kwargs["surname"],
        config["gender"]  if "gender" not in kwargs else kwargs["gender"],
        config["score"]  if "score" not in kwargs else kwargs["score"],
        amount,
        inst_count,
        national_code,
        config["birthdate"]  if "birthdate" not in kwargs else kwargs["birthdate"],
        national_code,
        config["postal_code"]  if "postal_code" not in kwargs else kwargs["postal_code"],
        config["provenance"]  if "provenance" not in kwargs else kwargs["provenance"],
        config["city"] if "city" not in kwargs else kwargs["city"],
        config["address"]  if "address" not in kwargs else kwargs["address"],
        config["number"]  if "number" not in kwargs else kwargs["number"],
        config["unit"]  if "unit" not in kwargs else kwargs["unit"],
        config["phone_number"]  if "phone_number" not in kwargs else kwargs["phone_number"],
    ] 

    if CRN is not None:
        columns = default_columns + ["شماره ثبت سازمان"]
        data = data + [str(CRN)]
    else:
        columns = default_columns
    
    wb = openpyxl.Workbook()
    ws = wb.active
    if CRN is not None:
        ws.title = "Organizational"
    else:
        ws.title = "individual-user"
    
    ws.sheet_view.rightToLeft = True

    for col_num, column in enumerate(columns, start=1):
        ws.cell(row=1, column=col_num, value=column)

    for col_num, value in enumerate(data, start=1):
        ws.cell(row=2, column=col_num, value=value)

    wb.save(save_path)

@keyword
def delete_template(file_path):
    """
    This function deletes a file using the file_path.
    """
    if os.path.exists(file_path):
        os.remove(file_path)




#  Examples ...

# create_template(inst_count=6,
#               amount=30000,
#                   save_path="./data/los/dummy-import-allocation-template.xlsx",
#                   default_information="./data/los/default-import-information.yaml", 
#                     CRN=None,
#                     name = "کاربر",
#                     surname = "تست",
#                     birthdate = "1313/13/13",
#                     city = "تهران"
#                     )
                    

# delete_template(file_path="./data/los/dummy-import-allocation-template.xlsx")
