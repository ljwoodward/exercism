-- 1.

create or replace package prime#
is
  --+--------------------------------------------------------------------------+
  -- Calculate what the nth prime is
  --
  -- @param n               natural number
  --
  -- @return                the nth prime
  --+--------------------------------------------------------------------------+
  function nth (
    n                                 pls_integer
  ) return pls_integer;

  --+--------------------------------------------------------------------------+
  -- Is a natural number prime?
  --
  -- @param n               natural number
  --
  -- @return                is is prime?
  --+--------------------------------------------------------------------------+
  function is_prime (
    n                                 pls_integer
  ) return boolean;

  --+--------------------------------------------------------------------------+
  -- Global Exception if n is not a natural number
  --+--------------------------------------------------------------------------+
  invalid_argument_error            exception;

end prime#;
/

create or replace package body prime#
is
  function nth (
    n                                 pls_integer
  ) return pls_integer
  as
    l_prime_found                     pls_integer := 1; -- i means i.th prime found
    l_next_candidate                  pls_integer := 1;
    l_nth_prime                       pls_integer;

  begin

     -- get the ith prime if it is known already
     begin
        select p.prime_candidate into l_nth_prime from primes p where p.i_th_prime = n;
        return l_nth_prime;
     exception
        when NO_DATA_FOUND then null; -- the ith prime is not yet known
        when OTHERS        then raise;
     end;

     -- raise an error is n is not a natural number
     if n <= 0
     then raise invalid_argument_error;
     end if;

     -- return 2 if n=1
     if n=1
     then
        -- save the 2 forever
        insert into primes(prime_candidate, is_prime_jn, i_th_prime) values (2, 'J', 1);
        return 2;
     end if;

     --
     select p.prime_candidate, p.i_th_prime
     into l_next_candidate, l_prime_found
     from primes p
     where p.i_th_prime = (select max(i_th_prime) from primes);

     -- otherwise loop with increment +2 until the nth prime is found
     while l_prime_found < n
     loop
         l_next_candidate := l_next_candidate + 2;
         if is_prime(l_next_candidate)
         then
            l_prime_found := l_prime_found + 1;
            insert into primes(prime_candidate, is_prime_jn, i_th_prime) values (l_next_candidate, 'J', l_prime_found);
         end if;
     end loop;

     commit;
     return l_next_candidate;

  exception
     when others
       then raise;
  end nth;

  ----------------------------------

  function is_prime (
    n                                 pls_integer
  ) return boolean
  is
    l_is_prime                        varchar(1 char);
  begin

       -- get the prime status of n if it is known already
     begin
        select p.is_prime_jn into l_is_prime from primes p where p.prime_candidate = n;
        if    l_is_prime = 'J' then return TRUE;
        elsif l_is_prime = 'N' then return FALSE;
        end if;
     exception
        when NO_DATA_FOUND then null; -- the primestatus of n is not yet known
        when OTHERS        then raise;
     end;

  if n = 1
  -- save the 1 forever
  then  insert into primes(prime_candidate, is_prime_jn) values (1, 'N');
        return FALSE;
  else
     for i in 2 .. sqrt(n)
     loop
        if mod(n,i) = 0 -- if n is divisble by i, then n cannot be a prime
           then  insert into primes(prime_candidate, is_prime_jn) values (n, 'N');
                 return FALSE;
        end if;
     end loop;
  end if;

  return TRUE;

  exception
  when others
    then raise;

  end is_prime;

end prime#;
/


-- 2.

create or replace package prime#
is
	function f_prime (
		i_num                   		  pls_integer
	) return boolean;
	function nth (
		i_num_prime 					        pls_integer
	) return pls_integer;

end prime#;
/


create or replace package body prime#
is


    function f_prime
    (   i_num                     pls_integer
    )
    return boolean
    IS
        l_prime                   boolean := true;
    begin

        for i in 2..round(sqrt(i_num)) loop
            if mod(i_num,i) = 0 then
                l_prime := false;
                exit;
            end if;
        end loop;

        return l_prime;
    end f_prime;

	function nth (
		i_num_prime 					        pls_integer
	) return pls_integer
	is
    i_count 							        pls_integer := 1;
    i_cur 								        pls_integer := 2;
  begin
    while i_count < i_num_prime loop
        i_cur := i_cur + 1;
        if f_prime(i_cur) then
            i_count := i_count + 1;
        end if;
    end loop;

  return i_cur;
  end nth;
