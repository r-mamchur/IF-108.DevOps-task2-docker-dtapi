CREATE TABLE sessions ( 
    session_id varchar(32) NOT NULL, 
    last_active int(10) unsigned NOT NULL, 
    contents text NOT NULL, 
    PRIMARY KEY (session_id)) 
    ENGINE=MyISAM DEFAULT CHARSET=utf8; 
                        
RENAME TABLE dtapi.groups TO dt_groups; 
