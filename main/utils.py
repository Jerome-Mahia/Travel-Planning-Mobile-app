
import secrets
import string
import requests


def google_get_access_token(code):
    # Reference: https://developers.google.com/identity/protocols/oauth2/web-server#obtainingaccesstokens
    data = {
        'code': code,
        'client_id': "139040584550-saip966ol7c2gb037bi843adh683dd0o.apps.googleusercontent.com",
        'client_secret':"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",
        'redirect_uri': 'http://127.0.0.1:5173',
        'grant_type': 'authorization_code'
        
    }

    response = requests.post('https://oauth2.googleapis.com/token', data=data)
    #print(response.json())
    if not response.ok:
        return ('Failed to obtain access token from Google.')
    #print(response)
    access_token = response.json()['access_token']

    return access_token



def google_get_user_info(access_token):
    # Reference: https://developers.google.com/identity/protocols/oauth2/web-server#callinganapi
    response = requests.get(
        'https://www.googleapis.com/oauth2/v3/userinfo',
        params={'access_token': access_token}
    )

    if not response.ok:
        return ('Failed to obtain user info from Google.')

    return response.json()


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



