-- ���� ��Ǭ ����

-- 2.emp.empno, emp.ename, emp.sal, emp_test.sal, (������ ����...)
-- �ش���(emp���̺� ����)�� ���� �μ��� �޿����
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal , emp.deptno, (SELECT ROUND(AVG(sal), 2)
                                                                 FROM emp
                                                                 WHERE emp.deptno = emp_test.deptno
                                                                 GROUP BY deptno) avg_sal
FROM emp, emp_test
WHERE emp.empno = emp_test.empno
ORDER BY deptno desc;

-----------------------------------------------------------------------

-- 1
-- sql���� ppt 48p
-- Q. �������� ADVANCED (WITH)
-- �μ��� ��� �޿��� ���� ��ü�� �޿����� ���� �μ���
-- �μ���ȣ�� �μ��� �޿� ��� �ݾ� ��ȸ

-- ��ü ������ �޿���� 2073.21
SELECT ROUND(AVG(sal), 2)
FROM emp;

-- �μ��� ������ �޿� ��� 10 XXX, 20 YYY, 30 ZZZ
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno;

-- �μ��� ��� �޿��� ���� ��ü�� �޿����� ���� �μ� (10, 20)
SELECT *
FROM
    (SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
    FROM emp
    GROUP BY deptno)
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2)
                  FROM emp);
                  
-- �Ʒ��� ������ ����.                  
SELECT *
FROM
    (SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
    FROM emp
    GROUP BY deptno)
WHERE d_avgsal > (2073.21);

-- ���� ���� WITH���� �����Ͽ�
-- ������ �����ϰ� ǥ���Ѵ�.

WITH dept_avg_sal AS (
    SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
    FROM emp
    GROUP BY deptno)
SELECT *
FROM dept_avg_sal
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2)
                  FROM emp);

-----------------------------------------------------------------------------------------

-- 2

-- �޷� �����
-- STEP1.�ش� ����� ���� ����� 8P
-- CONNECT BY LEVEL
-- 201911
-- DATE + ���� = ���� ���ϱ� ����
SELECT TO_DATE(:YYYYMM, 'YYYYMM'), level
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'DD');

SELECT TO_DATE(:YYYYMM, 'YYYYMM') + level, level
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'DD');

SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level-1)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'DD');

-- �Է��� �� ������ �ϱ�
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level-1)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');

-- �������� �ٲٱ�
SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw, -- ���� ���ϱ�
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'day') day,-- ����
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- ������ ���ڷ� ǥ�� (1�� �Ͽ���)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');

-- �ζ��κ�� ���
SELECT  a.*,  
        DECODE(d, 1, dt) sun, DECODE(d, 2, dt) mon, DECODE(d, 3, dt) tue,
        DECODE(d, 4, dt) wed, DECODE(d, 5, dt) thu, DECODE(d, 6, dt) fri,
        DECODE(d, 7, dt) sat
