CREATE OR REPLACE PACKAGE year# AS
    FUNCTION is_leap(p_year NUMBER) RETURN VARCHAR2;
END year#;
/

CREATE OR REPLACE PACKAGE BODY year# AS
    FUNCTION is_leap(p_year NUMBER) RETURN VARCHAR2
    IS
      v_leap BOOLEAN := false;
    BEGIN
      IF mod(p_year, 4) = 0 THEN
        v_leap := true;
      END IF;
      IF mod(p_year, 100) = 0 THEN
        v_leap := false;
      END IF;
      IF mod(p_year, 400) = 0 THEN
        v_leap := true;
      END IF;

      IF v_leap = true THEN
          RETURN 'Yes, ' || p_year || ' is a leap year';
      ELSE
        RETURN 'No, ' || p_year || ' is not a leap year';
      END IF;
    END is_leap;
END year#;
