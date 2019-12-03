SELECT *
FROM dept_test;

-- pl/sql (procedure ���� �ǽ� PRO_3) 18p
-- Q. �ǽ� PRO_3
-- UPDATEdept_test procedure ����
-- param : deptno, dname, loc
-- logic : �Է¹��� �μ� ������ dept_test ���̺� ���� ����
-- exec registdept_test('99', 'ddit', 'daejeon');
-- dept_test���̺� ���������� ���� �Ǿ����� Ȯ��

CREATE OR REPLACE PROCEDURE UPDATEdept_test(p_deptno IN dept_test.deptno%TYPE,
                                            p_dname IN dept_test.dname%TYPE,
                                            p_loc IN dept_test.loc%TYPE)
IS
BEGIN
    UPDATE dept_test 
    SET dname = p_dname
    WHERE deptno = p_deptno;    
    
    commit;
END;
/
exec UPDATEdept_test('99', 'ddit_m', 'daejeon');

SELECT *
FROM dept_test;

--------------------------------------------------------------------------------------------------

-- ROWTYPE : ���̺��� �� ���� �����͸� ���� �� �ִ� ����Ÿ��
set serveroutput on;

DECLARE
    dept_row dept%ROWTYPE; --dept�� �÷� �ϳ��ϳ� �������� �ʰ� dept���̺� ��ü�� ����.
BEGIN 
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ', ' || 
                         dept_row.dname || ', ' || 
                         dept_row.loc);
END;
/

--------------------------------------------------------------------------------------------------

-- ���պ��� : record
DECLARE
    -- UserVo userVo;
    TYPE dept_row IS RECORD (   -- dept_row�� UserVo ���� Ÿ��? Ŭ���� ���� ��.
        deptno NUMBER(2), -- �̷��� �ص�
        dname dept.dname%TYPE -- �̷��� �ص� �ȴ�.    
    );
    
    v_row dept_row;
    v_name dept.dname%Type; -- ������ �̰Ŷ� �������� Ÿ���� �ٸ���
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(v_row.deptno || ', ' || v_row.dname);
END;
/

--------------------------------------------------------------------------------------------------

-- ���պ��� : tabletype

DECLARE
    -- TYPE�� ���� �����ϴ� �� 
    -- DEPT�� ���� ��Ÿ���� Ÿ���� ������ ������ �� �ִ� ���̺� Ÿ��
    -- INDEX BY BINARY_INTEGER �ε����� ���� Ÿ���� ���ϴ� ��. BINARY_INTEGER�� PL/SQL�� �ִ� Ÿ�� 
    -- ���̺� Ÿ�� ������ �� �̷��� ���ָ��
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    -- java : Ÿ�� ������;
    -- pl/sql : ������ Ÿ��;
    v_dept dept_tab;
    
    bi BINARY_INTEGER;
    
BEGIN

    bi := 100;
    
    SELECT *
    BULK COLLECT INTO v_dept    --  BULK COLLECT INTO�� ��ü select�� ��(?)
    FROM dept;
    
  --dbms_output.put_line(v_dept(0).dname);
    dbms_output.put_line(bi);
    dbms_output.put_line(v_dept(1).dname);
    dbms_output.put_line(v_dept(2).dname);
    dbms_output.put_line(v_dept(3).dname);
    dbms_output.put_line(v_dept(4).dname);
    dbms_output.put_line(v_dept(5).dname);
    
END;
/

SELECT *
FROM dept;

--------------------------------------------------------------------------------------------------

-- IF
--    ELSE IF --> ELSIF
-- END IF;

DECLARE
    ind BINARY_INTEGER;
BEGIN
    ind := 2; -- �� �Ҵ�
    
    IF ind = 1 THEN
        dbms_output.put_line(ind);
    ELSIF ind = 2 THEN   
        dbms_output.put_line('ELSEIF ' || ind );
    ELSE
        dbms_output.put_line('ELSE');
    END IF;    
END;
/

--------------------------------------------------------------------------------------------------

-- FOR LOOP :
-- FOR �ε��� ���� IN ���۰�.. ���ᰪ LOOP
-- END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_line('i : ' || i);
    END LOOP;
END;
/



-- ���պ��� : tabletype�� loop �����ϱ�

DECLARE

    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    v_dept dept_tab;
    
    bi BINARY_INTEGER;
    
BEGIN

    bi := 100;
    
    SELECT *
    BULK COLLECT INTO v_dept   
    FROM dept;
    

    dbms_output.put_line(bi);
    
    FOR i IN 1..v_dept.count LOOP
        dbms_output.put_line(v_dept(i).dname);
    END LOOP;
    
END;
/
--------------------------------------------------------------------------------------------------

-- LOOP : ��� ���� �Ǵ� ������ LOOP �ȿ��� ����
-- Java : while(true)�� ���

DECLARE
    i NUMBER;
