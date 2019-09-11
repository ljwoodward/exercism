-- 1.

create or replace package year#
is
    function is_leap(
        year  number
    )
    return varchar2;
end year#;
/

create or replace package body year#
is
    function is_leap(
        year  number
    )
    return varchar2
    as
        result varchar2(100);
    begin
        if mod(year, 400) = 0 or (mod(year, 4) = 0 and mod(year, 100) <> 0) then
            result := 'Yes, ' || year || ' is a leap year';
        else
            result := 'No, ' || year || ' is not a leap year';
        end if;
        return result;
    end;
end year#;
/



-- 2.

create or replace function "ISLEAP"
(year in NUMBER)
return VarChar2
is
begin
   if mod(year, 400) = 0 or (not (mod(year, 100) = 0) and mod(year,4) = 0)
   then
       return 'Y';
   else
       return 'N';
   end if;
end;



-- 3.

create or replace package year#
is
	function is_leap (i_annee		            number
	) return varchar2;

end year#;
/

create or replace package body year#
is
	function is_leap (i_annee 	            number
	) return varchar2
  is
	begin
		if mod(i_annee, 400) = 0 OR ( mod(i_annee, 4) = 0 AND mod(i_annee, 100) != 0 ) then
			return 'Yes, ' || i_annee || ' is a leap year';
		end if;
			return 'No, ' || i_annee || ' is not a leap year';
	end is_leap;
end year#;
/



-- 4.

create or replace package year#
is
  --+--------------------------------------------------------------------------+
  -- Take a year and report if it is a leap year.
  --    ```plain
  --    on every year that is evenly divisible by 4
  --      except every year that is evenly divisible by 100
  --        unless the year is also evenly divisible by 400
  --    ```
  -- @param year            number representing the year
  --
  -- @return                string that report if the year is a leap year or not
  --+--------------------------------------------------------------------------+
  function is_leap (
    year                                 pls_integer
  ) return varchar2;


end year#;
/

create or replace package body year#
is
   function is_leap (
    year                                pls_integer
  ) return varchar2
  as
    l_is_leap_year                    boolean := FALSE;
    l_return_report                   varchar2(200 char) := ' a leap year';

  begin
     if mod(year,400) = 0
     then
        l_is_leap_year := TRUE;
     elsif mod(year,100) = 0
     then
        l_is_leap_year := FALSE;
     elsif mod(year,4) = 0
     then
        l_is_leap_year := TRUE;
    end if;


    if l_is_leap_year
    then
       l_return_report := 'Yes, ' || year || ' is' || l_return_report;
    else
       l_return_report := 'No, ' || year || ' is not' || l_return_report;
    end if;

    return l_return_report;

  exception
     when others
       then raise;
  end is_leap;

end year#;
/



-- 5.

REATE OR REPLACE PACKAGE year# AS
  ----------------------------------------
  -- Declaration:
  --   Public Functions.
  ----------------------------------------
  ----------------------------------------
  -- is_leap:
  --   Given a year,
  --   Report if it is a leap year.
  --
  --   p_number: determine what the nth
  --             prime is
  ----------------------------------------
  FUNCTION is_leap (
    p_number IN NUMBER)
  RETURN VARCHAR2;
END year#;
/

CREATE OR REPLACE PACKAGE BODY year# AS
  ----------------------------------------
  -- Implementation:
  --   Public Functions.
  ----------------------------------------
  ----------------------------------------
  -- is_leap:
  --   Given a year,
  --   Report if it is a leap year.
  --
  --   p_number: determine what the nth
  --             prime is
  ----------------------------------------
  FUNCTION is_leap (
    p_number IN NUMBER)
  RETURN VARCHAR2 IS
  BEGIN
    IF (p_number IS NULL) THEN
      RAISE_APPLICATION_ERROR (-20001, 'Input Parameter is NULL.');
    END IF;

    IF ((REMAINDER(p_number, 4) = 0)
        AND (REMAINDER(p_number, 100) <> 0)
        OR (REMAINDER(p_number, 400) = 0)) THEN
      RETURN ('Yes, ' || p_number || ' is a leap year');
    ELSE
      RETURN ('No, ' || p_number || ' is not a leap year');
    END IF;
  END is_leap;
END year#;
/




-- 6.
