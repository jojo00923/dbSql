SELECT *
FROM no_emp;

-- 1.leaf node ã��
SELECT LPAD(' ', (LEVEL-1)*4, ' ') || org_cd, s_emp
FROM
    (SELECT org_cd, parent_org_cd, SUM(s_emp) s_emp
    FROM
        (SELECT org_cd, parent_org_cd,
               sum(no_emp/org_cnt) OVER (PARTITION BY gr ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
        FROM
            (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr ,COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
            FROM
                (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
                FROM no_emp
                START WITH parent_org_cd IS NULL
                CONNECT BY PRIOR org_cd = parent_org_cd) a
            START WITH leaf = 1
            CONNECT BY PRIOR parent_org_cd = org_cd))
        GROUP BY org_cd, parent_org_cd)
    START WITH parent_org_cd IS NULL
    CONNECT BY PRIOR org_cd = parent_org_cd;
    
-- 1�ܰ�
SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
FROM no_emp
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;
    
-- 2�ܰ�
SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr  ,COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt 
FROM
    (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
    FROM no_emp
    START WITH parent_org_cd IS NULL
    CONNECT BY PRIOR org_cd = parent_org_cd) a
START WITH leaf = 1
CONNECT BY PRIOR parent_org_cd = org_cd;

-- 3�ܰ�                 
SELECT org_cd, parent_org_cd,
       sum(no_emp/org_cnt) OVER (PARTITION BY gr ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
FROM
    (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr ,COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt 
    FROM
        (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
        FROM no_emp
        START WITH parent_org_cd IS NULL
        CONNECT BY PRIOR org_cd = parent_org_cd) a
    START WITH leaf = 1
    CONNECT BY PRIOR parent_org_cd = org_cd);
           
-- 4�ܰ�
SELECT org_cd, parent_org_cd, SUM(s_emp) s_emp -- SUM(s_emp) s_emp : org_cd�� parent_org_cd�� ���� �ͳ��� s_emp�� ������.
FROM
    (SELECT org_cd, parent_org_cd,
           sum(no_emp/org_cnt) OVER (PARTITION BY gr ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
    FROM
        (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr ,COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
        FROM
            (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
            FROM no_emp
            START WITH parent_org_cd IS NULL
            CONNECT BY PRIOR org_cd = parent_org_cd) a
        START WITH leaf = 1
        CONNECT BY PRIOR parent_org_cd = org_cd))
GROUP BY org_cd, parent_org_cd;
        
-- ����
SELECT LPAD(' ', (LEVEL-1)*4, ' ') || org_cd, s_emp
FROM
    (SELECT org_cd, parent_org_cd, SUM(s_emp) s_emp
    FROM
        (SELECT org_cd, parent_org_cd,
               sum(no_emp/org_cnt) OVER (PARTITION BY gr ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
        FROM
            (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr ,COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
            FROM
                (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
                FROM no_emp
                START WITH parent_org_cd IS NULL
                CONNECT BY PRIOR org_cd = parent_org_cd) a
            START WITH leaf = 1
            CONNECT BY PRIOR parent_org_cd = org_cd))
    GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;

---------------------------------------------------------------------------------------------------------------------------------

-- << PL/SQL >>
-- ����Ŭ���� �����ϴ� ���α׷��� ���
-- �Ҵ翬�� :=
-- System.out.println(""); --> dbms_output.put_line('');
-- Log4j
-- set serveroutput ON : ȭ�� ��� ����� Ȱ��ȭ

-- PL/SQL ����
-- declare : ����, ��� ����
-- begin : ���� ����
-- exception : ����ó��
DESC dept;

set serveroutput on;

-- 1
DECLARE
    -- ���� ����
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    dbms_output.put_line('test');
END;
/
-- 2
DECLARE
    -- ���� ����
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname -- INTO :  ���� ������ ������ ���� ��(�Ѱ��϶���)
    FROM dept
    WHERE deptno = '10';
    
    -- SELECT���� ����� ������ �� �Ҵ��ߴ��� Ȯ��
    dbms_output.put_line('dname : ' ||  dname || '(' || deptno || ')');
END;
/
-- 3 
DECLARE
    -- ���� ����
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname -- �������� �� ������
    FROM dept;
    
    -- SELECT���� ����� ������ �� �Ҵ��ߴ��� Ȯ��
    dbms_output.put_line('dname : ' ||  dname || '(' || deptno || ')');
END;
/    
-- 4
DECLARE
    -- ���� ���� ���� (���̺� �÷�Ÿ���� ����Ǿ pl/sql ������ ������ �ʿ䰡 ����.)
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname 
    FROM dept
    WHERE deptno = '10';
    
    -- SELECT���� ����� ������ �� �Ҵ��ߴ��� Ȯ��
    dbms_output.put_line('dname : ' ||  dname || '(' || deptno || ')');
END;
/

-- 10�� �μ��� �μ��̸��� LOC������ ȭ�鿡 ����ϴ� ���ν���
-- ���ν����� : printdept
-- CREATE OR REPLACE VIEW

-- ���ν��� ��ü ����
CREATE OR REPLACE PROCEDURE printdept 
IS
    -- ���� ����
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc 
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line('dname, loc = ' || dname || ',' || loc);
END;
/

exec printdept;

-- �μ���ȣ�� ���ν��� ���ڷ� �ޱ�
CREATE OR REPLACE PROCEDURE printdept_p(p_deptno IN dept.deptno%TYPE)
IS
    -- ���� ����
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc 
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    dbms_output.put_line('dname, loc = ' || dname || ',' || loc);
END;
/
-- ����
exec printdept_p(30);

-- pl/sql (procedure ���� �ǽ� PRO_1) 16p
-- Q. �ǽ� PRO_1
-- printemp procedure ����
-- param : empno
-- logic : empno�� �ش��ϴ� ����� ������ ��ȸ�Ͽ�
--         ����̸�, �μ��̸��� ȭ�鿡 ���

CREATE OR REPLACE PROCEDURE printemp(empno_p IN emp.empno%TYPE)
IS
    -- ���� ����
    ll emp.ename%TYPE; -- ll�� ename��
    dname dept.dname%TYPE;
BEGIN
    SELECT emp.ename, dept.dname
    INTO ll, dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno
    AND emp.empno = empno_p;
    
    dbms_output.put_line('ename = ' || ll || ', dname = ' || dname);
END;
/

exec printemp(7369);

---------------------------------------------------------------------------------------------------------------------------------

select *
from dept_test;

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

DELETE dept_test
WHERE deptno > 90;

-- pl/sql (procedure ���� �ǽ� PRO_2) 17p
-- Q. �ǽ� PRO_2
-- registdept_test procedure ����
-- param : deptno, dname, loc
-- logic : �Է¹��� �μ� ������ dept_test ���̺� �ű� �Է�
-- exec registdept_test('99', 'ddit', 'daejeon');
-- dept_test���̺� ���������� �Է� �Ǿ����� Ȯ��

CREATE OR REPLACE PROCEDURE registdept_test(p_deptno IN dept_test.deptno%TYPE,
                                            p_dname IN dept_test.dname%TYPE,
                                            p_loc IN dept_test.loc%TYPE)
IS
    deptno dept_test.deptno%TYPE;
    dname dept_test.dname%TYPE;
    loc dept_test.loc%TYPE;
BEGIN
    INSERT INTO dept_test 
    VALUES (p_deptno, p_dname, p_loc)  ;
    
    dbms_output.put_line('deptno = ' || deptno || ', dname = ' || dname || ', loc = ' || loc);
    commit;
END;
/
exec registdept_test('99', 'ddit', 'daejeon');

SELECT *
FROM dept_test;