end prime#;
/



-- 3.

CREATE OR REPLACE PACKAGE BODY PKZ.PRIME# AS
   TYPE t_number  IS TABLE OF NUMBER;
   TYPE t_boolean IS TABLE OF BOOLEAN;

   FUNCTION eratosthenes(
      upper_limit NUMBER
   )
      RETURN      t_number
   AS
      result      t_number := t_number();
      prime_flags t_boolean := t_boolean(FALSE);
      k  NUMBER;
      i  NUMBER;
   BEGIN
      FOR i IN 2..upper_limit LOOP
         prime_flags.extend();
         prime_flags(i) := TRUE;
      END LOOP;

      i := 2;
      WHILE i <= upper_limit LOOP
      --FOR i IN 2..upper_limit LOOP -- causes ORA-01426: numeric overflow, what the hell.

         IF (prime_flags(i) = TRUE) THEN
            result.extend();
            result(result.count()) := i;

            k := i*i;

            WHILE K <= upper_limit LOOP
               prime_flags(K) := FALSE;
               k := K + i;
            END LOOP;

         END IF;

         i := i + 1;
      END LOOP;
      RETURN result;
   END;

   FUNCTION nth(
      n        NUMBER
   )
      RETURN   NUMBER
   AS
      result      NUMBER;
      upper_limit NUMBER := 104743;
      primes      t_number;
   BEGIN
      IF (n < 1) THEN
         RAISE invalid_argument_error;
      END IF;

      primes := eratosthenes(upper_limit);

      /*FOR i IN 1..primes.count() LOOP
         DBMS_OUTPUT.PUT(primes(i) || ', ');
      END LOOP;*/

      IF primes.count() >= n THEN
         result := primes(n);
      END IF;

      RETURN result;
   END;

END PRIME#;
/



-- 4.

create or replace package prime#
is
    function is_prime ( n pls_integer ) return boolean;
    function nth      ( n pls_integer ) return pls_integer;

    invalid_argument_error      exception;
end prime#;
/

create or replace package body prime#
is
    function is_prime ( n pls_integer )
    return boolean
    is
        root    pls_integer := trunc(sqrt(n));
        factor  pls_integer;
    begin
        if n <= 1 then
            return false;
        elsif n = 2 then
            return true;
        elsif mod(n, 2) = 0 then
            return false;
        end if;

        factor := 3;
        while factor <= root loop
            if mod(n, factor) = 0 then
                return false;
            end if;
            factor := factor + 2;
        end loop;
        return true;

    exception when others then raise;
    end is_prime;

    --
    function nth ( n pls_integer ) return pls_integer
    is
        counter pls_integer;
        prime   pls_integer;
    begin
        if n < 1 then
            raise invalid_argument_error;
        end if;

        if n = 1 then
            return 2;
        end if;

        counter := 1;
        prime := 1;
        while counter < n loop
            prime := prime + 2;
            if is_prime(prime) then
                counter := counter + 1;
            end if;
        end loop;

        return prime;

    exception when others then raise;
    end nth;
end prime#;
/



-- 5.

create or replace function "NTH_PRIME"
(n in NUMBER)
return NUMBER
is
    type numericarray IS VARRAY(100) OF number;
    primes numericarray := numericarray(2);
    pi number;
    i number;
    num number;
begin
    pi := 1;
    num := 3;
    while pi < n
    loop
        i := 1;
        while (i < pi and mod(num,primes(i)) != 0)
        loop
            i := i + 1;
        end loop;
        if mod(num,primes(i)) != 0
        then
            pi := pi + 1;
            primes.extend;
            primes(pi) := num;
        end if;
        num := num + 1;
    end loop;
    return primes(pi);
end;



-- 6.

