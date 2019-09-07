CREATE OR REPLACE PACKAGE numeral# AS
    FUNCTION to_roman (p_n NUMBER) RETURN  VARCHAR2;
    FUNCTION dig_to_num (p_dig NUMBER, p_group VARCHAR2) RETURN VARCHAR2;
END numeral#;
/

CREATE OR REPLACE PACKAGE BODY numeral# AS
    FUNCTION to_roman (p_n NUMBER) RETURN  VARCHAR2
    IS
      v_ones        NUMBER;
      v_tens        NUMBER;
      v_hundreds    NUMBER;
      v_thousands   NUMBER;
      v_numerals    VARCHAR2(100) := '';
      over_4000     EXCEPTION;
    BEGIN
      v_ones := mod(p_n, 10);
      v_tens := mod(p_n - v_ones, 100);
      v_hundreds := mod(p_n - v_ones - v_tens, 1000);
      v_thousands := mod(p_n - v_ones - v_tens - v_hundreds, 10000);
      v_tens := v_tens / 10;
      v_hundreds := v_hundreds / 100;
      v_thousands := v_thousands / 1000;

      -- Thousands
      IF v_thousands > 3 THEN
        RAISE over_4000;
      ELSIF v_thousands > 0 THEN
      -- Don't need to go above 3,000
        FOR i IN 1..v_thousands LOOP
          v_numerals := v_numerals ||'M';
        END LOOP;
      END IF;

      v_numerals := v_numerals || dig_to_num(v_hundreds, 'H') || dig_to_num(v_tens, 'T') || dig_to_num(v_ones, 'O');

      RETURN v_numerals;
    EXCEPTION
      WHEN over_4000 THEN
        dbms_output.put_line('Number too high, please use a number under 4000');
        RETURN NULL;
    END to_roman;

    FUNCTION dig_to_num (p_dig NUMBER, p_group VARCHAR2) RETURN VARCHAR2
    IS
      v_dig NUMBER := p_dig;
      v_one CHAR;
      v_five CHAR;
      v_ten CHAR;
      v_num VARCHAR2(20) := '';
      wrong_group EXCEPTION;
    BEGIN
      CASE p_group
        WHEN 'O' THEN
          v_one := 'I';
          v_five := 'V';
          v_ten := 'X';
        WHEN 'T' THEN
          v_one := 'X';
          v_five := 'L';
          v_ten := 'C';
        WHEN 'H' THEN
          v_one := 'C';
          v_five := 'D';
          v_ten := 'M';
        ELSE
          v_num := '?';
          RAISE wrong_group;
      END CASE;

      CASE
        WHEN p_dig =  9 THEN
          v_num := v_num || v_one || v_ten;
        WHEN p_dig > 4 THEN
          v_num := v_num || v_five;
          v_dig := p_dig - 5;
          FOR i IN 1..v_dig LOOP
            v_num := v_num || v_one;
          END LOOP;
        WHEN p_dig = 4 THEN
          v_num := v_num || v_one || v_five;
        WHEN p_dig < 4 THEN
          FOR i IN 1..p_dig LOOP
              v_num := v_num || v_one;
          END LOOP;
        END CASE;

      RETURN v_num;
    EXCEPTION
      WHEN wrong_group THEN
        dbms_output.put_line('Wrong Group name given. Use ''O'' for Ones, ''T''' ||
          'for Tens, or ''H'' for Hundreds.');
        RETURN NULL;
    END dig_to_num;
END numeral#;
