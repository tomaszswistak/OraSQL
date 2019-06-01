BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                     FROM user_objects
                    WHERE object_type IN
                             ('TABLE',
                              'VIEW',
                              'PACKAGE',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'SYNONYM',
                              'PACKAGE BODY'
                             ))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE' and 
         cur_rec.object_name = 'TBL_ABSENCJE'	OR
cur_rec.object_name = 'TBL_AGENCI'		OR    
cur_rec.object_name = 'TBL_ANULOWANE'	OR 
cur_rec.object_name = 'TBL_BYLI_PRACO'	OR 
cur_rec.object_name = 'TBL_EWALUACJE'	OR 
cur_rec.object_name = 'TBL_EWALUACJE_TYP' OR
cur_rec.object_name = 'TBL_GRAFIK'		OR    
cur_rec.object_name = 'TBL_LOGOWANIA'	OR 
cur_rec.object_name = 'TBL_NIEOBECNOS'	OR 
cur_rec.object_name = 'TBL_PLEC'		OR    
cur_rec.object_name = 'TBL_PRZERWY'		OR    
cur_rec.object_name = 'TBL_ZDARZENIA'	OR 
cur_rec.object_name = 'TBL_ZGLOSZENIA' 
         
         
         THEN
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         ELSE
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '"';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (   'FAILED: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
END;
/