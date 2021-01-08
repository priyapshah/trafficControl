from scapy.all import *
from itertools import product
from string import ascii_lowercase
import time
byte_message = bytes("Dummy packet sent", "utf-8")
opened_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

while True:
    opened_socket.sendto(byte_message, ("0.0.0.0", 5001))
