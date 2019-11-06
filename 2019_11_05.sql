-- ��� �Ķ���Ͱ� �־����� �� �ش����� �ϼ��� ���ϴ� ����
-- 201911 --> 30 / 201912 --> 31

-- �Ѵ� ���� �� �������� ���� = �ϼ�
-- ��������¥ ���� �� --> DD�� ����
SELECT  TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD') day_cnt
FROM dual;

SELECT :yyyymm as param, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD') day_cnt
FROM dual;
-- �����ȹ�� �ۼ��϶�� ��
explain plan for -- �����ϸ� ����Ǿ����ϴ�.��� ��
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369'; -- 7369���ڿ��� ���ڷ� ������ ����ȯ

-- �����ȹ�� Ȯ���� �� ���� ����
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

--------------------------------------------------------------------------
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(TO_CHAR("EMPNO")='7369');

SELECT empno, ename, sal, TO_CHAR(sal, 'L000999,999.99') sal_fmt
FROM emp;

-- << function null >>
-- NVL(coll, coll�� null�� ��� ��ü�� ��)
SELECT empno, ename,sal, comm, nvl(comm, 0) nvl_comm,
       sal + comm, 
       sal + nvl(comm, 0),
       nvl(sal + comm, 0) -- ���ٰ� nvl�� �������� �� �����غ��� �Ѵ�.
FROM emp;

--NVL2(coll, coll�� null�� �ƴ� ��� ǥ���Ǵ� ��, coll null�� ��� ǥ�� �Ǵ� ��)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

-- NULLIF(expr1, expr2)
-- expr1 == expr2 ������ null
-- else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

-- COALESCE(expr1, expr2, expr3 ...)
-- �Լ� ���� �� null�� �ƴ� ù��° ����
-- comm�� ���� �ְ� comm�� null�̸� sal�� �ִ´�.
SELECT empno, ename, sal, comm, coalesce(comm, sal) 
FROM emp;

-- Q. �ǽ�4 ) Function (null �ǽ�) 137p
-- emp���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.

-- nvl
SELECT empno, ename, mgr, nvl(mgr, 9999) mgr_n
FROM emp;
-- nvl2
SELECT empno, ename, mgr, nvl2(mgr, mgr, 9999) mgr_n
FROM emp;
-- coalesce
SELECT empno, ename, mgr, coalesce(mgr, 9999) mgr_n
FROM emp;

-- Q. �ǽ�5 ) Function (null �ǽ�) 138p
-- users���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
-- reg_dt�� null�� ��� sysdate�� ����
SELECT userid, usernm, reg_dt, nvl(reg_dt, sysdate) n_reg_dt
FROM users;

-- << function condition >>
-- case when
SELECT empno, ename, job, sal,
       case
            when job = 'SALESMAN' then sal*1.05
            when job = 'MANAGER' then sal*1.10
            when job = 'PRESIDENT' then sal*1.20
            else sal
       end case_sal
FROM emp;

-- decode(col, search1, return1, search2, return2...,default)
SELECT empno, ename, job, sal,
       DECODE(job, 
              'SALESMAN', sal*1.05, 
              'MANAGER', sal*1.10, 
              'PRESIDENT', sal*1.20, 
              sal) decode_sal
FROM emp;

-- Q. �ǽ�1) Function (Condition �ǽ�) 143p
-- emp ���̺��� �̿��Ͽ� deptno�� ���� �μ������� �����ؼ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.

-- case
SELECT empno, ename, 
       case
            when deptno = 10 then 'ACCOUNTING'
            when deptno = 20 then 'RESEARCH'
            when deptno = 30 then 'SALES'
            when deptno = 40 then 'OPERATIONS'
            else 'DDIT'
       end  DNAME
FROM emp;

