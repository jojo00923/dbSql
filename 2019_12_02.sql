-- �͸� ���
SET serveroutput on;

DECLARE
    -- ����̸��� ������ ��Į�� ����(1���� ��)
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename        
    FROM emp;
    -- ��ȸ����� �������ε� ��Į�� ������ ���� �����Ϸ��� �Ѵ�.
    -- --> ����
    
    -- �߻�����, �߻����ܸ� Ư�� ���� ���鶧 --> OTHERS (java : Exception)
    EXCEPTION
        WHEN others THEN
            dbms_output.put_line('Exception others');
END;
/

--------------------------------------------------------------------------------------------------

-- ����� ���� ����
DECLARE
    -- emp ���̺� ��ȸ�� ����� ���� ��� �߻���ų ����� ���� ����
    -- ���ܸ� EXCEPTION; -- ������ ����Ÿ��
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    
    BEGIN
        SELECT ename
        INTO v_ename
        FROM emp
        WHERE empno=9999;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                dbms_output.put_line('������ ������');
                -- ����ڰ� ������ ����� ���� ���ܸ� ����
                RAISE NO_EMP;
    END;
    
    EXCEPTION
        WHEN NO_EMP THEN
            dbms_output.put_line('no_emp exception');
END;
/

--------------------------------------------------------------------------------------------------

-- �����ȣ�� ���ڷ� �ϰ�, �ش� �����ȣ�� �ش��ϴ� ����̸��� �����ϴ� �Լ�(function)
CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
RETURN VARCHAR2 
IS 
    -- �����
    ret_ename emp.ename%TYPE;
BEGIN
    -- ����
    SELECT ename
    INTO ret_ename
    FROM emp
    WHERE empno = p_empno;

    RETURN ret_ename;
END;
/

SELECT getEmpName(7369)
FROM dual;

SELECT empno, ename, getEmpName(empno)
FROM emp;

--------------------------------------------------------------------------------------------------
-- pl/sql (function �ǽ� function1) 53p
-- Q. �ǽ� function1
-- �μ���ȣ�� �Ķ���ͷ� �Է¹ް� �ش� �μ��� �̸���
-- �����ϴ� �Լ� getdeptname�� �ۼ��غ�����.
CREATE OR REPLACE FUNCTION getDeptName(p_deptno dept.deptno%TYPE)
RETURN VARCHAR2
IS
    ret_dname dept.dname%TYPE;
BEGIN
    SELECT dname
    INTO ret_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN ret_dname;
END;    
/

SELECT getDeptName(10)
FROM dual;

SELECT deptno, dname, getDeptName(deptno)
FROM dept;

----------------------------------------------------
-- �������� �ʰ� ������ �� �ִ�.
SELECT empno, ename, deptno, getdeptname(deptno)
FROM emp;

-- scalar ���� �����ε� ��������, ������ ��� --> ����ó���ϴ°� ����
SELECT empno, ename, deptno, getdeptname(deptno),
    (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname,
    (SELECT loc FROM dept WHERE dept.deptno = emp.deptno) loc
FROM emp;


--------------------------------------------------------------------------------------------------
-- pl/sql (function �ǽ� function2) 54p
-- Q. �ǽ� function2
-- ���������� ���� �ݺ��Ǵ� ������ ���ø�ü�� ǥ���Ͽ����ϴ�.
-- �ش� �κ��� indent��� �̸��� �Լ��� ��ü�غ�����.
-- ���ڿ� ���ϰ��� ���� �����غ�����.
SELECT deptcd, LPAD(' ', (LEVEL-1)*4,' ') || deptnm deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

-- Ǯ��
CREATE OR REPLACE FUNCTION indent(p_level NUMBER, p_dname dept.dname%TYPE)
RETURN VARCHAR2
IS
    ret_text VARCHAR2(50);
BEGIN
    SELECT LPAD(' ', (p_level - 1)*4, ' ') || p_dname
    INTO ret_text
    FROM dual;
    
    RETURN ret_text;
END;    
/

SELECT indent(2, 'ACCOUNTING'), indent(3, 'SALES')
FROM dual;

-- ��
SELECT deptcd, indent(LEVEL, deptnm) as deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

---- ��Ű��......

-- Ʈ����
desc users;
CREATE TABLE user_history (
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE
);

-- users ���̺��� pass �÷��� ����� ���
-- users_history�� ������ pass�� �̷����� ����� Ʈ����
CREATE OR REPLACE TRIGGER make_history
    BEFORE UPDATE ON users -- users ���̺��� ������Ʈ ����
    FOR EACH ROW
    
    BEGIN 
        --: NEW.�÷��� : UPDATE ������ �ۼ��� ��
        --: OLD.�÷��� : ���� ���̺� ��
        IF :NEW.pass != :OLD.pass THEN
            INSERT INTO user_history 
            VALUES (:OLD.userid, :OLD.pass, sysdate);
        END IF;
    END;
/

SELECT *
FROM users;

-- ������ pass�� �ٲ㺸��
UPDATE users SET pass = 'brownpass'
WHERE userid = 'brown';

-- Ʈ���ſ� �ۼ��� ������� ����ִ��� ����.
-- ����Ǳ� �� ���� ����ִ� ���� �� �� �ִ�. 
SELECT *
FROM user_history;

-- where�� �ȳ����� ��ü ���� �ٲ�� 5���� ���� ����.
UPDATE users SET pass = 'newpass';

-- ������ ������� �ϸ�???
-- ������ ���� ��...
CREATE SEQUENCE SEQ_USERS  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;

-----
-- ibatis(2.X)





