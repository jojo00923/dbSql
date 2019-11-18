-- java

insert into lprod (lprod_id, lprod_gu, lprod_nm) values (101, 'N101', '��깰');
rollback;

DELETE FROM lprod 
WHERE lprod_id IN (101, 102, 103);
COMMIT;

select max(lprod_id) from lprod;

insert into lprod values (, " + gu + ", " + nm + " );

insert into lprod values ((select max(lprod_id) from lprod) + 1,'P101\','���ƶ�57');


------------------------------------------------------------------------------------
-- �������� Ȱ��ȭ / ��Ȱ��ȭ
-- � ���������� Ȱ��ȭ(��Ȱ��ȭ) ��ų ���??

-- emp fk���� (dept���̺��� deptno�÷� ����)
-- FK_EMP_DEPT ��Ȱ��ȭ
ALTER TABLE emp DISABLE CONSTRAINT fk_emp_dept;

-- �������ǿ� ����Ǵ� �����Ͱ� �� �� ���� ������?
INSERT INTO emp (empno, ename, deptno)
VALUES (9999, 'brown', 80);

-- FK_EMP_DEPT Ȱ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;

-- �������ǿ� ����Ǵ� ������ (�Ҽ� �μ���ȣ�� 80���� ������)��
-- �����Ͽ� �������� Ȱ��ȭ �Ұ�
DELETE emp
WHERE empno = 9999;

-- FK_EMP_DEPT Ȱ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;
COMMIT;

-- ���� ������ �����ϴ� ���̺� ��� VIEW : USER_TABLES
-- ���� ������ �����ϴ� �������� VIEW : USER_CONSTRAINTS
-- ���� ������ �����ϴ� ���������� �÷�  VIEW : USER_CONS_COLUMNS

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CYCLE';

-- FK_EMP_DEPT
SELECT *
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME='FK_EMP_DEPT';

-- ���̺� ������ �������� ��ȸ (VIEW ����)
-- ���̺� �� / �������� �� / �÷��� / �÷� ������

SELECT a.table_name, a.constraint_name, b.column_name, b.position
FROM user_constraints a, user_cons_columns b
WHERE a.constraint_name = b.constraint_name
AND a.constraint_type = 'P' -- PRIMARY KEY�� ��ȸ;
ORDER BY a.table_name, b.position;

-- emp ���̺�� 8���� �÷� �ּ��ޱ�
-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO

-- ���̺� �ּ� view : USER_TAB_COMMENTS

-- emp ���̺� �ּ� ���� Ȯ���ϱ�
SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

-- emp ���̺� �ּ� �Է��ϱ�
COMMENT ON TABLE emp IS '���';


-- emp ���̺��� �÷� �ּ� ���� Ȯ���ϱ�
SELECT *
FROM user_col_comments
WHERE table_name = 'EMP';

-- emp ���̺��� �÷� �ּ�  �Է��ϱ�
-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO
COMMENT ON COLUMN emp.empno IS '�����ȣ';
COMMENT ON COLUMN emp.ename IS '�̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '������ ���';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '��';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';

-- Q. DDL (Table - comments �ǽ� comment1)
-- user_tab_comments, user_col_comments view�� �̿��Ͽ�
-- customer, product, cycle, daily ���̺�� �÷��� �ּ�������
-- ��ȸ�ϴ� ������ �ۼ��϶�.
SELECT a.table_name, a.table_type, a.comments tab_comment , b.column_name, b.comments col_comment
FROM user_tab_comments a, user_col_comments b
WHERE a.table_name = b.table_name
AND a.table_name IN ('CUSTOMER','PRODUCT','CYCLE','DAILY');


-- << VIEW >> 

-- emp���̺��� sal, comm ����� (�޿� �� �������� �Ⱥ����ְ� ������ ��� �ұ�?)
-- view ���� (emp���̺��� sal, comm �ΰ� �÷��� �����Ѵ�.)
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

-- INLINE VIEW�� ���� �� (���� ������ ���̺�� �����ϴ�)
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp);
      
-- VIEW(�� �ζ��κ�� �����ϴ�)
SELECT *
FROM v_emp;
      
-- ���ε� ���� ����� view�� ���� : v_emp_dept
-- emp, dept : �μ���, �����ȣ, �����, ������, �Ի�����
SELECT a.dname, b.empno, b.ename, b.job, b.hiredate
FROM dept a, emp b
WHERE a.deptno = b.deptno;

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT a.dname, b.empno, b.ename, b.job, b.hiredate
FROM dept a, emp b
WHERE a.deptno = b.deptno;

SELECT *
FROM v_emp_dept;

-- VIEW ����
DROP VIEW v_emp;

-- VIEW�� �����ϴ� ���̺��� �����͸� �����ϸ� VIEW���� ������ ����.
-- dept 30 - SALES
SELECT *
FROM v_emp_dept; 

SELECT *
FROM dept;

-- dept���̺��� SALES --> MARKET SALES
UPDATE dept SET dname = 'MARKET SALES'
WHERE deptno = 30;

rollback;

-- HR �������� v_emp_dept view ��ȸ������ �ش�.
GRANT SELECT ON v_emp_dept TO hr;

-- << SQUENCE >> -- �������� �ѹ��� �ȵȴ�.

-- SEQUENCE ���� (�Խñ� ��ȣ �ο��� ������)
CREATE SEQUENCE seq_post
INCREMENT BY 1
START WITH 1;

-- �Խñ�
SELECT seq_post.nextval
FROM dual;

-- �Խñ� ÷������
-- ���� ���� ���� Ȯ��
SELECT seq_post.currval
FROM dual;

SELECT *
FROM post
WHERE reg_id = 'brown'
AND title = '�������� �����'
AND reg_dt = TO_DATE('2019/11/14 15:40:15','YYYY/MM/DD HH24:MI:SS');

-- sequence�� �̷��� ���־ ���� ������ �� ����� �� �ִ�.
SELECT *
FROM post
WHERE post_id = 1;

-- ������ ����
-- ������ : �ߺ����� �ʴ� ���� ���� ���� ���ִ� ��ü
-- 1, 2, 3...

SELECT *
FROM emp_test;
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(15)
);
INSERT INTO emp_test VALUES (�ߺ����� �ʴ� ��, 'brown');

-- ��� 3����
-- 1. ���� �Է��ϴ� ���
-- 2. UUID.randomUUID().toString() // �ڹٿ��� ����ϴ� �ߺ����� �ʴ� �� �������ִ� �޼���
-- 3. sequence

-- 3
CREATE SEQUENCE seq_emp_test;
INSERT INTO emp_test VALUES (seq_emp_test.nextval, 'brown');

SELECT *
FROM emp_test;

-- << index >>
-- rowid : ���̺� ���� ������ �ּ�, �ش� �ּҸ� �˸�
-- ������ ���̺� �����ϴ� ���� �����ϴ�.

SELECT product.*, ROWID
FROM product
WHERE ROWID = 'AAAFM+AAFAAAAFNAAA';

-- table : pid, pnm
-- pk_product : pid
SELECT pid
FROM product
WHERE ROWID = 'AAAFM+AAFAAAAFNAAA';

-- �����ȹ�� ���� �ε��� ��뿩�� Ȯ��
-- emp ���̺� empno �÷��� �������� �ε����� ���� ��
ALTER TABLE emp DROP CONSTRAINT pk_emp;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

-- �ε����� ���� ������ empno = 7369�� �����͸� ã�� ����
-- emp ���̺��� ��ü�� ã�ƺ��� �Ѵ�. => TABLE FULL SCAN

SELECT *
FROM TABLE(dbms_xplan.display);

