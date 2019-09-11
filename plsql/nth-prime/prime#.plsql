CREATE OR REPLACE PACKAGE prime#
IS
  FUNCTION nth(p_n NUMBER) RETURN NUMBER;
  FUNCTION is_prime (p_n NUMBER) RETURN BOOLEAN;
  invalid_argument_error EXCEPTION;
END prime#;
/

CREATE OR REPLACE PACKAGE BODY prime#
IS
  FUNCTION nth(p_n NUMBER) RETURN NUMBER
  IS
    v_count NUMBER := 0;
    v_num   NUMBER := 0;
  BEGIN
    IF p_n <= v_count THEN
      RAISE invalid_argument_error;
    END IF;

    WHILE v_count < p_n LOOP
      v_num := v_num + 1;
      IF is_prime(v_num) THEN
        v_count := v_count + 1;
      END IF;

    END LOOP;
    RETURN v_num;

  EXCEPTION
    WHEN invalid_argument_error THEN
      dbms_output.put_line('Please enter an integer above 0');
      RAISE;
  END nth;

  FUNCTION is_prime (p_n NUMBER) RETURN BOOLEAN
  IS
    v_i NUMBER := 5;
  BEGIN
    IF p_n <= 1 THEN
      RETURN FALSE;
    ELSIF p_n <= 3 THEN
      RETURN TRUE;
    ELSIF mod(p_n, 2) = 0 OR mod(p_n, 3) = 0 THEN
      RETURN FALSE;
    END IF;

    WHILE v_i * v_i <= p_n LOOP
      IF mod(p_n, v_i) = 0 OR mod(p_n, v_i + 2) = 0 THEN
        RETURN FALSE;
      END IF;
      v_i := v_i + 6;
    END LOOP;

    RETURN TRUE;

  END is_prime;

end prime#;
/
