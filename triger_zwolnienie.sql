CREATE  TRIGGER zwolnienie
BEFORE DELETE
   ON tbl_agenci
for each row


BEGIN
       
    insert into byli_pracownicy (  AGENT_ID, IMIE, NAZWISKO, DATA_URODZENIA, EMAIL, LOGIN, PLEC)
    VALUES (:old.agent_id, :old.IMIE, :old.Nazwisko, :old.data_urodzenia, :old.email, :old.login, :old.plec);
    

END;