DECLARE



ag_id tbl_logowania.agent_id%type;
go_zda tbl_logowania.godzina_zdarzenia%type;

cursor c_logowania IS SELECT agent_Id, godzina_zdarzenia into ag_id, go_zda from tbl_logowania where zdarzenie = 1;

ilTick Number;
Datawyj TIMESTAMP;
dataPocz TIMESTAMP;
dataKonc TIMESTAMP;
zakrMinut NUMBER;
randMin NUMBER;
controler NUMBER;


BEGIN

    OPEN c_logowania;
    loop
    
    
        FETCH c_logowania INTO ag_id, go_zda;
        EXIT WHEN c_logowania%NOTFOUND;
        ilTick := floor(dbms_random.value(5, 15));
        dataWyj := go_zda;
         
        
        
            
            
        
        for i In 1..ilTick loop
        
            zakrMinut := 60 / ilTick;
            randMin := (dbms_random.value(5, zakrMinut));
            
            dataPocz := datawyj  + NUMTODSINTERVAL(dbms_random.value(2, 7), 'MINUTE') ;
            dataKonc := dataPocz + NUMTODSINTERVAL(randMin, 'MINUTE') ;
            datawyj := dataKonc;
            
            
         INSERT 
         INTO TBL_ZGLOSZENIA(ZGLOSZENIE_ID, AGENT_ID, CZAS_ROZP_ZGLOSZENIA, CZAS_ZAK_ZGLOSZENIA, STATUS_ZGLOSZENIA , ROZWIAZANE_PRZEZ_AGENTA_PRZYJM) 
         Values (
         TBL_ZGLOSZENIA_ZGLOSZENIE_I88.NEXTVAL, ag_id,dataPocz,dataKonc,floor(dbms_random.value(1, 3)),floor(dbms_random.value(0, 2)));   
        
            commit;
   
        
       
        
        end Loop;
    
    
    
    end loop;
END;