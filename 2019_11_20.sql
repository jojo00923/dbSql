-- GROUPING (cube, rollup ���� ���� �÷�)
-- �ش� �÷��� �Ұ� ��꿡 ���� ��� 1
-- ������ ���� ��� 0

-- job �÷�
-- case1.GROUPING(job)= 1 AND GROUPING(deptno) = 1
--       job --> '�Ѱ�'
-- case else
--       job --> job

-- ���� ����
SELECT job, deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


-- job�÷� �ϳ��� ��� �� ��.
SELECT CASE WHEN GROUPING(job) = 1 AND 
                 GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE job
       END AS job, deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


-- Q. GROUPING(deptno)�� 1�� ��� deptno�� job�� +  �Ұ谡 ������ �����

SELECT CASE 
            WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE job
       END AS job, 
       CASE 
            WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 1 THEN job || '�Ұ�'
            ELSE TO_CHAR(DEPTNO)
       END AS deptno, 
       GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

-- Q. report group function ( �ǽ� GROUP_AD3) P25
-- table: emp
-- ���� group by���� �ѹ��� ���
SELECT deptno, job, sum(sal) sal 
FROM emp
GROUP BY ROLLUP (deptno, job);

-- ����
-- Q. report group function ( �ǽ� GROUP_AD4) P26
-- Q. report group function ( �ǽ� GROUP_AD5) P27

-- << CUBE (col1, col2..) >>
-- CUBE���� ������ �÷��� ������ ��� ���տ� ���� ���� �׷����� ����
-- CUBE�� ������ �÷��� ���� ���⼺�� ����(rollup���� ����)
-- GROUP BY CUBE(job, deptno)
-- oo : GROUP BY job, deptno
-- ox : GROUP BY job
-- xo : GROUP BY deptno
-- xx : GROUP BY        -- ��� �����Ϳ� ���ؼ�..

-- GROUP BY CUBE(job, deptno, mgr) -- 2�� 3��, 8����

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);
--- ���� ����

-----------------------------------------------------------------------------------------

--subquery�� ���� ������Ʈ
DROP TABLE emp_test;

--emp���̺��� �����͸� �����ؼ� ��� �÷��� emp_table�� ����
CREATE TABLE emp_test AS
SELECT *
FROM emp;

-- emp_test ���̺��� dept���̺��� �����ǰ� �ִ� dname(VARCHAR2(14)) �÷��� �߰�
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

-- emp_test ���̺��� dname�÷��� dept ���̺��� dname �÷� ������ ������Ʈ�ϴ� ���� �ۼ�
UPDATE emp_test SET dname = ( SELECT dname
                              FROM dept
                              WHERE d
                              ept.deptno = emp_test.deptno);
-- WHERE empno IN (7369, 7499); --  Ư�� �÷��� ���ؼ��� �ְ� ������
COMMIT;

-- Q. �������� ADVANCED (correlated subquery update �ǽ� sub_a1) P42
-- dept���̺��� �̿��Ͽ� dept_test ���̺� ����
-- dept_test ���̺� empcnt (number) �÷� �߰�
-- subquery�� �̿��Ͽ� dept_test ���̺��� empcnt �÷��� 
-- �ش� �μ��� ���� update������ �ۼ��ϼ���.
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

SELECT *
FROM dept_test;

-- 10�� �μ��� �μ��� �� ���ϴ� ����
SELECT count(deptno)
FROM emp_test
WHERE deptno = 10;

ALTER TABLE dept_test ADD (empcnt NUMBER);



-- dept_test���̺��� empcnt �÷��� emp���̺��� �̿��Ͽ� (subquery) update
UPDATE dept_test SET empcnt = (SELECT count(*)
                                FROM emp
                                WHERE deptno = dept_test.deptno);

-- ���̴� ��������null                                
UPDATE dept_test SET empcnt = (SELECT count(deptno)
                                FROM emp_test
                                WHERE dept_test.deptno = emp_test.deptno
                                GROUP BY deptno);
                                

rollback;                                
--------------------------------------------------------------------------------
SELECT *
FROM dept_test;


-- Q. �������� ADVANCED(correlated subquery delete �ǽ� sub_a2)
-- dept ���̺��� �̿��Ͽ� dept_test ���̺� ����
-- dept_test ���̺� �ű� ������ 2�� �߰�(���� 99�־ 1�Ǹ� �߰�)
INSERT INTO dept_test VALUES (98, 'it', 'daejeon', 0);
-- emp���̺��� �������� ������ ���� �μ� ���� �����ϴ� ������ 
-- ���������� �̿��Ͽ� �ۼ��ϼ���.
DELETE FROM dept_test 
WHERE empcnt = 0;

-- ����� ���� �μ����� ��ȸ
SELECT *
FROM dept 
WHERE NOT EXISTS (SELECT 'x'
                  FROM emp
                  WHERE emp.deptno = dept.deptno);
              
DELETE dept_test 
WHERE NOT EXISTS (SELECT 'x'
                  FROM emp
                  WHERE emp.deptno = dept_test.deptno);              

DELETE dept_test 
WHERE empcnt = (SELECT COUNT(*)
                FROM emp
                WHERE emp.deptno = dept_test.deptno
                GROUP BY deptno);    
                                
rollback;






