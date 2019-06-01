
CREATE SEQUENCE TBL_EWALUACJE_TYP_TYP_ID_SEQ;

CREATE TABLE tbl_ewaluacje_typ (
                typ_id NUMBER NOT NULL,
                nazwa_ewaluacji VARCHAR2(200) NOT NULL,
                CONSTRAINT EWALUACJA_ID PRIMARY KEY (typ_id)
);

--DONE


CREATE SEQUENCE TBL_ABSENCJE_ABSENCJA_ID_SEQ;

CREATE TABLE tbl_absencje (
                absencja_id NUMBER NOT NULL,
                absencja VARCHAR2(200) NOT NULL,
                CONSTRAINT ABSENCJA_ID PRIMARY KEY (absencja_id)
);
--DONE

CREATE SEQUENCE TBL_AGENCI_AGENT_ID_SEQ;

CREATE TABLE tbl_agenci (
                agent_ID NUMBER NOT NULL,
                imie VARCHAR2(200) NOT NULL,
                nazwisko VARCHAR2(200) NOT NULL,
                data_urodzenia DATE NOT NULL,
                email VARCHAR2(200) NOT NULL,
                login VARCHAR2(200) NOT NULL,
                plec NUMBER NOT NULL,
                CONST_RAINT AGENT_ID PRIMARY KEY (agent_ID)
);


CREATE SEQUENCE TBL_LOGOWANIA_ID_LOGOWANIA_SEQ;

CREATE TABLE tbl_logowania (
                id_logowania VARCHAR2(200) NOT NULL,
                agent_id NUMBER NOT NULL,
                czas_zdarzenia DATE NOT NULL,
                zdarzenie NUMBER NOT NULL,
                CONSTRAINT ID_LGOWANIA PRIMARY KEY (id_logowania, agent_id)
);


CREATE SEQUENCE TBL_ZGLOSZENIA_ZGLOSZENIE_I88;

CREATE TABLE tbl_zgloszenia (
                zgloszenie_ID NUMBER NOT NULL,
                agent_ID NUMBER NOT NULL,
                czas_rozp_zgloszenia DATE NOT NULL,
                czas_zak_zgloszenia DATE NOT NULL,
                status_zgloszenia NUMBER NOT NULL,
                rozwiazane_przez_agenta_przyjm NUMBER,
                CONSTRAINT ZGLOSZENIE_ID PRIMARY KEY (zgloszenie_ID, agent_ID)
);

CREATE SEQUENCE TBL_EWALUACJE_EWALUACJE_ID;



CREATE TABLE tbl_ewaluacje (
                ewaluacja_id NUMBER NOT NULL,
                agent_id NUMBER NOT NULL,
                typ_ewaluacji NUMBER NOT NULL,
                ocena FLOAT NOT NULL,
                CONSTRAINT EWALUACJA_ID PRIMARY KEY (ewaluacja_id, agent_id)
);


CREATE SEQUENCE TBL_NIEOBECNOSCI_NIEOBENOSC512;

CREATE TABLE tbl_nieobecnosci (
                nieobenosc_id NUMBER NOT NULL,
                agent_id NUMBER NOT NULL,
                absencja_id NUMBER NOT NULL,
                data_nieobecnosci DATE NOT NULL,
                liczba_godzin NUMBER NOT NULL,
                CONSTRAINT NIEOBECNOSC_ID PRIMARY KEY (nieobenosc_id, agent_id, absencja_id)
);


CREATE SEQUENCE TBL_PRZERWY_PRZERWA_ID_SEQ;

CREATE TABLE tbl_przerwy (
                przerwa_id NUMBER NOT NULL,
                agent_id NUMBER NOT NULL,
                czas_rozp_przerwy DATE NOT NULL,
                czas_zak_przerwy DATE NOT NULL,
               
                CONSTRAINT PRZERWA_ID PRIMARY KEY (przerwa_id, agent_id)
);


CREATE SEQUENCE TBL_GRAFIK_ZMIANA_ID_SEQ;

CREATE TABLE tbl_grafik (
                zmiana_id NUMBER NOT NULL,
                agent_ID NUMBER NOT NULL,
                data_rozp_zmiany DATE NOT NULL,
                data_zak_zmiany DATE,
                czas_trwania DATE NOT NULL,
                CONSTRAINT ZMIANA_ID PRIMARY KEY (zmiana_id, agent_ID)
);


ALTER TABLE tbl_ewaluacje ADD CONSTRAINT TBL_EWALUACJE_TYP_TBL_EWALU791
FOREIGN KEY (typ_id)
REFERENCES tbl_ewaluacje_typ (typ_id)
NOT DEFERRABLE;

ALTER TABLE tbl_nieobecnosci ADD CONSTRAINT TBL_ABSENCJE_TBL_NIEOBECNOS883
FOREIGN KEY (absencja_id)
REFERENCES tbl_absencje (absencja_id)
NOT DEFERRABLE;

ALTER TABLE tbl_grafik ADD CONSTRAINT TBL_AGENCI_TBL_GRAFIK_FK
FOREIGN KEY (agent_ID)
REFERENCES tbl_agenci (agent_ID)
NOT DEFERRABLE;

ALTER TABLE tbl_przerwy ADD CONSTRAINT TBL_AGENCI_TBL_PRZERWY_FK
FOREIGN KEY (agent_id)
REFERENCES tbl_agenci (agent_ID)
NOT DEFERRABLE;

ALTER TABLE tbl_nieobecnosci ADD CONSTRAINT TBL_AGENCI_TBL_NIEOBECNOSCI_FK
FOREIGN KEY (agent_id)
REFERENCES tbl_agenci (agent_ID)
NOT DEFERRABLE;

ALTER TABLE tbl_ewaluacje ADD CONSTRAINT TBL_AGENCI_TBL_EWALUACJE_FK
FOREIGN KEY (agent_id)
REFERENCES tbl_agenci (agent_ID)
NOT DEFERRABLE;

ALTER TABLE tbl_zgloszenia ADD CONSTRAINT TBL_AGENCI_TBL_ZGLOSZENIA_FK
FOREIGN KEY (agent_ID)
REFERENCES tbl_agenci (agent_ID)
NOT DEFERRABLE;

ALTER TABLE tbl_logowania ADD CONSTRAINT TBL_AGENCI_TBL_LOGOWANIA_FK
FOREIGN KEY (agent_id)
REFERENCES tbl_agenci (agent_ID)
NOT DEFERRABLE;

CREATE TABLE tbl_plec (
    plec_id NUMBER not null,
    plec varchar2(200) not null,
    Constraint plec_id Primary key (plec_id)


);


