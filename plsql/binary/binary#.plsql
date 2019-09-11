CREATE OR REPLACE PACKAGE binary# AS
    FUNCTION to_decimal (p_bin VARCHAR2) RETURN NUMBER;
END binary#;
/

CREATE OR REPLACE PACKAGE BODY binary# AS
    FUNCTION to_decimal (p_bin NUMBER) RETURN NUMBER
    IS
      v_bin         NUMBER := 0;
      v_total       NUMBER := 0;
      v_multiplier  NUMBER := 1;
    BEGIN
      FOR i IN 1..length(p_bin) LOOP
        CASE substr(p_bin, i * -1, 1)
          WHEN '0' THEN
            NULL;
          WHEN '1' THEN
            v_total := v_total + v_multiplier;
          ELSE
            RETURN 0;
        END CASE;
        v_multiplier := v_multiplier * 2;
      END LOOP;

      RETURN v_total;
    END to_decimal;
END binary#;
/
