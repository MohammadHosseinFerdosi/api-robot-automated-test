from faker import Faker
import random
from robot.api.deco import keyword

fake = Faker()

secure_rand = random.SystemRandom()

@keyword
def uuid4():
    """Return a random UUID version 4."""
    return fake.uuid4()

@keyword
def color_name():
    """Return a random color name."""
    return fake.color_name()

@keyword
def first_name():
    """Return a random first name."""
    return fake.first_name()

@keyword
def country():
    """Return a random country name."""
    return fake.country()

@keyword
def email():
    """Return a random email address."""
    return fake.email()

@keyword
def password(length=10, special_chars=True, digits=True, upper_case=True, lower_case=True):
    """Return a randomly generated password.

    Arguments:
    - length: Length of the password (default: 10)
    - special_chars: Include special characters (default: True)
    - digits: Include digits (default: True)
    - upper_case: Include uppercase letters (default: True)
    - lower_case: Include lowercase letters (default: True)
    """
    return fake.password(
        length=length,
        special_chars=special_chars,
        digits=digits,
        upper_case=upper_case,
        lower_case=lower_case
    )

@keyword
def username():
    """Return a random username."""
    return fake.user_name()

@keyword
def random_number(digits=1, fix_len=False):
    """
    Return a random number with the specified number of digits.

    Arguments:
    - digits: Number of digits to generate (default: 1)
    - fix_len: If True, left-pad with zeros to fix the length (default: False)

    Example:
    | ${num}=    FakerLibrary.Random Number    digits=3    fix_len=${True}
    """
    if digits < 1:
        raise ValueError("Digits must be >= 1")
    
    min_val = 10 ** (digits - 1)
    max_val = (10 ** digits) - 1

    number = secure_rand.randint(min_val, max_val)
    return f"{number:0{digits}}" if fix_len else str(number)

@keyword
def random_int(min=0, max=1000):
    """
    Return a random integer between min and max.

    Arguments:
    - min: Minimum value (default: 0)
    - max: Maximum value (default: 1000)

    Example:
    | ${num}=    FakerLibrary.Random Int    100    200
    """
    return secure_rand.randint(min, max)

@keyword
def fake_national_code():
    """
    Generates a fake national code with valid checksum using secure randomness.
    """
    lst = []
    total_sum = 0

    for i in range(10, 1, -1):
        j = secure_rand.randint(0, 9)
        lst.append(j)
        total_sum += j * i

    s = total_sum % 11
    if s < 2:
        lst.append(s)
    else:
        lst.append(11 - s)

    return ''.join(map(str, lst))

@keyword
def fake_cell_number(predefined_cell_number_prefix=None):
    """
    Generates a random Iranian cell number with prefix using secure randomness.
    """
    
    if predefined_cell_number_prefix==None:
        prefixes = ["0983", "0984", "0985", "0986", "0987", "0988"]
        rest_of_number_length = 7
    else:
        prefixes = [str(predefined_cell_number_prefix)]
        rest_of_number_length = 11 - len(str(predefined_cell_number_prefix))
        
    mobile_prefix = secure_rand.choice(prefixes)
    rest_of_number = ''.join(secure_rand.choices('0123456789', k=rest_of_number_length))
    cell_number = str(mobile_prefix) + rest_of_number

    return cell_number