CREATE OR REPLACE PACKAGE prime# AS
  ----------------------------------------
  -- Declaration:
  --   Public Variables.
  ----------------------------------------
  INVALID_ARGUMENT_ERROR EXCEPTION;

  ----------------------------------------
  -- Declaration:
  --   Public Functions.
  ----------------------------------------
  ----------------------------------------
  -- nth:
  --   Given a number p_number, determine
  --   what the nth prime is.
  --
  --   p_number: determine what the nth
  --             prime is
  ----------------------------------------
  FUNCTION nth (
    p_number IN NUMBER)
  RETURN NUMBER;
END prime#;
/

CREATE OR REPLACE PACKAGE BODY prime# AS
  ----------------------------------------
  -- Declaration:
  --   Private Functions.
  ----------------------------------------
  ----------------------------------------
  -- is_prime:
  --   Checks if the number p_number is
  --   a prime.
  --
  --   p_number: the Number to check
  --   x:        factor
  --   y:        factor
  ----------------------------------------
  FUNCTION is_prime(
    p_number NUMBER
    , x      NUMBER DEFAULT 5
    , y      NUMBER DEFAULT 2)
  RETURN BOOLEAN;

  ----------------------------------------
  -- calculate:
  --   Calculates the result.
  --
  --   p_number:  the Number to check
  --   p_current: the calulated Number
  ----------------------------------------
  FUNCTION calculate(
    p_number    NUMBER
    , p_current NUMBER)
  RETURN NUMBER;

  ----------------------------------------
  -- Implementation:
  --   Private Functions.
  ----------------------------------------
  ----------------------------------------
  -- is_prime:
  --   Checks if the number p_number is
  --   a prime.
  --
  --   p_number: the Number to check
  --   x:        factor
  --   y:        factor
  ----------------------------------------
  FUNCTION is_prime(
    p_number NUMBER
    , x      NUMBER DEFAULT 5
    , y      NUMBER DEFAULT 2)
  RETURN BOOLEAN IS
    v_result BOOLEAN;
  BEGIN
    CASE
      WHEN ((p_number = 2) OR (p_number = 3)) THEN
        v_result := TRUE;
      WHEN ((REMAINDER(p_number, 2) = 0) OR (REMAINDER(p_number, 3) = 0)) THEN
        v_result := FALSE;
      ELSE
        IF (x * x <= p_number) THEN
          IF (REMAINDER(p_number, x) = 0) THEN
            v_result := FALSE;
          ELSE
            v_result := is_prime(p_number, x + y, 6 - y);
          END IF;
        ELSE
          v_result := TRUE;
        END IF;
    END CASE;

    RETURN (v_result);
  END is_prime;

  ----------------------------------------
  -- calculate:
  --   Calculates the result.
  --
  --   p_number:  the Number to check
  --   p_current: the calulated Number
  ----------------------------------------
  FUNCTION calculate(
    p_number    NUMBER
    , p_current NUMBER)
  RETURN NUMBER IS
    v_current NUMBER(11, 0);
    v_result  NUMBER(11, 0);
  BEGIN
    IF (p_number = 0) THEN
      v_result := p_current;
    ELSE
      v_current := p_current + 1;

      CASE is_prime(v_current)
        WHEN  TRUE THEN v_result := calculate(p_number - 1, v_current);
        WHEN FALSE THEN v_result := calculate(p_number,     v_current);
      END CASE;
    END IF;

    RETURN (v_result);
  END calculate;

  ----------------------------------------
  -- Implementation:
  --   Public Functions.
  ----------------------------------------
  ----------------------------------------
  -- nth:
  --   Given a number p_number, determine
  --   what the nth prime is.
  --
  --   p_number: determine what the nth
  --             prime is
  ----------------------------------------
  FUNCTION nth (
    p_number IN NUMBER)
  RETURN NUMBER IS
  BEGIN
    IF (p_number IS NULL) THEN
      RAISE_APPLICATION_ERROR (-20001, 'Input Parameter is NULL.');
    ELSIF (p_number = 0) THEN
      RAISE INVALID_ARGUMENT_ERROR;
    END IF;

    RETURN (calculate(p_number, 1));
  END nth;
END prime#;
/
