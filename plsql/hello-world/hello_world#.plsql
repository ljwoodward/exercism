CREATE OR REPLACE PACKAGE hello_world# IS
   FUNCTION hello(
      i_name                                        varchar2 := ''
   ) 
      RETURN varchar2;

END hello_world#;
/

CREATE OR REPLACE PACKAGE BODY hello_world# IS
   FUNCTION hello(
      i_name                                        varchar2 := ''
   ) 
      RETURN varchar2
   AS
     v_result VARCHAR2(100) := 'Hello, World!';
   BEGIN
      IF length(i_name) > 0
        THEN v_result := 'Hello, ' || i_name || '!';
      END IF;
      RETURN v_result;
   END hello;
END hello_world#;
/