-- decode
SELECT empno, ename, decode(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') DNAME
FROM emp;

-- Q. �ǽ�2) Function (Condition �ǽ�) 144p
-- emp ���̺��� �̿��Ͽ� hiredate�� ���� ���� �ǰ����� ������������� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- (������ �������� �ϳ� ���⼭�� �Ի�⵵�� �������� �Ѵ�

-- ���� Ǭ ��
-- ���ذ� Ȧ���̸� Ȧ�� �Ի������� ���, ���ذ� ¦���̸� ¦�� �Ի������� ����� ������̴�.
SELECT empno, ename, TO_CHAR(hiredate, 'YYYY/MM/DD') hiredate,
       decode(MOD(TO_CHAR(SYSDATE,'YY'), 2), 0, decode(MOD(TO_CHAR(hiredate,'YY'), 2), 0, '�ǰ����� �����', 1, '��ǰ����� �����'), 1, decode(MOD(TO_CHAR(hiredate,'YY'), 2), 0, '�ǰ����� ������', 1, '�ǰ����� �����'))
FROM emp;

-- �� ��

-- �� �ش� ¦���ΰ�? Ȧ���ΰ�?
-- 1. ���� �⵵ ���ϱ� (DATE --> TO_CHAR(DATE, FORMAT)
-- 2. ���� �⵵�� ¦������ ���
-- � ���� 2�� ������ �������� �׻� 2���� �۴�.
-- 2�� ������� �������� 0, 1
-- MOD(���, ������)
SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2)
FROM dual;

--emp ���̺��� �Ի����ڰ� Ȧ�������� ¦�������� Ȯ��
SELECT empno, ename, hiredate, 
        case
            when  MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) =  MOD(TO_CHAR(hiredate, 'YYYY'), 2) 
                then '�ǰ����� ���'
                else '�ǰ����� ����'
        end contact_to_doctor        
FROM emp;

-- Q. �ǽ�3) Function (Condition �ǽ�) 145p
-- users ���̺��� �̿��Ͽ� reg_dt�� ���� ���� �ǰ����� ������������� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- (������ �������� �ϳ� ���⼭�� reg_dt�� �������� �Ѵ�)

SELECT userid, usernm, alias, reg_dt,
        case
            when  MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) =  MOD(TO_CHAR(reg_dt, 'YYYY'), 2) 
                then '�ǰ����� ���'
                else '�ǰ����� ����'
        end contact_to_doctor 
FROM users;

-- �׷��Լ� (AVG, MAX, MIN, SUM, COUNT)
-- �׷��Լ��� NULL���� ����󿡼� �����Ѵ�.
-- (�׷��� SUM(comm), COUNT(*), COUNT(mgr) �� ���� �޶���.)
-- ���� �� ���� ���� �޿��� �޴� ����� �޿�
-- ���� �� ���� ���� �޿��� �޴� ����� �޿�
-- ������ �޿� ��� (�Ҽ��� ��°�ڸ������� ������ --> �Ҽ��� 3°�ڸ����� �ݿø�)
-- ������ �޿� ��ü��
-- ������ ��
-- Ư�� �÷��� �� (null�� ������ 1)
SELECT MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp;

-- �μ��� ���� ���� �޿��� �޴� ����� �޿�
-- GROUP BY���� ������� ���� �÷��� SELECT���� ����� ��� ����
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;
-------------------------------------------------
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;
---------------------------------------------------

--!! GROP BY�� �� �� ���� ���� �÷��� ������ �����߻���. !!--
SELECT deptno, ename, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--!! �̷������� �׷��Լ��� ���� �����ؾ��Ѵ�. !!--
SELECT deptno, MIN(ename), MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--!!�ǹ̾��� ���ڿ��̳� ������ ������.!!--
SELECT deptno, 'test', 1,  MAX(sal) max_sal
FROM emp
GROUP BY deptno;

-- �μ��� �ִ� �޿�
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--!!�����߻�, WHERE(������) �׷��Լ��϶��� �� �� ����. HAVING���� �����. !!--
SELECT deptno, MAX(sal) max_sal
FROM emp
WHERE MAX(sal) > 3000
GROUP BY deptno;

-- Q. �ǽ�1) Function (group function �ǽ�) 159p
-- emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
-- ������ ���� ���� �޿�
-- ������ ���� ���� �޿�
-- ������ �޿� ���
-- ������ �޿� ��
-- ������ �޿��� �ִ� ������ �� (null ����)
-- ������ ����ڰ� �ִ� ������ �� (null ����)
-- ��ü ������ ��

SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp;

-- Q. �ǽ�2) Function (group function �ǽ�) 160p
-- emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
-- ������ ���� ���� �޿�
-- ������ ���� ���� �޿�
-- ������ �޿� ���
-- ������ �޿� ��
-- ������ �޿��� �ִ� ������ �� (null ����)
-- ������ ����ڰ� �ִ� ������ �� (null ����)
-- ��ü ������ ��

SELECT deptno,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY deptno;