BEGIN
    i := 0; -- �ʱ�ȭ
    
    LOOP
        dbms_output.put_line(i);
        i := i + 1;
        -- loop ��� ���� ���� �Ǵ�
        EXIT WHEN i >= 5;
    END LOOP;    
END;
/

--------------------------------------------------------------------------------------------------

-- dt.sql
-- ���� ��¥ ���� 5�� ������ table �����

 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;

-- pl/sql (cursor �������� �ǽ� PRO_3) 40p
-- Q. �ǽ� PRO_3
-- dt.sql ������ ���� ���̺�� �����͸� �����ϰ�, ������ ����
-- ��¥ ���ݻ����� ����� ���ϴ� ���ν��� ����
-- exec avgdt

-- ���� ��� : 5 ��

-- ���� ������ ��
DECLARE
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    
    dt_table dt_tab;
    dd NUMBER;
    sumdd NUMBER;
    t number;
BEGIN
    sumdd := 0;
    t := 0;

    SELECT *
    BULK COLLECT INTO dt_table   
    FROM dt;
    
    FOR i IN 1..dt_table.count-1 LOOP
        dbms_output.put_line(dt_table(i).dt);
        dd := dt_table(i).dt - dt_table(i+1).dt; 
        dbms_output.put_line(dd);
        sumdd := dd + sumdd; 
        dbms_output.put_line(sumdd);
    END LOOP;

    dbms_output.put_line('���� ��� : ' || sumdd / (dt_table.count-1));      
END;
/

-- �� Ǯ��
DECLARE
    TYPE d_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    
    d_table d_tab;

    diff_sum NUMBER;

BEGIN
    diff_sum := 0;

    SELECT *
    BULK COLLECT INTO d_table   
    FROM dt
    ORDER BY dt;
    
    FOR i IN 1..d_table.count LOOP
        IF i != 1 THEN
            dbms_output.put_line(d_table(i).dt - d_table(i-1).dt);
            diff_sum := diff_sum + (d_table(i).dt - d_table(i-1).dt); 
        END IF;
    END LOOP;

    dbms_output.put_line('diff_sum : ' || diff_sum);   
    dbms_output.put_line('���� ��� : ' || (diff_sum / (d_table.count-1)));      
END;
/
--------------------------------------------------------------------------------------------------
-- ++  �̾
-- lead, lag �������� ����, ���� �����͸� ������ �� �ִ�.

SELECT *
FROM dt
ORDER BY dt desc;

-- �м��Լ��� ���ϱ�
SELECT AVG(diff)
FROM
    (SELECT dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
    FROM dt);
    
-- �м��Լ��� ������� ���ϴ� ȯ�濡�� ���ϱ�
SELECT ROWNUM RN, dt
FROM
    (SELECT dt
    FROM dt
    ORDER BY dt DESC);
    
-- ���� �õ��� Ǯ��    
SELECT *
FROM
    (SELECT ROWNUM RN, dt
    FROM
        (SELECT dt
        FROM dt
        ORDER BY dt DESC)a,
        (SELECT dt
        FROM dt
        ORDER BY dt DESC)b)
WHERE a.rn = b.rn-1    ;


-- �� ��
SELECT AVG(a.dt - b.dt)
FROM
(SELECT ROWNUM RN, dt
FROM
    (SELECT dt
    FROM dt
    ORDER BY dt DESC)) a,
(SELECT ROWNUM RN, dt
FROM
    (SELECT dt
    FROM dt
    ORDER BY dt DESC)) b    
WHERE a.rn = b.rn(+) -1;

-- ���� Ǯ��
-- HALL OF HONOR
SELECT (MAX(dt)-MIN(dt)) / (COUNT(*)-1)
FROM dt;

--------------------------------------------------------------------------------------------------

-- cursor
-- ���̺� Ÿ�� ���� sql �״�� �۾���.

DECLARE
    -- Ŀ�� ����
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
    
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    -- Ŀ�� ����
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; -- ���̻� ���� �����Ͱ� ���� �� ����
    END LOOP;
END;
/

-- FOR LOOP CURSOR ����

DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
--    v_deptno dept.deptno%TYPE;    
--    v_dname dept.dname%TYPE;
BEGIN
    FOR rec IN dept_cursor LOOP
        dbms_output.put_line(rec.deptno || ', ' ||  rec.dname);
    END LOOP;
END;
/

-- �Ķ���Ͱ� �ִ� ����� Ŀ��

DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job
        FROM emp
        WHERE job = p_job;
        
--    v_empno emp.empno%TYPE;    
--    v_ename emp.ename%TYPE;
--    v_job emp.job%TYPE;
BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP -- ���⼭ emp�� ���ڵ����.
        dbms_output.put_line(emp.empno || ', ' ||  emp.ename || ', ' || emp.job);
    END LOOP;
END;
/















