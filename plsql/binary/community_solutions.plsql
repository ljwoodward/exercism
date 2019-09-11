-- 1.

create or replace package binary#
is
    function to_decimal         (binary_string varchar2) return pls_integer;
    function to_dec_loop        (binary_string varchar2) return pls_integer;
    function to_dec_bin_to_num  (binary_string varchar2) return pls_integer;
end binary#;
/

create or replace package body binary#
is
    function to_dec_loop (binary_string varchar2)
    return pls_integer
    is
        digit   varchar2(1);
        answer  pls_integer := 0;
        i       pls_integer;
    begin
        for i in 1 .. length(nvl(binary_string, '')) loop
            digit := substr(binary_string, i, 1);
            answer := answer * 2;
            if digit = '1' then
                answer := answer + 1;
            elsif digit <> '0' then
                -- invalid binary digit
                return 0;
            end if;
        end loop;

        return answer;

    exception when others then raise;
    end to_dec_loop;

    -- https://stackoverflow.com/a/49718779/7552
    function to_dec_bin_to_num (binary_string varchar2)
    return pls_integer
    is
        vector      varchar2(255);
        answer      pls_integer;
    begin

        vector := replace(replace(nvl(binary_string, ''), '1', '1,'), '0', '0,');
        vector := trim(trailing ',' from vector);
        execute immediate 'select bin_to_num(' || vector || ') from dual' into answer;
        return answer;

    exception when others then
        if SQLCODE in (-904, -1428) then
            -- ORA-00904: "invalid identifier" -- non-digit in vector
            -- ORA-01428: "out of range" error -- vector contains number not 1 or 0
            return 0;
        else
            raise;
        end if;
    end to_dec_bin_to_num;

    --
    function to_decimal (binary_string varchar2)
    return pls_integer
    is
    begin
        --return to_dec_loop(binary_string);
        return to_dec_bin_to_num(binary_string);
    exception when others then raise;
    end to_decimal;
end binary#;
/



-- 2.

create or replace package BINARY# as

function to_decimal (
    i_binary in varchar2 )
    return pls_integer;

end;
/

create or replace package body "BINARY#" is
function TO_DECIMAL(       I_BINARY IN VARCHAR2
) return PLS_INTEGER

as
result PLS_INTEGER := 0;
curr_char varchar2(1);
begin
 for i in 1 .. length(i_binary) loop
   curr_char := substr(i_binary,i,1);
   if curr_char = '1' then
     result := result + power(2, length(i_binary)-i);
   elsif curr_char != '0' then
     return 0;
   end if;
 end loop;
 return result;
end TO_DECIMAL;

end "BINARY#";
/



-- 3.

create or replace package binary#
is
  --+--------------------------------------------------------------------------+
  -- Convert a binary number, represented as a string (e.g. '101010'),
  -- to its decimal equivalent
  --+--------------------------------------------------------------------------+

  function to_decimal (
    binary_string                             varchar2
  ) return pls_integer;


end binary#;
/

create or replace package body binary#
is
   function to_decimal (
    binary_string                             varchar2
  ) return pls_integer
  as
   l_binary_string                            varchar2(32000 char) := binary_string;
   l_decimal                                  pls_integer := 0;
   l_current_char                             char(1);

  begin
     while length(l_binary_string) >= 1
     loop
        l_decimal := l_decimal * 2; -- moving one char in binary string means multiplication by 2
        l_current_char := substr(l_binary_string,1,1);
        l_binary_string := substr(l_binary_string,2);
        if l_current_char = '1'
        then
           l_decimal := l_decimal + l_current_char; -- add current char, if '1'
        elsif l_current_char != '0'
        then
            return 0;
        end if;
     end loop;

     return l_decimal;

  exception
     when others
       then raise;
  end to_decimal;


end binary#;
/



-- 4.

cREATE OR REPLACE PACKAGE binary# AS
  ----------------------------------------
  -- Declaration:
  --   Public Functions.
  ----------------------------------------
  ----------------------------------------
  -- to_decimal:
  --  Convert a binary number, represented
  --  as a string (e.g. '101010'), to its
  --  decimal
  --
  --   p_number: the square
  ----------------------------------------
  FUNCTION to_decimal (
    p_binary IN VARCHAR2)
  RETURN NUMBER;
END binary#;
/

CREATE OR REPLACE PACKAGE BODY binary# AS
  ----------------------------------------
  -- Implementation:
  --   Public Functions.
  ----------------------------------------
  ----------------------------------------
  -- to_decimal:
  --  Convert a binary number, represented
  --  as a string (e.g. '101010'), to its
  --  decimal
  --
  --   p_number: the square
  ----------------------------------------
  FUNCTION to_decimal (
    p_binary IN VARCHAR2)
  RETURN NUMBER IS
    v_binary VARCHAR2(512 CHAR);

    v_result NUMBER(11, 0);
  BEGIN
    v_binary := TRIM(p_binary);

    IF (v_binary IS NULL) THEN
      RETURN(0);
    ELSIF (v_binary IS NULL) THEN
      RETURN(0);
    ELSIF (NOT (REGEXP_LIKE(v_binary, '^[0-1]*$'))) THEN
      RETURN(0);
    END IF;

    v_result := 0;

    FOR i IN 1..LENGTH(v_binary) LOOP
      v_result := (v_result * 2) + TO_NUMBER(SUBSTR(v_binary, i, 1));
    END LOOP;

    RETURN(v_result);
  END to_decimal;
END binary#;
/



-- 5.

create or replace function "BIN_TO_DEC"
(binnum in VARCHAR2)
return NUMBER
is
    bn varchar2(32);
    b varchar2(1);
    dnum number;
    n number;
begin
    dnum := 0;
    bn := binnum;
    n  := 1;
    while (length(bn)>=1)
    loop
        b := substr(bn,length(bn),1);
        bn := substr(bn,1,length(bn)-1);
        if b = '1'
        then
            dnum := dnum + power(2,n-1);
        elsif b = '0'
        then
            dnum := dnum + 0;
        else
            dnum := 0;
            exit;
        end if;
        n := n + 1;
    end loop;
    return dnum;
end;



-- 6.

CREATE OR REPLACE PACKAGE BODY PKZ.BINARY# AS

   FUNCTION to_decimal(
      bin      CLOB
   )
      RETURN   NUMBER
   AS
      result   NUMBER := 0;
      len      NUMBER;
      digit    CLOB;
   BEGIN
      len := LENGTH(bin);
      FOR i IN 1..len LOOP
         digit    := SUBSTR(bin, i, 1);

         IF (digit NOT IN ('0', '1')) THEN
            RETURN 0;
         END IF;

         result   := result + TO_NUMBER(digit) * POWER(2, len - i);
      END LOOP;

      RETURN result;
   END;

END BINARY#;
/
