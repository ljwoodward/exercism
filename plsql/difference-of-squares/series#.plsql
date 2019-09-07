CREATE OR REPLACE PACKAGE series# AS
    FUNCTION square_of_sums (p_n NUMBER) RETURN NUMBER;
    FUNCTION sum_of_squares (p_n NUMBER) RETURN NUMBER;
    FUNCTION diff_of_squares (p_n NUMBER) RETURN NUMBER;
END series#;
/

CREATE OR REPLACE PACKAGE BODY series# AS
    FUNCTION square_of_sums (p_n NUMBER) RETURN NUMBER
    IS
      v_count  NUMBER := 0;
    BEGIN
      FOR i in 1..p_n loop
          v_count := v_count + i;
      end loop;
      RETURN v_count * v_count;
    END square_of_sums;

    FUNCTION sum_of_squares (p_n NUMBER) RETURN NUMBER
    IS
      v_count  NUMBER := 0;
    BEGIN
      FOR i in 1..p_n loop
          v_count := v_count + (i * i);
      end loop;
      RETURN v_count;
    END sum_of_squares;

    FUNCTION diff_of_squares (p_n NUMBER) RETURN NUMBER
    IS
      v_count  NUMBER := 0;
    BEGIN
      v_count := abs(square_of_sums(p_n) - sum_of_squares(p_n));
      RETURN v_count;
    END diff_of_squares;
END series#;
