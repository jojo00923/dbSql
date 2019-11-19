-- ���� �ܹ������� ���� 

-- �������� 
-- ����ŷ, �Ƶ�����, KFC
SELECT gb, sido, sigungu
FROM fastfood
WHERE sido LIKE '����������'
AND gb IN ('����ŷ', '�Ƶ�����', 'KFC')
ORDER BY sido, sigungu, gb;

SELECT gb, sido, sigungu
FROM fastfood
WHERE sido LIKE '����������'
AND gb IN ('�Ե�����')
ORDER BY sido, sigungu, gb;

-- ���� �õ�, �ñ����� �Ե����� �Ǽ� (144��)
SELECT sido, sigungu, count(*) cnt
FROM fastfood
WHERE gb IN ('����ŷ', '�Ƶ�����', 'KFC')
GROUP BY sido, sigungu;
ORDER BY sido, sigungu, gb;

-- ���� �õ�, �ñ����� �Ե����� �Ǽ� (188��)
SELECT sido, sigungu, count(*) cnt
FROM fastfood
WHERE gb IN ('�Ե�����')
GROUP BY sido, sigungu;
ORDER BY sido, sigungu, gb;


-- ��
SELECT a.sido, a.sigungu, a.cnt, b.cnt, round(a.cnt/b.cnt, 1) point
FROM
(SELECT sido, sigungu, count(*) cnt
FROM fastfood
WHERE gb IN ('����ŷ', '�Ƶ�����', 'KFC')
GROUP BY sido, sigungu) a, 
(SELECT sido, sigungu, count(*) cnt
FROM fastfood
WHERE gb IN ('�Ե�����')
GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY point desc ;

-------------------------------------------------------------------
-- rownum ��� ����
SELECT a.empno, a.ename, a.rn, b.*
FROM
    (SELECT a.*, rownum rn
    FROM
    (SELECT emp.*
    FROM emp
    ORDER BY empno desc)a) a,
    
    (SELECT b.*, rownum rn
    FROM
    (SELECT dept.*
    FROM dept
    ORDER BY deptno DESC) b) b
WHERE a.rn = b.rn(+)
ORDER BY a.rn;
-------------------------------------------------------------------

SELECT sido, sigungu, sal, ROUND(sal/people, 2) point
FROM tax
ORDER BY sal desc; -- �������� ���Ծ� ��ŷ
--ORDER BY point desc; 

-- �������� �õ�, �ñ��� || �������� �õ� �ñ���
-- �õ�, �ñ���, ��������, �õ�, �ñ���, �������곳�Ծ�
-- ����� �߱�    5.7    ��⵵ ������   18623591


SELECT a.*, b.*
FROM
    (SELECT a.*, rownum rn
    FROM
    (SELECT a.sido, a.sigungu, round(a.cnt/b.cnt, 1) point
    FROM
    (SELECT sido, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb IN ('����ŷ', '�Ƶ�����', 'KFC')
    GROUP BY sido, sigungu) a, 
    (SELECT sido, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb IN ('�Ե�����')
    GROUP BY sido, sigungu) b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY point desc)a) a,
    
    (SELECT b.*, rownum rn
    FROM
    (SELECT sido, sigungu, sal, ROUND(sal/people, 2) point
    FROM tax
    ORDER BY sal desc) b) b
WHERE a.rn = b.rn;

-- �� �� (���ù������� ����Ǯ��) --
SELECT a.*, b.*
FROM 
    (SELECT a.*, ROWNUM RN 
     FROM
        (SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l,
               round(a.cnt/b.cnt, 2) point
        FROM 
            --140��
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM fastfood
            WHERE gb IN ('KFC', '����ŷ', '�Ƶ�����')
            GROUP BY SIDO, SIGUNGU) a,
            
            --188��
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM fastfood
            WHERE gb IN ('�Ե�����')
            GROUP BY SIDO, SIGUNGU) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu
        ORDER BY point DESC )a ) a,
    
    (SELECT b.*, rownum rn
    FROM 
    (SELECT sido, sigungu
    FROM TAX
    ORDER BY sal DESC) b ) b
WHERE b.rn = a.rn(+)
ORDER BY b.rn;

---------------------------------------------------------
-- SQL ���� PPT

DROP TABLE emp_test;

-- multiiple insert�� ���� �׽�Ʈ ���̺� ����
-- empno, ename �� ���� �÷��� ���� emp_test, emp_test2 ���̺��� 
-- emp ���̺�κ��� �����Ѵ� (CTAS)
-- �����ʹ� �������� �ʴ´�.

CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp
WHERE 1=2;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

-- INSERT ALL
-- �ϳ��� INSERT SQL �������� ���� ���̺� �����͸� �Է�
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;

