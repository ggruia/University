set serveroutput ON;

DECLARE
    Tclob CLOB;
    Tnclob NCLOB;
    
BEGIN
    Tclob := RPAD('START', 30000, '1') || RPAD('dsadsa', 30000, '0');
    Tnclob := RPAD('S', 31000, 'ș') || RPAD('T', 31000, 'ț');
    
    DBMS_OUTPUT.PUT_LINE(length(Tclob));     -- afisez lungimea CLOB, pentru a testa daca s-a inserat corespunzator textul > 32767 chars
    DBMS_OUTPUT.PUT_LINE(length(Tnclob));    -- afisez lungimea NCLOB, pentru a testa daca s-a inserat corespunzator textul > 32767 chars
END;