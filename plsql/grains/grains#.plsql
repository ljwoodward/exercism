CREATE OR REPLACE PACKAGE grains# AS
    total constant NUMBER := 18446744073709551615;
    FUNCTION at_square(p_square NUMBER) RETURN NUMBER;
END grains#;
/

CREATE OR REPLACE PACKAGE BODY grains# AS
    FUNCTION at_square(p_square NUMBER) RETURN NUMBER
    AS
      v_res   NUMBER := 1;
    BEGIN
      IF p_square = 1 THEN
        RETURN 1;
      END IF;

      FOR i in 2..p_square LOOP
        v_res := v_res * 2;
        IF v_res > total THEN
          RAISE_APPLICATION_ERROR (-20001, 'Input too high. Try a number up to 64.');
        END IF;
      END LOOP;

      RETURN v_res;
    END at_square;
END grains#;
/
