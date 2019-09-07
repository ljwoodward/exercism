create or replace package ut_complement#
is
  procedure run;
end ut_complement#;
/

create or replace package body ut_complement#
is
  procedure test (
    i_descn                                       varchar2
   ,i_exp                                         varchar2
   ,i_act                                         varchar2
  )
  is
  begin
    if i_exp = i_act then
      dbms_output.put_line('SUCCESS: ' || i_descn);
    else
      dbms_output.put_line('FAILURE: ' || i_descn || ' - expected ' || nvl(i_exp, 'null') || ', but received ' || nvl(i_act, 'null'));
    end if;
  end test;

  procedure run
  is
  begin
    test(i_descn => 'test_rna_complement_of_cytosine_is_guanine', i_exp => 'G'            , i_act => complement#.of_dna('C'            ));
    test(i_descn => 'test_rna_complement_of_guanine_is_cytosine', i_exp => 'C'            , i_act => complement#.of_dna('G'            ));
    test(i_descn => 'test_rna_complement_of_thymine_is_adenine' , i_exp => 'A'            , i_act => complement#.of_dna('T'            ));
    test(i_descn => 'test_rna_complement_of_adenine_is_uracil'  , i_exp => 'U'            , i_act => complement#.of_dna('A'            ));
    test(i_descn => 'test_rna_complement'                       , i_exp => 'UGCACCAGAAUU' , i_act => complement#.of_dna('ACGTGGTCTTAA' ));
    test(i_descn => 'test_dna_complement_of_cytosine_is_guanine', i_exp => 'G'            , i_act => complement#.of_rna('C'            ));
    test(i_descn => 'test_dna_complement_of_guanine_is_cytosine', i_exp => 'C'            , i_act => complement#.of_rna('G'            ));
    test(i_descn => 'test_dna_complement_of_uracil_is_adenine'  , i_exp => 'A'            , i_act => complement#.of_rna('U'            ));
    test(i_descn => 'test_dna_complement_of_adenine_is_thymine' , i_exp => 'T'            , i_act => complement#.of_rna('A'            ));
    test(i_descn => 'test_dna_complement'                       , i_exp => 'ACTTGGGCTGTAC', i_act => complement#.of_rna('UGAACCCGACAUG'));
  end run;
end ut_complement#;
/
set serveroutput on
begin
  ut_complement#.run;
end;
/

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
