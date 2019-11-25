-- �� ���� --
-- member ���̺��� �̿��Ͽ� member2 ���̺��� ����
-- member2 ���̺���
-- ������ ȸ��(mem_id='a001')�� ����(mem_job)�� '����'���� ���� ��
-- commit�ϰ� ��ȸ

SELECT *
FROM member;

CREATE TABLE member2 AS
SELECT *
FROM member;

SELECT *
FROM member2;

UPDATE member2 SET mem_job = '����'
WHERE mem_id = 'a001';
commit;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id = 'a001';

-- ��ǰ�� ��ǰ ���� ����(buy_qty) �հ�, ��ǰ ���� �ݾ�(buy_cost) �հ�
-- ��ǰ�ڵ�, ��ǰ��, �����հ�, �ݾ��հ�

SELECT *
FROM prod;
SELECT *
FROM buyprod;

SELECT buy_prod, SUM(buy_qty), SUM(buy_cost)
FROM buyprod
GROUP BY buy_prod
ORDER BY buy_prod;

-- ���� Ǭ ��
SELECT buy_prod, prod.prod_name, SUM(buy_qty), SUM(buy_cost)
FROM buyprod, prod
WHERE buyprod.buy_prod = prod.prod_id
GROUP BY buy_prod, prod_name
ORDER BY buy_prod;

-- �� ��
SELECT buy_prod, b.prod_name, sum_qty, sum_cost
FROM 
(SELECT buy_prod, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
FROM buyprod
GROUP BY buy_prod)a, prod b 
WHERE a.buy_prod = b.prod_id;

-- VW_PROD_BUY(view ����)
CREATE VIEW VW_PROD_BUY AS  -- CREATE OR REPLACE VIEW VW_PROD_BUY AS
SELECT buy_prod, prod.prod_name, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost 
FROM buyprod, prod
WHERE buyprod.buy_prod = prod.prod_id
GROUP BY buy_prod, prod_name
ORDER BY buy_prod;

-- �����Ǿ��ִ� �� Ȯ��
SELECT *
FROM USER_VIEWS;

---------------------------------------------------------------------

-- �м��Լ� / window �Լ� (�����غ��� �ǽ� ana0)
-- ����� �μ��� �޿�(sal)�� ���� ���ϱ�
-- emp ���̺� ���

-- ���� �õ� ��
SELECT *
FROM emp;


SELECT a.ename, a.sal, a.deptno
FROM
(SELECT ename, sal, deptno
FROM emp
GROUP BY ename, sal, deptno)a
ORDER BY deptno;

SELECT b.*
FROM
(SELECT COUNT(*) cnt
FROM emp
GROUP BY deptno)b;


SELECT a.ename, a.sal, a.deptno, (SELECT COUNT(*) cnt
                                    FROM emp
                                    WHERE a.deptno = deptno
                                    GROUP BY deptno) rank
FROM
(SELECT ename, sal, deptno
FROM emp
GROUP BY ename, sal, deptno)a
ORDER BY deptno;


--- �� ��

-- �μ��� ��ŷ
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
    FROM
    (SELECT ename, sal, deptno
    FROM emp
    ORDER BY deptno, sal desc)a)a,

(SELECT b.rn, ROWNUM j_rn
FROM
(SELECT a.deptno, b.rn
FROM
    (SELECT deptno, COUNT(*) cnt -- 3, 5, 6
    FROM emp
    GROUP BY deptno)a,
    (SELECT ROWNUM rn -- 1~14
    FROM emp) b
WHERE a.cnt >= b.rn
ORDER BY a.deptno, b.rn)b)b
WHERE a.j_rn = b.j_rn;

--�μ��� ��ŷ
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
     FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) a ) a, 
(SELECT b.rn, ROWNUM j_rn
FROM 
(SELECT a.deptno, b.rn 
 FROM
    (SELECT deptno, COUNT(*) cnt --3, 5, 6
     FROM emp
     GROUP BY deptno )a,
    (SELECT ROWNUM rn --1~14
     FROM emp) b
WHERE  a.cnt >= b.rn
ORDER BY a.deptno, b.rn ) b ) b
WHERE a.j_rn = b.j_rn;

-- �м��Լ��� ����� ��
SELECT ename, sal, deptno, 
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;       
       