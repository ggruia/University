# RUDP Server
import socket
import utils
from header import Header


IP = '127.0.0.1'
PORT = 10000
ADDRESS = (IP, PORT)
PACKETLOSS = 0.4
seqNo = utils.randInt()
ackNo = 0



def log(ctx, info):
    print(f"[{ctx}]   {info}")



def initSocket():
    sock = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)
    sock.bind(ADDRESS)
    log("INIT", "Socket INITIALISED")
    return sock



def send(sock, addr, data):
    sock.sendto(data, addr)

def recv(sock):
    data, address = sock.recvfrom(1024)
    header, body = utils.fromPayload(data)
    return (header, body, address)



def sendMsg(sock, addr, data):
    if utils.random() > PACKETLOSS:
        sock.sendto(data, addr)

def recvMsg(sock):
    global ackNo
    data, address = sock.recvfrom(1024)
    header, body = utils.fromPayload(data)

    if header.fin:
        return (header, None, address)

    if header.seqNo <= ackNo:
        pl = utils.toPayload(Header(seqNo, ackNo, ack=True, psh=True), "OK")
        log("LATENCY", f"Resending confirmation for PKT: {header.seqNo}")
        sendMsg(sock, address, pl)
        return None


    if utils.random() > PACKETLOSS:
        if header.ack and seqNo == header.ackNo:
            ackNo += len(body)
            if header.psh:
                return (header, body, address)
            else:
                return (header, None, address)
    else:
        return None



def handshake(sock):
    global seqNo, ackNo

    SYNHeader, _, clnAddress = recv(sock)
    if SYNHeader.syn:
        ackNo = SYNHeader.seqNo + 1
        log("HANDSHAKE", f"(SYN) Received from {clnAddress}")
    else:
        raise ConnectionRefusedError

    SYNACKHeader = Header(seqNo, ackNo, syn=True, ack=True)
    send(sock, clnAddress, SYNACKHeader.toBytes())
    log("HANDSHAKE", "(SYN; ACK) Sent")

    ACKHeader, _, clnAddress = recv(sock)
    if ACKHeader.ack and ACKHeader.ackNo == seqNo + 1:
        seqNo += 1
        ackNo = ACKHeader.seqNo
        log("HANDSHAKE", f"(ACK) Received from {clnAddress}")
        log("HANDSHAKE", f"Connection with CLIENT {clnAddress} established!")
    else:
        raise ConnectionRefusedError


def stop(sock, header, addr):
    global seqNo, ackNo

    FINHeader = header
    clnAddress = addr
    if FINHeader.fin:
        ackNo = FINHeader.seqNo + 1
        log("STOP", f"(FIN) Received from {clnAddress}")
    else:
        raise ConnectionError

    ACKHeader = Header(seqNo, ackNo, ack=True)
    send(sock, clnAddress, ACKHeader.toBytes())
    log("STOP", "(ACK) Sent")

    FINHeader = Header(seqNo, ackNo, fin=True)
    send(sock, clnAddress, FINHeader.toBytes())
    log("STOP", "(FIN) Sent")

    ACKHeader, _, clnAddress = recv(sock)
    if ACKHeader.ack and ACKHeader.ackNo == seqNo + 1:
        seqNo += 1
        ackNo = ACKHeader.seqNo
        log("STOP", f"(ACK) Received from {clnAddress}")
        sock.close()
        log("STOP", f"Connection with CLIENT {clnAddress} terminated!")
    else:
        raise ConnectionError



def server():
    serverSocket = initSocket()
    handshake(serverSocket)
    return serverSocket


sock = server()

while True:
    log("SERVER", "Listening . . .")
    received = False
    header = body = addr = None
    while not received:
        pck = recvMsg(sock)
        if pck:
            header, body, addr = pck
            received = True

    if header.fin:
        stop(sock, header, addr)
        break
    
    if body:
        log("SERVER", f"Received (ACK) and data: '{body}' from CLIENT")
    else:
        log("SERVER", f"Received (ACK) from CLIENT")
    
    seqNo += 2
    data = utils.toPayload(Header(seqNo, ackNo, ack=True, psh=True), "OK")
    sendMsg(sock, addr, data)
    log("SERVER", f"Sent confirmation to CLIENT")