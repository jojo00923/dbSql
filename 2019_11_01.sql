-- ����
-- WHERE
-- ������
-- �� : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' (%: �ټ��� ���ڿ��� ��Ī, _ : ��Ȯ�� �ѱ��� ��Ī)
-- IS NULL (!= NULL�� �ȵ�)
-- AND, OR, NOT

-- Q. emp ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ�
-- ���� ������ȸ
-- BETWEEN AND
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01', 'YYYY/MM/DD')
                   AND TO_DATE('1986/12/31', 'YYYY/MM/DD');
-- >=, <=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD')
  AND hiredate <= TO_DATE('1986/12/31', 'YYYY/MM/DD');

-- Q. emp ���̺��� ������(mgr)�� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- Q. �ǽ�13 ) ������ (AND, OR �ǽ�)
-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ������ ���� ��ȸ�ϼ���. 
-- (like �����ڸ� ������� ������. empno�� ���� 4�ڸ����� ��� 78,780,789)
-- empno : 7800 ~ 7899
--         780 ~ 789
--         7~78
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  OR empno / 100 >= 78 
  AND empno / 100 < 79 ;
  
-- �� ��
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  OR empno BETWEEN 7800 AND 7899
  OR empno BETWEEN 780 AND 789
  OR empno BETWEEN 78 AND 79;

-- ������ �켱���� AND�� OR���� ����.
  -- Q. �ǽ�13 ) ������ (AND, OR �ǽ�)
-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ������ ���� ��ȸ�ϼ���. 
-- (like �����ڸ� ������� ������. empno�� ���� 4�ڸ����� ��� 78,780,789) 
   
-- Q. �ǽ�14 ) ������ (AND, OR �ǽ�)
-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϸ鼭 �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���. 
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR (empno LIKE '78%'
  AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD'));
  
-- order by �÷��� | ��Ī | �÷��ε��� [ASC | DESC]
-- order by ������ WHERE�� ������ ���
-- WHERE ���� ���� ��� FROM�� ������ ���
-- emp���̺��� ename �������� �������� ����
SELECT *
FROM emp
ORDER BY ename ASC; -- ASC(�⺻ ��������)

-- �̸�(ename)�� �������� ��������
SELECT *
FROM emp
ORDER BY ename DESC;

-- job�� �������� ������������ ����, ���� job�� ���� ���
-- ���(empno)���� �ø����� ����
SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

-- ��Ī���� �����ϱ�
-- ��� ��ȣ(empno), �����(ename), ����(sal * 12) as year_sal
-- year_sal ��Ī���� �������� ����
SELECT empno, ename, sal, sal *12 AS year_sal
FROM emp
ORDER BY year_sal ASC;

-- SELECT�� �÷� ���� �ε����� ����
SELECT empno, ename, sal, sal *12 AS year_sal
FROM emp
ORDER BY 2;

-- Q. �ǽ�1 ) ������ ���� (ORDER BY �ǽ�)
-- dept ���̺��� ��� ������ �μ��̸����� �������� ���ķ� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
SELECT *
FROM dept
ORDER BY dname ASC;

-- Q. dept ���̺��� ��� ������ �μ���ġ�� �������� ���ķ� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
SELECT *
FROM dept
ORDER BY loc DESC;

-- �÷����� ������� �ʾҽ��ϴ�. ���� �����ð��� ��� �������� �ùٸ� �÷��� ã�ƺ�����.

-- Q. �ǽ�2 ) ������ ���� (ORDER BY �ǽ�)
-- emp ���̺��� ��(comm) ������ �ִ� ����鸸 ��ȸ�ϰ�,
-- ��(comm)�� ���� �޴� ����� ���� ��ȸ�ǵ��� �ϰ�, �󿩰� ���� ���
-- ������� �������� �����ϼ���.
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno ASC;

-- Q. �ǽ�3 ) ������ ���� (ORDER BY �ǽ�)
-- emp ���̺��� �����ڰ� �ִ� ����鸸 ��ȸ�ϰ�, ����(job) ������
-- �������� �����ϰ�, ������ ���� ��� ����� ū ����� ���� ��ȸ�ǵ���
-- ������ �ۼ��ϼ���.
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

