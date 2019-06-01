
CREATE OR REPLACE FUNCTION sp_znajdz (agent_id in number, miesiac in string) RETURN NUMBER
is liczbaZgloszen NUMBER;
BEGIN
    

    SELECT COUNT(*) INTO liczbaZgloszen FROM TBL_ZGLOSZENIA WHERE AGENT_ID = 3 AND to_char(czas_rozp_zgloszenia, 'yyyy-mm') = miesiac;
    Return liczbazgloszen;
END sp_znajdz;
/


CREATE OR REPLACE FUNCTION licz_skutecznosc (identyfikator in number, miesiac in string) RETURN NUMBER IS
   
skutecznosc number;
rozwiazane number;
nierozwiazane number;

BEGIN
select count(*) into rozwiazane from tbl_zgloszenia 
where rozwiazane_przez_agenta_przyjm = 1
and agent_id = identyfikator and TO_CHAR(czas_rozp_zgloszenia, 'YYYY-MM') = miesiac;

select count(*) into nierozwiazane from tbl_zgloszenia 
WHERE agent_id = identyfikator and TO_CHAR(czas_rozp_zgloszenia, 'YYYY-MM') = miesiac;

skutecznosc := rozwiazane / nierozwiazane;

RETURN skutecznosc;

END licz_skutecznosc;
/




create or replace PROCEDURE ewaluuj2018 AS

k_agent_id tbl_agenci.agent_id%type;
cursor agent_id_cur IS
Select agent_id into k_agent_id from tbl_agenci order by agent_id;

liczba_agentow number;
miesiactxt varchar(12);
miesiac date;
miekal varchar(7);

BEGIN


    open agent_id_cur;

   loop
        FETCH agent_id_cur INTO k_agent_id;
        exit when agent_id_cur%NOTFOUND;

        for j in 1..12 loop

            miesiactxt := '2018-'||j||'-01';
            miesiac := to_date(miesiactxt, 'yyyy-dd-mm');
            miekal := to_char(miesiac, 'yyyy-mm');

           insert into tbl_ewaluacje (ewaluacja_id,typ_ewaluacji, agent_id, ocena, data_ewaluacji) 
           values (TBL_EWALUACJE_EWALUACJA_ID_SEQ.nextval,1, k_agent_id , licz_skutecznosc(k_agent_id, miekal), miesiac);
        end loop;



    end loop;



END;
/
CREATE OR REPLACE TRIGGER zwolnienie
BEFORE DELETE
   ON tbl_agenci
for each row


BEGIN
       
    insert into TBL_byli_pracownicy (  AGENT_ID, PLEC_ID, IMIE, NAZWISKO, DATA_URODZENIA, EMAIL, LOGIN )
    VALUES (:old.agent_id,:old.plec_id, :old.IMIE, :old.Nazwisko, :old.data_urodzenia, :old.email, :old.login );   

END;
/
create or replace TRIGGER nieobecnosc
BEFORE DELETE
   ON tbl_grafik
for each row


BEGIN
INSERT INTO tbl_nieobecnosci (
    nieobenosc_id,
    agent_id,
    absencja_id,
    data_nieobecnosci,
    liczba_godzin
) VALUES (
    TBL_NIEOBECNOSCI_NIEOBENOSC512.nextval,
    :old.agent_id,
    10,
    cast(:old.data_roz_zmiany as date),
    extract( hour from (:old.data_zak_zmiany - :old.data_roz_zmiany))
);
 END;

create or replace TRIGGER przerwaKoniecZm
AFTER INSERT
   ON tbl_przerwy
for each row

DECLARE 

dataZmiany varchar2(30);

BEGIN

    select data_zak_zmiany 
    into dataZmiany
    from tbl_grafik 
    where  agent_id = :new.agent_id and trunc(cast(data_zak_zmiany as date)) = trunc(cast(:new.czas_zak_przerwy as date));

if dataZmiany < :new.czas_zak_przerwy then
    
    update tbl_przerwy
    set
        czas_zak_przerwy = dataZmiany 
    where  :new.przerwa_id = przerwa_id;
    
end IF;

END;
/

create or replace TRIGGER anulowanie
BEFORE DELETE
   ON tbl_zgloszenia
for each row


