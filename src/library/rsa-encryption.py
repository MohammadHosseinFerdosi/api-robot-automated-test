import rsa

def encrypt_message(public_key_path, message):
    with open(public_key_path, 'rb') as f:
        public_key = rsa.PublicKey.load_pkcs1(f.read())
        a = rsa.PublicKey
    encrypted_message = rsa.encrypt(message.encode(), public_key)
    return encrypted_message

def decrypt_message(private_key_path, encrypted_message):
    with open(private_key_path, 'rb') as f:
        private_key = rsa.PrivateKey.load_pkcs1(f.read())
    decrypted_message = rsa.decrypt(encrypted_message, private_key)
    return decrypted_message.decode()