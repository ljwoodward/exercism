CREATE OR REPLACE PACKAGE raindrops# AS
    FUNCTION convert (p_amt NUMBER) RETURN VARCHAR2;
END raindrops#;
/

CREATE OR REPLACE PACKAGE BODY raindrops# AS
    FUNCTION convert (p_amt NUMBER) RETURN VARCHAR2
    IS
      v_text VARCHAR2(15) := '';
    BEGIN
      IF mod(p_amt, 3) = 0 THEN
        v_text := v_text || 'Pling';
      END IF;
      IF mod(p_amt, 5) = 0 THEN
        v_text := v_text || 'Plang';
      END IF;
      IF mod(p_amt, 7) = 0 THEN
        v_text := v_text || 'Plong';
      END IF;
      IF substr(v_text, 1, 1) = 'P' THEN
        RETURN v_text;
      ELSE
        RETURN to_char(p_amt);
      END IF;
    END;
END raindrops#;