FROM
(SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw, -- ���� ���ϱ�
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- ������ ���ڷ� ǥ�� (1�� �Ͽ���)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a;

-- ������ ������ �ٲ�
SELECT  a.iw,  
        DECODE(d, 1, dt) sun, DECODE(d, 2, dt) mon, DECODE(d, 3, dt) tue,
        DECODE(d, 4, dt) wed, DECODE(d, 5, dt) thu, DECODE(d, 6, dt) fri,
        DECODE(d, 7, dt) sat
FROM
(SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw, -- ���� ���ϱ�
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- ������ ���ڷ� ǥ�� (1�� �Ͽ���)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a;


-- �޷� ������� �ٲ� ( max�� min�� ����ϸ� ���ڰ� �ϳ��ϱ� �� ���� ������, ������ �׷���̸� �ϸ� ...null�� ...)
SELECT  a.iw, 
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM
(SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw, -- ���� ���ϱ�
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- ������ ���ڷ� ǥ�� (1�� �Ͽ���)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
GROUP BY a.iw
ORDER BY a.iw;

-- ������ sun�� �� �ϳ� �����ϵ��� ����
SELECT  a.iw, 
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM
(SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level), 'iw') iw, -- ���� ���ϱ�
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- ������ ���ڷ� ǥ�� (1�� �Ͽ���)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
GROUP BY a.iw
ORDER BY a.iw;

-- �� ���
SELECT  decode(d, 1, a.iw+1, a.iw) iw, 
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM
(SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw, -- ���� ���ϱ�
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- ������ ���ڷ� ǥ�� (1�� �Ͽ���)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
GROUP BY decode(d, 1, a.iw+1, a.iw)
ORDER BY decode(d, 1, a.iw+1, a.iw);

-----------------------------------------------------------------------------------------

-- 2-1

-- Q. ����(�ǽ� calendar2) 20P
-- �ش� ���� ��� ������ ���� ��¥�� ������ ���� ����ϵ��� ������ �ۼ��غ�����.
SELECT  decode(d, 1, a.iw+1, a.iw) iw, 
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM
(SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw, 
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d 
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
GROUP BY decode(d, 1, a.iw+1, a.iw)
ORDER BY decode(d, 1, a.iw+1, a.iw);


-----------------------------------------------------------------------------------------

-- �޷¸���� ���� ������ �ֱ�

create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

-- SALES
SELECT * 
FROM sales;

-- Q. ����(�ǽ� calendar1)
-- �޷¸���� ���� ������.sql�� �Ϻ� ���� �����͸� �̿��Ͽ�
-- 1~6���� ���� ���� �����͸� ������ ���� ���ϼ���.

-- �켱 ���� ���� �հ踦 ���Ѵ�.
SELECT TO_CHAR(dt, 'MM'), SUM(sales)
FROM sales
GROUP BY TO_CHAR(dt, 'MM');

SELECT MIN(DECODE(dt, '01', sum)) jan, 
       MIN(DECODE(dt, '02', sum)) fev, 
       MIN(DECODE(dt, '03', sum)) mar,
       MIN(DECODE(dt, '04', sum)) apr, 
       MIN(DECODE(dt, '05', sum)) may, 
       MIN(DECODE(dt, '06', sum)) jun
FROM
(SELECT TO_CHAR(dt, 'MM') dt, SUM(sales) sum
FROM sales
GROUP BY TO_CHAR(dt, 'MM')) a;

-- �� ��

SELECT NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '01', SUM(sales))),0) jan, 
       NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '02', SUM(sales))),0) fev, 
       NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '03', SUM(sales))),0) mar,
       NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '04', SUM(sales))),0) apr, 
       NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '05', SUM(sales))),0) may,
       NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '06', SUM(sales))),0) jun
FROM sales
GROUP BY TO_CHAR(dt, 'MM');

-----------------------------------------------------------------------------------------

-- �������� �߿��߿�!!!! (SQL���� PPT 51~)
-- START WITH : ������ ���� �κ��� ����
-- CONNECT BY : ������ ���� ������ ����

-- ����� �������� (���� �ֻ��� ������������ ��� ������ Ž��)

SELECT *
FROM dept_h
START WITH deptcd ='dept0'           -- START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;  -- PRIOR�� ���� ���� �����͸� ����(XXȸ��)
------���� ����!!**************************************************************************

-- LEVEL ����ؼ� ������ ǥ���ϱ� �� LPAD ��뿹��
SELECT dept_h.*, LEVEL, LPAD('T', 15, '*') -- T��� �ϴ� ���ڿ��� ��µ�, 15���ڰ� �ȵǸ� ���ʿ� *�� ����.
FROM dept_h
START WITH deptcd ='dept0'           -- START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;  -- PRIOR�� ���� ���� �����͸� ����(XXȸ��)

-- LEVEL ����ؼ� ������ ǥ��
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4, ' ') || dept_h.deptnm  
FROM dept_h
START WITH deptcd ='dept0'           -- START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;  -- PRIOR�� ���� ���� �����͸� ����(XXȸ��)



-- �������� ���� ���̺� ���� ���� (61p ����)
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;

-----------------------------------------------------------------------------------------
-- Q. �������� (�ǽ� h_2)
-- �����ý��ۺ� ������ �μ����� ������ ��ȸ�ϴ� ������ �ۼ��ϼ���. 73p









