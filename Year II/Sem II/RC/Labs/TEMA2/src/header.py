class Header:
    length = 5

    def __init__(self, seqNo, ackNo=0, syn=False, ack=False, psh=False, fin=False):
        self.seqNo = seqNo
        self.ackNo = ackNo
        self.syn = syn
        self.ack = ack
        self.psh = psh
        self.fin = fin

    def __repr__(self):
        rep = "Header:\n"
        rep += f"nums [seqNo = {self.seqNo}, ackNo = {self.ackNo}]\n"
        flags = []
        if self.syn:
            flags.append("SYN")
        if self.ack:
            flags.append("ACK")
        if self.psh:
            flags.append("PSH")
        if self.fin:
            flags.append("FIN")
        rep += f"flags [{self.flags()}]\n"
        return rep
    
    def flags(self):
        flags = []
        if self.syn:
            flags.append("SYN")
        if self.ack:
            flags.append("ACK")
        if self.psh:
            flags.append("PSH")
        if self.fin:
            flags.append("FIN")
        return ", ".join(flags)


    def toBytes(self) -> bytes:
        seqNo = self.seqNo.to_bytes(2, 'big')
        ackNo = self.ackNo.to_bytes(2, 'big')
        flagString = "".join(['1' if flg else '0' for flg in reversed([self.syn, self.ack, self.psh, self.fin])]).rjust(8, "0")
        flags = int(flagString, base=2).to_bytes(1, 'big')
        return seqNo + ackNo + flags