-- INSERT ������ Ȯ��
SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

-- INSERT ALL �÷� ����
ROLLBACK;

-- multiple insert (unconditional insert)
INSERT ALL
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL    
SELECT 2 empno, 'sally' ename FROM dual;    

-- multiple insert (conditional insert)
ROLLBACK;
INSERT ALL
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE    -- ������ ������� ���� ���� ����
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL    
SELECT 2 empno, 'sally' ename FROM dual;  

-- INSERT FIRST
-- ���ǿ� �����ϴ� ù��° INSERT ������ ����
INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test (empno) VALUES (empno) -- �����ȣ�� �Է�
    WHEN empno > 5 THEN   
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual;  

SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

-- << MERGE >>
-- ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
-- ���ǿ� �����ϴ� �����Ͱ� ������ INSERT

-- empno�� 7369�� �����͸� emp ���̺�κ��� emp_test���̺�  ����(insert)
INSERT INTO emp_test 
SELECT empno, ename
FROM emp
WHERE empno=7369;

SELECT *
FROM emp_test;

-- emp���̺� ������ �� emp_test ���̺��� empno�� ���� ���� ���� �����Ͱ� ���� ���
-- emp_test.ename = ename || '_merge' ������ update
-- �����Ͱ� ���� ��쿡�� emp_test���̺� insert
ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));
-- TABLE
MERGE INTO emp_test
USING emp -- TABLE, VIEW, SUB_QUERY �� �� ����
 ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);

-- VIEW    ~~~~~~~~~~~~~~~~~~~
MERGE INTO emp_test
USING 
(SELECT *
 FROM emp
 WHERE emp.empno IN(7369,7499)) emp
 ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);
    

-- �ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������
-- merge �ϴ� ���
ROLLBACK;

-- empno = 1, ename = 'brown'
-- empno�� ���� ���� ������ ename�� 'brown'���� update
-- empno�� ���� ���� ������ �ű� insert

MERGE INTO emp_test
USING dual
 ON (emp_test.empno = 1) -- empno�� 1�� ������
WHEN MATCHED THEN -- empno�� 1�� �����Ͱ� �ִ� ���
    UPDATE SET ename = 'brown'  || '_merge' -- on������ ���� �÷��� ������Ʈ �ȵ�
WHEN NOT MATCHED THEN    -- empno�� 1�� �����Ͱ� ���� ���
    INSERT VALUES (1, 'brown');

SELECT *
FROM emp_test;    

-- MERGE�� �Ⱦ� ��� ������ ���� ������ ������ ����Ѵ�.
SELECT 'X'
FROM emp_test
WHERE empno = 1;

UPDATE emp_test SET ename = 'brown' || '_merge'
WHERE empno = 1;

INSERT INTO emp_test VALUES (1, 'brown');

-- report group function ppt 17p
-- Q. �׷캰 �հ�, ��ü �հ踦 ������ ���� ���Ϸ���? (�ǽ� GROUP_AD1)
-- table : emp

-- ���� Ǯ�� �� (�̿ϼ�)
SELECT deptno, sum(sal)
FROM emp 
WHERE deptno = deptno
GROUP BY deptno;

-- �� ��
-- �μ��� �޿��� ��
SELECT deptno, sum(sal)
FROM emp 
GROUP BY deptno

UNION ALL

-- ��� ������ �޿��� ��
SELECT null, sum(sal) sal
FROM emp ;

-- << rollup >>
-- group by�� ���� �׷��� ����
-- GROUP BY ROLLUP ( {col,})
-- �÷��� �����ʿ������� �����ذ��鼭 ���� ����׷���
-- GROUP BY �Ͽ� UNION�� �Ͱ� ����
-- ex : GROUP BY ROLLUP (job, deptno)
--      GROUP BY job, deptno
--      UNION
--      GROUP BY job
--      UNION
--      GROUP BY --> �Ѱ� (��� �࿡ ���� ����)

SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


-- �Ʒ� ������ rollup ���·� ����

SELECT deptno, sum(sal)
FROM emp 
GROUP BY ROLLUP (deptno);

-- << GROUPING SETS >>
-- GROUPING SETS (col1, col2 ...)
-- grouping sets�� ������ �׸��� �ϳ��� ����׷����� group by���� �̿�ȴ�.

-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2
-- �� �����ϴ�.

-- emp ���̺��� �̿��Ͽ� �μ��� �޿��հ�, ������(job)�� �޿����� ���Ͻÿ�.
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno;

SELECT job, SUM(sal)
FROM emp
GROUP BY job;

-- �μ���ȣ, job, �޿��հ�
SELECT deptno, null job, SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, job, SUM(sal)
FROM emp
GROUP BY job;

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job);

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job, (deptno, job));

