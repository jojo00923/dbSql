-- �ε��� ����� ��
-- UNIQUE �������� ���� �ڵ� ����
-- CREATE INDEX�� ���� ����

-- emp ���̺� empno�÷��� �������� PRIMARY KEY�� ����
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE ==> �ش� �÷����� UNIQUE INDEX�� �ڵ����� ����


-- << UNIQUE �ε��� ����  >>
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

-- �ε����� empno�� 7782�� �����ͷ� �ٷ� ���� ����.
SELECT *
FROM TABLE(dbms_xplan.display);

-- empno �÷����� �ε����� �����ϴ� ��Ȳ����
-- �ٸ� �÷� ������ �����͸� ��ȸ�ϴ� ���
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

-- job�� MANAGER�� 14���� �����͸� �а� ������ �����ʹ� �����ž�
SELECT *
FROM TABLE(dbms_xplan.display);


-------------------------------------------------------
-- TABLE ���� (���������� ���� �ε����� ������ ����X)
--> TABLE ACCESS FULL

-- ���� ������ ����

-- 2. ù��° �ε��� 
--> TABLE ACCESS FULL
--  ù��° �ε���

-- 2. �ι�° �ε��� 
--> TABLE ACCESS FULL
--  ù��° �ε���
--  �ι�° �ε���

-- 2. ����° �ε��� (���� 4��)
--> TABLE ACCESS FULL
--  ù��° �ε���
--  �ι�° �ε���
--  ����° �ε���

-- �ε����� 3���� ��,
-- ���̺� 2�� ���ν� : 16�� ���� ���� (4 * 4)
-- ���̺� 3�� ���ν� : 64�� ���� ���� (4 * 4 * 4)
-- ���̺� 4�� ���ν� : 256�� ���� ���� (4 * 4 * 4 * 4)
-----------------------------------------------------

-- �ε��� ���� �÷������� SELECT���� ����� ���
-- ���̺� ������ �ʿ� ����.

EXPLAIN PLAN FOR
SELECT empno         -- *�� �ƴ϶� PK�� ������.
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);



-- �÷��� �ߺ��� ������ non-unique �ε��� ���� ��
-- unique index���� �����ȹ ��
-- PRIMARY KEY �������� ����(unique �ε��� ����)
ALTER TABLE emp DROP CONSTRAINT pk_emp;








-- << NONUNIQUE �ε��� ���� >>
CREATE /*UNIQUE*/ INDEX IDX_EMP_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);
-- empno���� �������� non-unique�ε��� ���� => empno ���� �������� ����(�⺻ ��������, �ɼ��� ���� ���������� ����)
-- ������ �Ǿ� �־ 7782�� �˻��ϰ� 7782�� �ٸ� ���� ���ö������� �˻��ϰ� ��ħ
-- |*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |

-- emp ���̺� job �÷����� �ι�° �ε��� ���� (non-unique index)
-- job �÷��� �ٸ� �ο��� job �÷��� �ߺ��� ������ �÷��̴�.
CREATE INDEX idx_emp_02 ON emp(job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);
-- |*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);








-- << emp ���̺� job, ename �÷��� �������� non-unique �ε��� ���� >>
CREATE INDEX IDX_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

-- ppt 378
-- MANAGER�̸鼭 C�� �����ϴ� �����ͺ��� ����. (MANAGER�鼭 BLAKE�� �����ʹ� ���� ����.) MANAGER���� �� ������(���⼱ JONES����) ����. (C�� �����ϴ� �ֵ��� ���� �� �����ϱ�.)
------------------------------------------------------------------------------------------
Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
------------------------------------------------------------------------------------------







-- << emp ���̺� ename, job �÷����� non-unique �ε��� ���� >>
CREATE INDEX IDX_EMP_04 ON emp (ename, job);

-- ���� �÷��� ename�� �Ϻ��ϰ� ������ �ʾ��� ��, �����÷��� �Ϻ��ϰ� �������Ŷ�� �����ϰ� ����. �ε����� �� �о����.
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename LIKE '%C'
AND job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);





-- HINT�� ����� �����ȹ ����

EXPLAIN PLAN FOR
SELECT /*+ INDEX ( emp idx_emp_04 ) */ * -- �ּ��ε�  +�� ������ �����ڰ� ������ ����� �ϴ±��� �ϰ� ������. ������ �߸��Ǿ��� ���� ������.
FROM emp
WHERE ename LIKE '%C'
AND job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

-- Q. DDL (Index �ǽ� idx1)
-- CREATE TABLE dept_test AS SELECT *FROM dept WHERE 1 = 1 �������� dept_test ���̺� ���� ��
-- ���� ���ǿ� �´� �ε����� �����ϼ���.

CREATE TABLE dept_test AS 
SELECT *
FROM dept
WHERE 1 = 1;

-- deptno �÷��� �������� unique �ε��� ����
CREATE UNIQUE INDEX idx_emp_test_01
ON dept_test (deptno);

-- dname �÷��� �������� non_unique �ε��� ����
CREATE INDEX idx_emp_test_02
ON dept_test (dname);

-- deptno, dname �÷��� �������� non-unique �ε��� ����
CREATE INDEX idx_dept_test_03
ON dept_test (deptno, dname);

-- �ε����� �߸� ��� ���� �� �ٽ� ����
DROP INDEX idx_emp_test_01;
DROP INDEX idx_emp_test_02;
CREATE UNIQUE INDEX idx_dept_test_01
ON dept_test (deptno);
CREATE INDEX idx_dept_test_02
ON dept_test (dname);

-- Q. DDL (Index �ǽ� idx2)
-- �ǽ� idx1���� ������ �ε����� �����ϴ� DDL���� �ۼ��ϼ���.
DROP INDEX idx_dept_test_01;
DROP INDEX idx_dept_test_02;
DROP INDEX idx_dept_test_03;

-- Q. DDL (Index �ǽ� idx3)
-- �ý��ۿ��� ����ϴ� ������ ������ ���ٰ� �� �� ������ emp ���̺� 
-- �ʿ��ϴٰ� �����Ǵ� �ε����� ���� ��ũ��Ʈ�� ����� ������
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7298;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename = 'SCOTT';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal BETWEEN 500 AND 7000
AND deptno = 20;

EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = 10
AND emp.empno LIKE '78%';

EXPLAIN PLAN FOR
SELECT b.*
FROM emp a, emp b
WHERE a.
`   



= b.empno
AND a.deptno = 30;

SELECT *
FROM TABLE (dbms_xplan.display);

--------------------
DROP INDEX idx_emp_01; -- nonunique�ε� �÷��� ���ļ� ����.

-- �� , ���� ��
CREATE UNIQUE INDEX idx_emp_05 ON emp (empno);
CREATE UNIQUE INDEX idx_emp_06 ON emp (ename, empno);
CREATE UNIQUE INDEX idx_emp_07 ON emp (deptno, sal, empno);
CREATE UNIQUE INDEX idx_emp_dept_08 ON emp (deptno, empno);
CREATE UNIQUE INDEX idx_emp_emp_09 ON emp (empno, deptno);

-- �� ��
CREATE UNIQUE INDEX idx_emp_05 ON emp (empno);
CREATE UNIQUE INDEX idx_emp_06 ON emp (ename);
CREATE UNIQUE INDEX idx_emp_07 ON emp (deptno, sal, empno);
--CREATE UNIQUE INDEX idx_emp_dept_08 ON emp (deptno, empno); ���� ���� �ε����� ���
CREATE UNIQUE INDEX idx_emp_emp_09 ON emp (deptno, mgr);

