-- Q. �ǽ�4 ) ������ ���� (ORDER BY �ǽ�)
-- emp ���̺��� 10�� �μ�(deptno)Ȥ�� 30�� �μ��� ���ϴ� ��� �� 
-- �޿�(sal)�� 1500�� �Ѵ� ����鸸 ��ȸ�ϰ� �̸����� �������� ���ĵǵ���
-- ������ �ۼ��Ͻÿ�.
SELECT *
FROM emp
--WHERE deptno IN (10, 30)
WHERE (deptno = 10 OR deptno = 30)
  AND sal > 1500
ORDER BY ename desc;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 10;

-- emp ���̺��� ���(empno), �̸�(ename)�� �޿� �������� �������� �����ϰ�
-- ���ĵ� ��������� ROWNUM

-- �߸��� ��
SELECT ROWNUM, empno, ename, sal
FROM emp
ORDER BY sal;

-- �ߵ� ��
SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a;

-- Q. �ǽ�1 ) ������ ���� (ROWNUM �ǽ�) 84p
-- emp ���̺��� ROWNUM���� 1~10�� ���� ��ȸ�ϴ� ������ �ۼ��غ�����.
-- (���ľ��� �����ϼ���, ����� ȭ��� �ٸ� �� �ֽ��ϴ�.) 
SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a
WHERE ROWNUM <= 10;

-- Q. �ǽ�2 ) ������ ���� (ROWNUM �ǽ�) 86p
-- ROWNUM ���� 11~14�� ���� ��ȸ�ϴ� ������ �ۼ��غ�����.
-- HINT : alias, inline-view
SELECT b.*
FROM
(SELECT ROWNUM rn, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a
WHERE ROWNUM BETWEEN 1 AND 14) b
WHERE rn BETWEEN 11 AND 14;

--�� ��
SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a)
WHERE rn BETWEEN 11 AND 14;

-- FUNCTION
-- DUAL ���̺� ��ȸ
SELECT 'HELLO WORLD' as msg
FROM DUAL;

-- ���ڿ� ��ҹ��� ���� �Լ�
-- LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('hello, world')
FROM dual;

SELECT LOWER('Hello, World')
FROM dual;

SELECT UPPER('Hello, World')
FROM dual;

SELECT INITCAP('hello, world')
FROM dual;

-- FUNCTION�� WHERE�������� ��밡��
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith'; -- ename�÷� �ȿ� �ִ� �����͵��� �ҹ��ڷ� ��ȯ�Ѵ��� ���ϴ� ��.

-- ������ SQL ĥ������
-- 1.�º��� �������� ���ƶ�
-- �º�(TAVLE�� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
-- Function Based Index -> FBI

-- CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ�
SELECT CONCAT('HELLO', ', WORLD')
FROM dual;

SELECT CONCAT(CONCAT('HELLO', ',') , ' WORLD')
FROM dual;

-- SUBSTR : ���ڿ��� �κ� ���ڿ� (java : String.substring)
-- LENGTH : ���ڿ��� ����
-- INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
-- LPAD : ���ڿ��� Ư�� ���ڿ��� ����
SELECT CONCAT(CONCAT('HELLO', ',') , ' WORLD') CONCAT, -- HELLO, WORLD
       SUBSTR('HELLO, WORLD', 0, 5) substr, -- HELLO
       SUBSTR('HELLO, WORLD', 1, 5) substr1, -- HELLO
       LENGTH('HELLO, WORLD') length, -- 12
       INSTR('HELLO, WORLD', 'O') instr,  -- 5
       -- INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
       INSTR('HELLO, WORLD', 'O', 6) instr1 , -- 9
       -- LPAD(���ڿ�, ��ü ���ڿ�����, ���ڿ��� ��ü���ڿ����̿� ��ġ�� ���� ��� �߰��� ����);
       LPAD('HELLO, WORLD', 15, '*') lpad, -- ***HELLO, WORLD
       LPAD('HELLO, WORLD', 15) lpad, --    HELLO, WORLD
       LPAD('HELLO, WORLD', 15) lpad, --    HELLO, WORLD
       RPAD('HELLO, WORLD', 15, '*') rpad -- HELLO, WORLD***
FROM dual;


