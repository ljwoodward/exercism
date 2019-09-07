CREATE OR REPLACE PACKAGE complement# AS
    FUNCTION of_dna (p_dna VARCHAR2) RETURN VARCHAR2;
    FUNCTION of_rna (p_rna VARCHAR2) RETURN VARCHAR2;
END complement#;
/

CREATE OR REPLACE PACKAGE BODY complement# AS
    FUNCTION of_dna (p_dna VARCHAR2) RETURN VARCHAR2
    IS
      v_rna    VARCHAR2(100) := '';
      v_strand VARCHAR2(1);
      v_length NUMBER := length(p_dna);
      v_count  NUMBER := 1;
    BEGIN
      LOOP
        EXIT WHEN
          v_count > v_length;
        CASE substr(p_dna, v_count, 1)
          WHEN 'G' THEN
            v_strand := 'C';
          WHEN 'C' THEN
            v_strand := 'G';
          WHEN 'T' THEN
            v_strand := 'A';
          WHEN 'A' THEN
            v_strand := 'U';
        END CASE;
        v_rna := v_rna || v_strand;
        v_count := v_count + 1;
      END LOOP;
      RETURN v_rna;
    END;

    FUNCTION of_rna (p_rna VARCHAR2) RETURN VARCHAR2
    IS
      v_dna    VARCHAR2(100) := '';
      v_strand VARCHAR2(1);
      v_length NUMBER := length(p_rna);
      v_count  NUMBER := 1;
    BEGIN
      LOOP
        EXIT WHEN
          v_count > v_length;
        CASE substr(p_rna, v_count, 1)
          WHEN 'G' THEN
            v_strand := 'C';
          WHEN 'C' THEN
            v_strand := 'G';
          WHEN 'U' THEN
            v_strand := 'A';
          WHEN 'A' THEN
            v_strand := 'T';
        END CASE;
        v_dna := v_dna || v_strand;
        v_count := v_count + 1;
      END LOOP;
      RETURN v_dna;
    END;
END complement#;


-- -- other solutions:
-- create or replace package body complement#
-- is
--   c_rna                       varchar2(4) := 'CGTA';
--   c_dna                       varchar2(4) := 'GCAU';
-- --- DNA strand Function
--   function of_dna (
--     i_rna                     varchar2
--   ) return varchar2
--   is
--   begin
--     return translate (i_rna, c_rna, c_dna );    -- This is interesting.
--   end of_dna;
--
-- --- RNA strand Function
--   function of_rna (
--     i_dna                     varchar2
--   ) return varchar2
--   is
--   begin
--     return translate (i_dna, c_dna, c_rna );
--   end of_rna;
-- end complement#;

-------------------------------------------------------------Super thorough one:

-- create or replace package complement#
-- is
--   --+--------------------------------------------------------------------------+
--   -- Transscribe RNA to DNA and the other way round
--   -- The four nucleotides found in DNA are adenine (**A**), cytosine (**C**),
--   --guanine (**G**) and thymidine (**T**).
--   --
--   --The four nucleotides found in RNA are adenine (**A**), cytosine (**C**),
--   --guanine (**G**) and uracil (**U**).
--   --
--   --
--   --+--------------------------------------------------------------------------+
--
--
--   --+--------------------------------------------------------------------------+
--   -- Transsribles DNA to RNA
--   --Given a DNA strand, its transcribed RNA strand is formed by replacing
--   --each nucleotide with its complement:
--   --
--   --* `G` -> `C`
--   --* `C` -> `G`
--   --* `T` -> `A`
--   --* `A` -> `U`
--   --
--   -- @param strand   the DNA-strand
--   --
--   -- @return         the transscribed RNA-strand
--   --+--------------------------------------------------------------------------+
--   function of_dna (
--     strand                                          varchar2
--   ) return varchar2;
--
--   --+--------------------------------------------------------------------------+
--   -- Transsribles RNA to DNA
--   --Given a RNA strand, its transcribed DNA strand is formed by replacing
--   --each nucleotide with its complement:
--   --
--   --* `G` -> `C`
--   --* `C` -> `G`
--   --* `A` -> `T`
--   --* `U` -> `A`
--   --
--   -- @param strand   the RNA-strand
--   --
--   -- @return         the transscribed DNA-strand
--   --+--------------------------------------------------------------------------+
--   function of_rna (
--     strand                                          varchar2
--   ) return varchar2;
--
--   exp_no_valid_rna                                   exception;
--   exp_no_valid_dna                                   exception;
--
-- end complement#;
-- /
--
-- create or replace package body complement#
-- is
--
--   function of_rna (
--     strand                                          varchar2
--   ) return varchar2
--   is
--     dna_strand                                      varchar2(32000 char) := strand;
--   begin
--       -- check
--       if not regexp_like(l_rna_strand,'^[GCAU]+$')
--          then raise exp_no_valid_rna;
--       end if;
--       -- transscribe
--       dna_strand := translate(dna_strand,'GCAU','CGTA');
--   return dna_strand;
--
--   exception
--     when exp_no_valid_rna
--           then dbms_output.put_line('Not a valid RNA strand');
--                 raise;
--     when others then raise;
--   end of_rna;
--
--   -------------------------------------------------
--
--   function of_dna (
--     strand                                          varchar2
--   ) return varchar2
--   is
--     rna_strand                                      varchar2(32000 char) := strand;
--   begin
--       -- check
--       if not regexp_like(l_dna_strand,'^[GCAT]+$')
--          then raise exp_no_valid_dna;
--       end if;
--       -- transscribe
--       rna_strand := translate(rna_strand,'GCTA','CGAU');
--
--   return rna_strand;
--
--   exception
--     when exp_no_valid_dna
--          then dbms_output.put_line('Not a valid DNA strand');
--               raise;
--     when others then raise;
--   end of_dna;
--
--
-- end complement#;
-- /


