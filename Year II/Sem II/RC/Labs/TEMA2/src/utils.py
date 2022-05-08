from header import *
import random as rand



def bytesToHeader(bytes):
    seqNum = int.from_bytes(bytes[0:2], 'big')
    ackNum = int.from_bytes(bytes[2:4], 'big')
    flags = bytes[4]
    syn = (flags & 1 << 0) != 0
    ack = (flags & 1 << 1) != 0
    psh = (flags & 1 << 2) != 0
    fin = (flags & 1 << 3) != 0
    return Header(seqNum, ackNum, syn, ack, psh, fin)

def bytesToBody(bytes):
    data = bytes[5:]
    if data:
        return data.decode('utf-8')
    return ''


def toPayload(header, body) -> bytes:
    h = header.toBytes()
    if body:
        b = body.encode('utf-8')
        return h + b
    return h

def fromPayload(pl):
    header = bytesToHeader(pl)
    body = bytesToBody(pl)
    return (header, body)


def randInt():
    return rand.randint(100, 50000)

def random():
    return rand.random()