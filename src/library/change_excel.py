from openpyxl import load_workbook


def national_code_be_null():
    workbook = load_workbook(filename='data/LMS/correct_bnpl_account.xlsx')
    sheet = workbook.active
    sheet['J2'] = ''
    workbook.save(filename='data/LMS/wrong_bnpl_account.xlsx')


def cell_number_be_null():
    workbook = load_workbook(filename='data/LMS/correct_bnpl_account.xlsx')
    sheet = workbook.active
    sheet['A2'] = ''
    workbook.save(filename='data/LMS/wrong_bnpl_account.xlsx')


def invalid_count_loan():
    workbook = load_workbook(filename='data/LMS/correct_bnpl_account.xlsx')
    sheet = workbook.active
    sheet['G2'] = 4
    workbook.save(filename='data/LMS/wrong_bnpl_account.xlsx')


def over_max_amount_loan():
    workbook = load_workbook(filename='data/LMS/correct_bnpl_account.xlsx')
    sheet = workbook.active
    sheet['F2'] = 500000000
    workbook.save(filename='data/LMS/wrong_bnpl_account.xlsx')


def below_min_loan_amount():
    workbook = load_workbook(filename='data/LMS/correct_bnpl_account.xlsx')
    sheet = workbook.active
    sheet['F2'] = 10000
    workbook.save(filename='data/LMS/wrong_bnpl_account.xlsx')


def conflict_cell_number_and_national_code():
    workbook = load_workbook(filename='data/LMS/correct_bnpl_account.xlsx')
    sheet = workbook.active
    sheet['A2'] = '09127349856'
    workbook.save(filename='data/LMS/wrong_bnpl_account.xlsx')
