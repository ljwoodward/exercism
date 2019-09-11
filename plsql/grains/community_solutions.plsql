-- 1.

create or replace package grains#
is
    function at_square ( n pls_integer ) return number;
    function total                       return number;
    function total_naive                 return number;

    invalid_square  exception;
end grains#;
/

create or replace package body grains#
is
    function at_square ( n pls_integer )
    return number
    is
    begin
        if n < 1 or n > 64 then
            raise invalid_square;
        end if;

        return power(2, n-1);

    exception when others then raise;
    end at_square;

    --
    function total
    return number
    is
    begin

        return power(2, 64) - 1;

    exception when others then raise;
    end total;

    --
    function total_naive
    return number
    is
        s number := 0;
        i pls_integer;
    begin
        for i in 1 .. 64 loop
            s := s + at_square(i);
        end loop;
        return s;
    exception when others then raise;
    end total_naive;

end grains#;
/



-- 2.

create or replace function "GRAINS"
(n in NUMBER)
return NUMBER
is
    ng number;
    i number;
begin
    ng := 1;
    i := 1;
    while i < n
    loop
        ng := ng * 2;
        i := i + 1;
    end loop;
    return ng;
end;

create or replace function "TOTAL_GRAINS"
return NUMBER
is
    ng number;
    tg number;
    i number;
begin
    tg := 0;
    for i in 1..64
    loop
        ng := grains(i);
        tg := tg + ng;
    end loop;
    return tg;
end;



-- 3.

create or replace package grains#
is
	function at_square ( i_grain		number
	) return number;
  procedure total;
end grains#;
/

create or replace package body grains#
is
	function at_square ( i_grain		number
	) return number
	is
		l_grain 	                    number := 1;
	begin
  if i_grain = 1 then
    l_grain := i_grain;
  else
    for i in 2..i_grain loop
			l_grain := l_grain + l_grain ;

		end loop;
  end if;
	return l_grain;
	end at_square;

  procedure total
  is
    TYPE total_tab IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    l_total                       total_tab;
    l_tot                         number := 0;
  begin
    for i IN 1..64 loop
      l_total(i) := i;
    end loop;
    for i in 1..l_total.last loop
      l_tot := l_tot + grains#.at_square(i);
    end loop;

    dbms_output.put_line(l_tot);
  end total;
end grains#;
/



-- 4.

create or replace package grains#
is
  --+--------------------------------------------------------------------------+
  -- Calculates the number of grains of wheat on a chessboard given that
  -- the number on each square doubles (and starts with 1 grain on the first
  -- square).
  -- There are 64 squares on a chessboard
  --+--------------------------------------------------------------------------+


  --+--------------------------------------------------------------------------+
  -- Calculates the number of grains of wheat on a chessboard on a given square
  --
  -- @param n        natural number indicating the n-th square
  -- returns         the amount of grains on this square
  --+--------------------------------------------------------------------------+
  function at_square (
    n                                 pls_integer
  ) return number;

  --+--------------------------------------------------------------------------+
  -- Calculates the number of grains of wheat on a whole chessboard
  --
  -- returns         the amount of grains on a whole chessboard
  --+--------------------------------------------------------------------------+
  function total return number;

  --+--------------------------------------------------------------------------+
  -- Global exeception if not a valid square
  --+--------------------------------------------------------------------------+
  not_a_valid_square                  exception;

end grains#;
/

create or replace package body grains#
is
   function at_square (
    n                                pls_integer
  ) return number
  as
  begin
     if n < 1 or n > 64
     then
        raise not_a_valid_square;
     end if;

     return power(2,(n-1));

  exception
     when others
       then raise;
  end at_square;

--------------------------------

    function total return number
    is
    begin

      return power(2,64)-1;

      exception
     when others
       then raise;

    end total;

end grains#;
/



-- 5.

CREATE OR REPLACE PACKAGE BODY PKZ.grains# AS
   FUNCTION at_square(
      num      NUMBER
   )
      RETURN   NUMBER
   AS
   BEGIN
      RETURN POWER(2, num - 1);
   END;

   FUNCTION total
      RETURN   NUMBER
   AS
   BEGIN
      RETURN at_square(65) - 1;
   END;
END grains#;
/