----------------- Quite like this one, declares nucleotides in the package spec:
-- create or replace package complement#
-- is
--     DNA_NUCLEOTIDES     varchar2(4) := 'GCTA';
--     RNA_NUCLEOTIDES     varchar2(4) := 'CGAU';
--
--     function of_dna ( dna_strand varchar2 ) return varchar2;
--     function of_rna ( rna_strand varchar2 ) return varchar2;
-- end complement#;
-- /
--
-- create or replace package body complement#
-- is
--     --
--     function of_dna (
--         dna_strand      varchar2
--     )
--     return varchar2
--     as
--     begin
--
--         if dna_strand is null then
--             raise_application_error(-20001, 'Input cannot be null.');
--         end if;
--
--         return translate(dna_strand, DNA_NUCLEOTIDES, RNA_NUCLEOTIDES);
--
--     exception
--         when others
--             then raise;
--
--     end of_dna;
--
--     --
--     function of_rna (
--         rna_strand      varchar2
--     )
--     return varchar2
--     as
--     begin
--
--         if rna_strand is null then
--             raise_application_error(-20001, 'Input cannot be null.');
--         end if;
--
--         return translate(rna_strand, RNA_NUCLEOTIDES, DNA_NUCLEOTIDES);
--
--     exception
--         when others
--             then raise;
--
--     end of_rna;
--
-- end complement#;

-- -- This probably would've been a better way than mine for looping:
-- function of_dna(
-- i_first   varchar2
-- ) return varchar2 is
-- retour varchar2(300) :='';
-- begin
-- FOR i IN 1..length(i_first) LOOP
--    case SUBSTR(i_first,i,1)
--      when 'G' then
--         retour :=concat(retour,'C');
--      when 'C' then
--         retour :=concat(retour,'G');
--      when 'T' then
--         retour :=concat(retour,'A');
--      when 'A' then
--         retour :=concat(retour,'U');
--      else retour :=concat(retour,SUBSTR(i_first,i,1));
--   end case;
--  end loop;
-- return trim(retour);
-- end of_dna;


-- -- Nice and concise:
-- create or replace package complement#
-- is
--   function of_dna(i_nucleotide in varchar2) return varchar2;
--   function of_rna(i_nucleotide in varchar2) return varchar2;
-- end complement#;
-- /
--
-- create or replace package body complement#
-- is
--   function of_dna(i_nucleotide in varchar2) return varchar2
--   is
--   begin
--     return translate(i_nucleotide,'GCTA','CGAU');
--   end of_dna;
--
--   function of_rna(i_nucleotide in varchar2) return varchar2
--   is
--   begin
--     return translate(i_nucleotide,'CGAU','GCTA');
--   end of_rna;
--
-- end complement#;
-- /
