import jdatetime

from robot.api.deco import keyword
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta

import calendar




@keyword("Generate Dates Tejarat")
def generate_dates_tejarat(start_date, installment_count):
    date_list = []
    start_date = datetime.strptime(start_date, "%Y-%m-%dT%H:%M:%S")

    for i in range(int(installment_count)):
        new_date = start_date + \
            timedelta(days=calendar.monthrange(
                start_date.year, start_date.month)[1] * (i + 1))
        date_list.append(new_date.strftime("%Y-%m-%dT%H:%M:%S"))

    return date_list

    for i in range(int(installment_count)):
        new_date = start_date + \
            timedelta(days=calendar.monthrange(
                start_date.year, start_date.month)[1] * (i + 1))
        date_list.append(new_date.strftime("%Y-%m-%dT%H:%M:%S"))

    return date_list


@keyword("Generate Dates Mellat")
def generate_dates_mellat(start_date: int, installment_count: int):
    # start_date fromat is like: 14030911
    date_list = []
    start_date = str(start_date)

    # Converting start_date to format %Y/%m/%d
    start_date = "{}/{}/{}".format(start_date[0:4],
                                   start_date[4:6], start_date[6:8])

    # Converting solar to Gregorian Date
    start_date = jdatetime.datetime.strptime(
        start_date, "%Y/%m/%d").togregorian()

    for i in range(int(installment_count)):
        # Add one month to the start date
        new_date = start_date + relativedelta(months=i)

        # Converting Gregorian to solar Date
        jalali_date = jdatetime.datetime.fromgregorian(
            year=new_date.year, month=new_date.month, day=new_date.day)
        date_list.append(jalali_date.strftime("%Y/%m/%d"))  # Solar date Format

    return date_list


@keyword("Convert epoch to human-readable date")
def convert_epoch_to_human_readable_date(epoch_time, date_format='%Y-%m-%d %H:%M:%S'):
    # Convert epoch time to a datetime object
    dt = datetime.fromtimestamp(epoch_time)
    # Format the datetime object to a string based on the specified format
    human_readable_date = dt.strftime(date_format)
    return human_readable_date


@keyword("Convert human-readable date to epoch")
def convert_human_readable_date_to_epoch(human_date, date_format='%Y-%m-%d %H:%M:%S'):
    # Parse the human-readable date string to a datetime object
    dt = datetime.strptime(human_date, date_format)
    # Convert datetime to epoch time (seconds since Jan 1, 1970)
    epoch_time = int(dt.timestamp())
    return epoch_time


@keyword("Convert Solar Date To Epoc")
def convert_solar_date_to_epoc(solar_date):
    solar_date = jdatetime.datetime.strptime(
        solar_date, "%Y/%m/%d").togregorian()
    epoch_time = int(solar_date.timestamp())
    return epoch_time


@keyword("Convert To Persian Digit")
def convert_to_persian_numbers_custom(text):
    """
    Converts English numbers to Persian numbers using a custom function.
    """
    persian_numbers = {
        '0': '۰', '1': '۱', '2': '۲', '3': '۳', '4': '۴',
        '5': '۵', '6': '۶', '7': '۷', '8': '۸', '9': '۹'
    }
    result = ''
    for char in text:
        if char in persian_numbers:
            result += persian_numbers[char]
        else:
            result += char
    persian_text = result.replace(",", "٬")
    return persian_text

@keyword("Convert effective date To Persian Digit")
def convert_effective_date_to_persian_numbers_custom(text):
    """
    Converts English numbers to Persian numbers using a custom function.
    """
    persian_numbers = {
        '0': '۰', '1': '۱', '2': '۲', '3': '۳', '4': '۴',
        '5': '۵', '6': '۶', '7': '۷', '8': '۸', '9': '۹'
    }
    result = ''
    for char in text:
        if char in persian_numbers:
            result += persian_numbers[char]
        else:
            result += char
    # persian_text = result.replace(",", "٬")
    return result
