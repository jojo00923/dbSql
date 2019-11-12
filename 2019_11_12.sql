SELECT *
FROM dept;

DELETE dept
WHERE deptno = 99;
COMMIT;

INSERT INTO dept
VALUES (99, 'DDIT', 'daejeon');
-----------------------------------------------
-- << DML >>

desc emp;

-- ���� 1
INSERT INTO emp(empno, ename, job)
VALUES (9999,'brown', ''); -- null, ""�Է� ����

SELECT *
FROM emp
WHERE empno=9999;

-- not null�� �÷��� ��� ���� �Ұ�
-- cannot insert NULL into ("PC25"."EMP"."EMPNO")
INSERT INTO emp(ename, job)
VALUES ('brown', ''); 

rollback; -- ���


-- ���� 2
desc emp;

-- ����Ŭ���� �����ϴ� ��.
SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP' -- ã�� ���� ���̺��� �빮�ڷ� �����ش�.
ORDER BY column_id;
/*
EMPNO
ENAME
JOB
MGR
HIREDATE
SAL
COMM -- ��
DEPTNO
*/

INSERT INTO emp
VALUES (9999, 'brown', 'ranger', null, sysdate, 2500, null, 40);

SELECT *
FROM emp;

commit;

-- SELECT ���(������)�� INSERT


INSERT INTO emp(empno, ename)
SELECT deptno, dname
FROM dept;

-- UPDATE
-- UPDATE ���̺� SET �÷� = ��, �÷� = ��...
-- WHERE condition

UPDATE dept SET dname='���IT', loc='ym' -- �ѱ� �ϳ��� 3����Ʈ
WHERE deptno = 99;

SELECT *
FROM dept;


-- DELETE ���̺��
-- WHERE condition
-- �����ȣ�� 9999�� ������ emp ���̺��� ����

SELECT *
FROM emp;

DELETE emp
WHERE empno = 9999;



-- �μ� ���̺��� �̿��ؼ� emp ���̺� �Է��� 5���� �����͸� ����
-- 10, 20, 30, 40, 99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;
--�Ǵ�
DELETE emp
WHERE empno BETWEEN 10 AND 99;
--�Ǵ�
DELETE emp
WHERE empno IN(SELECT deptno FROM dept);

-- �����ϱ� �� ������ ������ Ȯ��
SELECT *
FROM emp
WHERE empno < 100;
-- �Ǵ�
select *
from emp
WHERE empno IN(SELECT deptno FROM dept);

COMMIT;

rollback;

SELECT *
FROM dept;

-- LV1 --> LV3(������ Ŀ���Ѱ� �Ⱥ���)
SET TRANSACTION
isolation LEVEL SERIALIZABLE;

-- DML������ ���� Ʈ����� ����
INSERT INTO dept
VALUES (99, 'DDIT', 'daejeon');

-- LV1(�⺻)
SET TRANSACTION
isolation LEVEL READ COMMITTED;

-- << DDL >>
-- AUTO COMMIT, ROLLBACK�� �ȵ�.
-- CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,               -- ���� Ÿ��
    ranger_name VARCHAR2(50),       --���� : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate     -- DEFAULT : SYSDATE 
);

DESC ranger;

-- ddl�� rollback�� ������� �ʴ´�.
rollback;

-- ���� ���̺� �����͸� �־��ش�.
INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES(1000, 'brown');

SELECT *
FROM ranger_new;
commit;


-- ��¥ Ÿ�Կ��� Ư�� �ʵ� ��������
-- ex : sysdate���� �⵵�� ��������
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt,
    TO_CHAR(reg_dt, 'MM'),
    EXTRACT(MONTH FROM reg_dt) mm,
    EXTRACT(YEAR FROM reg_dt) year,
    EXTRACT(DAY FROM reg_dt) day
FROM ranger_new;



-- ��������
-- DEPT ����ؼ� DEPT_TEST ����
desc dept_test;
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY,   -- deptno �÷��� �ĺ��ڷ� ����
    dname varchar2(14),             -- �ĺ��ڷ� ������ �Ǹ� ���� �ߺ��� �� �� ������, null�ϼ��� ����.
    loc varchar2(13)
);

-- primary key ���� ���� Ȯ��
-- 1. deptno�÷��� null�� �� �� ����.
-- 2. deptno�÷��� �ߺ��� ���� �� �� ����.

-- null �׽�Ʈ
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

-- �ߺ��� �׽�Ʈ
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

rollback;

-- ����� ���� �������Ǹ��� �ο��� PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

-- TABLE CONSTRAINT 
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

-- �ߺ��� �׽�Ʈ(�Ѵ� insert����)
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

SELECT *
FROM dept_test;
rollback;

-- NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, null, 'daejeon');



-- UNIQUE

DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, 'ddit', 'daejeon');
rollback;








