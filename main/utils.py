
import secrets
import string
import requests


def createPassword():
    letters = string.ascii_letters
    digits = string.digits
    special_chars = string.punctuation
    alphabet = letters + digits + special_chars
    pwd_length = 8
    pwd = ''
    for i in range(pwd_length):
        pwd += ''.join(secrets.choice(alphabet))

    return pwd


def createCode():  
    digits = string.digits
    pwd_length = 6
    code = ''
    for i in range(pwd_length):
        code += ''.join(secrets.choice(digits))

    return code



