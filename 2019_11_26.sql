-- ���� ������ �м��Լ��� ����

SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank
FROM emp;

SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank, -- 1 2 2 4
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank, -- 1 2 2 3
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown -- 1 2  3 4
FROM emp;


-- sql ���� ppt 105p
-- Q. �ǽ� ana1
-- ����� ��ü �޿� ������ rank, dense_rank, row_number�� �̿��Ͽ� ���ϼ���.
-- �� �޿��� ������ ��� ����� ���� ����� ���������� �ǵ��� �ۼ��ϼ���.

-- �� Ǯ��
SELECT ename, sal, deptno,
       RANK() OVER (ORDER BY sal desc) rank,
       DENSE_RANK() OVER (ORDER BY sal desc) d_rank,
       ROW_NUMBER() OVER (ORDER BY sal desc) rown
FROM emp;

-- �� ��
SELECT empno, ename, sal, deptno,
       RANK() OVER (ORDER BY sal DESC, empno) rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown
FROM emp;

-- sql ���� ppt 106p
-- Q. �ǽ� no_ana2
-- ������ ��� ������ Ȱ���Ͽ� ��� ����� ���� �����ȣ, ����̸�,
-- �ش����� ���� �μ��� ��� ���� ��ȸ�ϴ� ������ �ۼ��ϼ���.

-- ���� �õ��� ��
SELECT empno, ename, deptno, count(*),
       RANK() OVER (ORDER BY sal DESC, empno) rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown
FROM emp
GROUP BY empno, ename, deptno;

-- �� ��
SELECT deptno, count(*)
FROM emp
GROUP BY deptno;

SELECT ename, empno, deptno
FROM emp;

-- join�� ���� �μ��� ���� ��
SELECT ename, empno, a.deptno, b.cnt
FROM emp a, (SELECT deptno, count(*) cnt
             FROM emp
             GROUP BY deptno) b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;

-- �м��Լ��� ���� �μ��� ���� �� (COUNT) 
-- ���� ���� ���̱� ������ ����(order by)�� �ʿ����.
SELECT ename, empno, deptno, 
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- �μ��� ����� �޿� �հ�
-- SUM �м��Լ�
SELECT ename, empno, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

-- sql ���� ppt 109p
-- Q. �ǽ� ana2
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, ���α޿�,
-- �μ���ȣ�� �ش� ����� ���� �μ��� �޿� ����� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- (�޿� ����� �Ҽ��� ��° �ڸ����� ���Ѵ�.)
SELECT empno, ename, sal, deptno,
       ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg_sal
FROM emp;

-- sql ���� ppt 110p
-- Q. �ǽ� ana3
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, ���α޿�,
-- �μ���ȣ�� �ش� ����� ���� �μ��� ���� ���� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, sal, deptno,
       MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

-- sql ���� ppt 111p
-- Q. �ǽ� ana4
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, ���α޿�,
-- �μ���ȣ�� �ش� ����� ���� �μ��� ���� ���� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, sal, deptno,
       MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

-- �μ��� �����ȣ�� ���� ���� ���
-- �μ��� �����ȣ�� ���� ���� ���
SELECT empno, ename, deptno,
       FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
       LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

-- 113p
-- LAG (������)
-- ������
-- LEAD (������)
-- �޿��� ���� ������ ���� ���� �� �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�,
-- �޿��� ���� ������ ���� ���� �� �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿� -- �ٽ� �� ����

SELECT empno, ename, sal, 
       LAG(sal) OVER (ORDER BY sal) lag_sal,
       LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

-- sql ���� ppt 116p
-- Q. �ǽ� ana5
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �Ի�����,
-- �޿�, ��ü ����� �޿� ������ 1�ܰ� ���� ����� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- (�޿��� ���� ��� �Ի����� ���� ����� ���� ����)

-- ���� Ǭ Ǯ��
SELECT empno, ename, hiredate, sal, 
       LAG(sal) OVER (ORDER BY sal) lag_sal
FROM emp
ORDER BY sal desc, hiredate;

-- �� ��
SELECT empno, ename, hiredate, sal, 
       LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp
ORDER BY sal DESC, hiredate;

-- sql ���� ppt 117p
-- Q. �ǽ� ana6
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �Ի�����,
-- ����(job), �޿������� ������(JOB)�� �޿� ������ 1�ܰ� ���� ����� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- (�޿��� ���� ��� �Ի����� ���� ����� ���� ����)

-- �� Ǯ��
SELECT empno, ename, hiredate, job, sal, 
       LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp
ORDER BY job, sal DESC;

-- �� Ǯ��
SELECT empno, ename, hiredate, job, sal, 
       LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

-- sql ���� ppt 118p
-- Q. �ǽ� no_ana6
-- ��� ����� ���� �����ȣ, ����̸�, �޿��� �޿��� ���������� ��ȸ�غ���.
-- �޿��� ������ ��� �����ȣ�� ���� ����� �켱������ ����.
-- �켱������ ���� ���� ������� ���α����� �޿� ���� ���ο� �÷��� �־��
-- widow �Լ� ���� Ǯ��

-- ���� �õ�
SELECT a.empno, a.ename, a.sal /*c_sum*/
FROM emp a, emp b 
WHERE a.empno = b.empno
ORDER BY sal, empno;

SELECT a.empno, a.ename, a.sal /*c_sum*/
FROM emp a, emp b 
WHERE a.empno = b.empno
ORDER BY sal, empno;

SELECT a.*, ROWNUM
FROM
(SELECT empno, ename, sal
FROM emp  
ORDER BY sal, empno)a, 
(SELECT empno, ename, sal
FROM emp  
ORDER BY sal, empno)b;

-- �� Ǯ��
SELECT a.empno, a.ename, a.sal, sum(b.sal) sal_sum
FROM
    (SELECT a.*, ROWNUM rn
    FROM
        (SELECT empno, ename, sal
        FROM emp  
        ORDER BY sal, empno)a)a,
    
    (SELECT b.*, ROWNUM rn
    FROM
        (SELECT empno, ename, sal
        FROM emp  
        ORDER BY sal, empno)b)b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;

-- 120p
-- WINDOWING
-- UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� ��� ��
-- CURRENT ROW : ���� ��
-- UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� ��� ��
-- N(����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
-- N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal, -- �����ϴ� �ͺ��� �ڱ������ ��
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2, -- �����ϴ°ͺ��� �����ϴ� �͵��� ��(����)
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3 -- �ڱ� ��, �ڱ�, �ڱ� �� ��ģ ��
FROM emp;

-- sql ���� ppt 126p
-- Q. �ǽ� ana7
-- �����ȣ, ����̸�, �μ���ȣ, �޿� ������ �μ����� �޿�, �����ȣ ������������ �������� ��,
-- �ڽ��� �޿��� �����ϴ� ������� �޿��� ���� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- widow �Լ� ���

SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum -- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW�� �⺻���̶� ��� ����.
FROM emp;

-- between���� �ڱ����� ���� �ʴ��� ���� �Ȱ���.
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2
FROM emp;

-- RANGE(ROWS�� RANGE�� ����)
-- ������ ���� ��ġ�̴�. ���� ���� ���� �ϳ��� ������ ����.(���� ���� ������ ���Ѹ�ŭ ������)
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2,
       SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum3,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) row_sum4
FROM emp;