BEGIN

    INSERT INTO tbl_anulowane (
    zgloszenie_id,
    agent_id,
    czas_rozp_zgloszenia,
    czas_zak_zgloszenia,
    status_zgloszenia,
    rozwiazane_przez_agenta_przyjm
) VALUES (
    :old.zgloszenie_id,
    :old.agent_id,
    :old.czas_rozp_zgloszenia,
    :old.czas_zak_zgloszenia,
    :old.status_zgloszenia,
    :old.rozwiazane_przez_agenta_przyjm
);
END;
/
CREATE OR REPLACE VIEW SUMA_SPOZNIEN AS 
  SELECT 
    ag.imie
    ,ag.nazwisko
    ,NUMTODSINTERVAL(SUM(EXTRACT(DAY FROM lo.godzina_zdarzenia - gr.data_roz_zmiany)), 'DAY') +
       NUMTODSINTERVAL(SUM(EXTRACT(HOUR FROM lo.godzina_zdarzenia - gr.data_roz_zmiany)), 'HOUR') +
       NUMTODSINTERVAL(SUM(EXTRACT(MINUTE FROM lo.godzina_zdarzenia - gr.data_roz_zmiany)), 'MINUTE') +
       NUMTODSINTERVAL(SUM(EXTRACT(SECOND FROM lo.godzina_zdarzenia - gr.data_roz_zmiany)), 'SECOND') AS "Przekroczenie"
    , to_char(gr.data_roz_zmiany, 'YYYY-MM') AS Miesiac
   
FROM 
    TBL_AGENCI ag
    INNER JOIN 
    TBL_LOGOWANIA lo ON ag.agent_id = lo.agent_id
    INNER JOIN
    TBL_GRAFIK gr ON lo.agent_id = gr.agent_id and trunc(cast(lo.godzina_zdarzenia as date)) = trunc(cast(gr.data_roz_zmiany as date))

WHERE lo.zdarzenie = 1
AND lo.godzina_zdarzenia - gr.data_roz_zmiany > NUMTODSINTERVAL(0, 'minute')
group by ag.nazwisko, ag.imie, to_char(gr.data_roz_zmiany, 'YYYY-MM')
oRDER BY AG.NAZWISKO, to_char(gr.data_roz_zmiany, 'YYYY-MM');

/


  CREATE OR REPLACE FORCE VIEW SPOZNIENIA AS 
  SELECT 
    ag.imie
    ,ag.nazwisko
    ,lo.godzina_zdarzenia - gr.data_roz_zmiany as Spoznienie
    ,ag.agent_id
    ,lo.godzina_zdarzenia
    ,gr.data_roz_zmiany
    ,gr.data_zak_zmiany
    ,lo.id_logowania
    
FROM 
    TBL_AGENCI ag
    INNER JOIN 
    TBL_LOGOWANIA lo ON ag.agent_id = lo.agent_id
    INNER JOIN
    TBL_GRAFIK gr ON lo.agent_id = gr.agent_id and trunc(cast(lo.godzina_zdarzenia as date)) = trunc(cast(gr.data_roz_zmiany as date))
WHERE lo.zdarzenie = 1
AND lo.godzina_zdarzenia - gr.data_roz_zmiany > NUMTODSINTERVAL(0, 'minute')
ORDER BY lo.godzina_zdarzenia;

/


  CREATE OR REPLACE VIEW CZAS_PRACY AS 
  SELECT 
      ag.nazwisko
     ,ag.imie
   , NUMTODSINTERVAL(SUM(EXTRACT(DAY FROM zg.czas_zak_zgloszenia - zg.czas_rozp_zgloszenia)), 'DAY') +
       NUMTODSINTERVAL(SUM(EXTRACT(HOUR FROM zg.czas_zak_zgloszenia - zg.czas_rozp_zgloszenia)), 'HOUR') +
       NUMTODSINTERVAL(SUM(EXTRACT(MINUTE FROM zg.czas_zak_zgloszenia - zg.czas_rozp_zgloszenia)), 'MINUTE') +
       NUMTODSINTERVAL(SUM(EXTRACT(SECOND FROM zg.czas_zak_zgloszenia - zg.czas_rozp_zgloszenia)), 'SECOND') AS "Czas pracy"
        ,to_char(zg.czas_rozp_zgloszenia, 'YYYY-MM') as Miesiac


FROM tbl_zgloszenia zg
INNER JOIN tbl_agenci ag On ag.agent_id = zg.agent_id
Group by ag.nazwisko, ag.imie, to_char(zg.czas_rozp_zgloszenia, 'YYYY-MM');

Create or replace FUNCTION CZY_PREMIA_2018 (ag_id in number) RETURN STRING
is 
rezultat VARCHAR(150) := 'Premia nie przyznana';
liczba_zgloszen NUMBER;

BEGIN      
    SELECT COUNT(ZGLOSZENIE_ID) INTO liczba_zgloszen FROM TBL_ZGLOSZENIA WHERE AGENT_ID = ag_id AND TO_cHAR(czas_rozp_zgloszenia, 'YYYY') = '2018'; 
               
    IF (liczba_zgloszen) > 1800 then            
            rezultat := 'Premia przyznana';
    Else
   
            rezultat := 'Premia nie przyznana';
   
    End if;

    RETURN rezultat;

END czy_premia_2018;
/
