
import re
import hashlib

def is_valid_email(email):
    email_regex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(email_regex, email) is not None



def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()


def is_strong_password(password):
    if len(password) < 8:
        return False
    if not re.search(r'[A-Z]', password):
        return False
    if not re.search(r'[a-z]', password):
        return False
    if not re.search(r'[0-9]', password):
        return False
    if not re.search(r'[\W_]', password):
        return False
    return True

# create function to write to a file called log.txt
def log_message(message):
    import os
    log_file = os.path.join(os.path.dirname(__file__), 'log.txt')
    try:
        with open(log_file, 'a') as f:
            f.write(message + '\n')
    except IOError as e:
        print(f"Error writing to log file: {e}")
