# RUDP Client
import socket
import sys
import time
import utils
from header import Header


IP = '127.0.0.1'
PORT = 19999
ADDRESS = (IP, PORT)
SERVERPORT = 10000
SERVERADDRESS = (IP, SERVERPORT)
MESSAGES = [line.strip() for line in open(sys.argv[1], "r").readlines()]
seqNo = utils.randInt()
ackNo = 0



def log(ctx, info):
    print(f"[{ctx}]   {info}")



def initSocket():
    sock = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)
    sock.bind(ADDRESS)
    log("INIT", "Socket INITIALISED")
    return sock



def send(sock, pl):
    sock.sendto(pl, SERVERADDRESS)

def recv(sock):
    pl, address = sock.recvfrom(1024)
    header, body = utils.fromPayload(pl)
    return (header, body, address)



def sendMsg(sock, data):
    sock.sendto(data, SERVERADDRESS)

def recvMsg(sock):
    global ackNo
    data, address = sock.recvfrom(1024)
    header, body = utils.fromPayload(data)

    if header.ack and seqNo == header.ackNo:
        ackNo += len(body)
        if header.psh:
            return (header, body, address)
        else:
            return (header, None, address)



def handshake(sock):
    global seqNo, ackNo

    SYNHeader = Header(seqNo, ackNo, syn=True)
    send(sock, SYNHeader.toBytes())
    log("HANDSHAKE", "(SYN) Sent")

    SYNACKHeader, _, servAddress = recv(sock)
    if SYNACKHeader.syn and SYNACKHeader.ack and SYNACKHeader.ackNo == seqNo + 1:
        seqNo += 1
        ackNo = SYNACKHeader.seqNo + 1
        log("HANDSHAKE", f"(SYN; ACK) Received from {servAddress}")
    else:
        raise ConnectionRefusedError
    
    ACKHeader = Header(seqNo, ackNo, ack=True)
    send(sock, ACKHeader.toBytes())
    log("HANDSHAKE", "(ACK) Sent ")
    log("HANDSHAKE", f"Connection with CLIENT {servAddress} established!")


def stop(sock):
    global seqNo, ackNo

    FINHeader = Header(seqNo, ackNo, fin=True)
    send(sock, FINHeader.toBytes())
    log("STOP", "(FIN) Sent")

    ACKHeader, _, servAddress = recv(sock)
    if ACKHeader.ack and ACKHeader.ackNo == seqNo + 1:
        seqNo += 1
        ackNo = ACKHeader.seqNo + 1
        log("STOP", f"(ACK) Received from {servAddress}")
    else:
        raise ConnectionError
    
    FINHeader, _, servAddress = recv(sock)
    if FINHeader.fin:
        log("STOP", f"(FIN) Received from {servAddress}")
    else:
        raise ConnectionError
    
    ACKHeader = Header(seqNo, ackNo, ack=True)
    send(sock, ACKHeader.toBytes())
    log("STOP", "(ACK) Sent ")
    sock.close()
    log("STOP", f"Connection with SERVER {servAddress} terminated!")



def client():
    clientSocket = initSocket()
    handshake(clientSocket)
    return clientSocket



sock = client()
sock.setblocking(0)

for body in MESSAGES:
    seqNo += len(body)
    pl = utils.toPayload(Header(seqNo, ackNo, ack=True, psh=True), body)

    received = False
    while not received:
        sendMsg(sock, pl)
        log("CLIENT", f"Sent {len(body)} bytes to SERVER")
        time.sleep(1)
        try:
            header, body, addr = recvMsg(sock)
            if body:
                log("CLIENT", f"Received (ACK) and message: '{body}' from SERVER")
            else:
                log("CLIENT", f"Received (ACK) from SERVER")
            received = True
        except socket.error:
            log("LATENCY", f"Resending PKT: {seqNo}")
            continue
    


sock.setblocking(1)
stop(sock)
sock.close()