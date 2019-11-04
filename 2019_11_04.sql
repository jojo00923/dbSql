-- Q. ���� where11
-- job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������ �������� ��ȸ
-- �̰ų� --> OR
-- 1981�� 5�� 1�� ���� --> 1981�� 6�� 1���� ����

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('181/06/01','YYYY/MM/DD');

-- ROWNUM�� ���� ����
-- ORDER BY���� SELECT�� ���Ŀ� ����
-- ROWNUM  �����÷��� ����ǰ��� ����Ǳ� ������
-- �츮�� ���ϴ´�� ù��° �����ͺ��� �������� ��ȣ �ο��� ���� �ʴ´�.
SELECT ROWNUM, e.*
FROM emp e;

-- ORDER BY ���� ������ �ζ��� �並 ����
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

-- ROWNUM : 1������ �о�� �Ѵ�.
-- WHERE���� ROWNUM���� �߰��� �д°� �Ұ���
-- �ȵǴ� ���̽�
-- WHERE ROWNUM = 2
-- WHERE ROWNUM >= 2

-- �Ǵ� ���̽�
-- WHERE ROWNUM = 1
-- WHERE ROWNUM <= 10

SELECT ROWNUM, a.*
FROM
(SELECT e.*
FROM emp e
ORDER BY ename)a;

-- ����¡ ó���� ���� �ļ� ROWNUM�� ��Ī�� �ο�, �ش� SQL�� INLINE VIEW�� 
-- ���ΰ� ��Ī�� ���� ����¡ ó��

SELECT *
FROM
    (SELECT ROWNUM rn, a.*
        FROM
            (SELECT e.*
            FROM emp e
            ORDER BY ename)a)
WHERE rn BETWEEN 10 AND 14;

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
       RPAD('HELLO, WORLD', 15, '*') rpad, -- HELLO, WORLD***
       -- REPLACE(�������ڿ�, ���� ���ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���湮�ڿ�)
       REPLACE('HELLO, WORLD', 'HELLO', 'hello') replace
FROM dual;
------------------------------------------------------------------------------------------
-- REPLACE(�������ڿ�, ���� ���ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���湮�ڿ�)
-- TRIM(��, �� ���� ����)
-- TRIM('����' FROM '���ڿ�') : ���ڿ����� �ش� ���ڸ� ����
SELECT REPLACE('HELLO, WORLD', 'HELLO', 'hello') replace,
       REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace,
       TRIM('    HELLO, WORLD    ') trim,
       TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;

-- ROUND(������, �ݿø� ��� �ڸ���)
SELECT ROUND(105.54, 1) r1, -- �Ҽ��� ��° �ڸ����� �ݿø� // 105.5
       ROUND(105.55, 1) r2, -- �Ҽ��� ��° �ڸ����� �ݿø� // 105.6
       ROUND(105.55, 0) r3, -- �Ҽ��� ù° �ڸ����� �ݿø� // 106
       ROUND(105.55, -1) r4 -- ���� ù° �ڸ����� �ݿø� // 110
FROM dual;

-- MOD(��, ������) : ������
SELECT empno, ename, sal, sal/1000, /*ROUND(sal/1000) quotient,*/ MOD(sal, 1000) reminder
FROM emp;

--TRUNC ����
SELECT 
TRUNC(105.54, 1) r1, -- �Ҽ��� ��° �ڸ����� ���� // 105.5
TRUNC(105.55, 1) r2, -- �Ҽ��� ��° �ڸ����� ���� // 105.5
TRUNC(105.55, 0) r3, -- �Ҽ��� ù° �ڸ����� ���� // 105
TRUNC(105.55, -1) r4 -- ���� ù° �ڸ����� ���� // 100
FROM dual;

-- SYSDATE : ����Ŭ�� ��ġ�� ������ ���� ��¥ + �ð������� ����
-- ������ ���ڰ� ���� �Լ�
SELECT SYSDATE
FROM dual;

-- TO_CHAR : DATE Ÿ���� ���ڿ��� ��ȯ
-- ��¥�� ���ڿ��� ��ȯ�ÿ� ������ ����
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
       TO_CHAR(SYSDATE + (1/24/60) * 30, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;

-- Q. �ǽ�1 ) Function (date �ǽ�) 107p
-- 1. 2019�� 12�� 31���� date������ ǥ��
-- 2. 2019�� 12�� 31���� date������ ǥ���ϰ� 5�� ���� ��¥
-- 3. ���� ��¥
-- 4. ���� ��¥���� 3�� �� ��
-- �� 4�� �÷��� �����Ͽ� ������ ���� ��ȸ�ϴ� ������ �ۼ��ϼ���.

SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') lastday,
       TO_DATE('2019/12/31', 'YYYY/MM/DD') -5 lastday_before5,
       SYSDATE now,
       TO_DATE(SYSDATE - 3, 'YYYY/MM/DD') now_before3
FROM dual;

--fn1
SELECT lastday, lastday-5 as lastday_before5, now, now-3 not_before3
FROM
    (SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') lastday,
            SYSDATE now
    FROM dual);

-- date format : TO_CHAR(date, '����'), TO_DATE(��¥ ���ڿ�, '����')
-- �⵵ : YYYY, YY, RR : 2���϶��� 4���϶��� �ٸ�
-- RR : 50���� Ŭ ��� ���ڸ��� 19, 50���� ���� ��� ���ڸ��� 20
-- YYYY, RRRR�� ����
-- �������̸� ��������� ǥ��
-- D : ������ ���ڷ� ǥ�� (�Ͽ���-1, ������-2, ȭ����-3...�����-7)
SELECT TO_CHAR(TO_DATE('35/03/01','RR/MM/DD'), 'YYYY/MM/DD') r1, -- 2035/03/01
       TO_CHAR(TO_DATE('55/03/01','RR/MM/DD'), 'YYYY/MM/DD') r2, -- 1955/03/01, 55���� ũ�� 19�� ����
       TO_CHAR(TO_DATE('35/03/01','YY/MM/DD'), 'YYYY/MM/DD') y2, -- 2035/03/01
       TO_CHAR(SYSDATE, 'D') d, -- ������ ������-2
       TO_CHAR(SYSDATE, 'IW') iw, --���� ǥ��
       TO_CHAR(TO_DATE('20191231','YYYYMMDD'), 'IW') this_year -- �ذ� �Ѿ�� 29�Ϻ��� 1������
FROM dual;

-- Q. �ǽ�2 ) Function (date �ǽ�) 111p
-- ���� ��¥�� ������ ���� �������� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
-- 1. ��-��-��
-- 2. ��-��-�� �ð�(24)-��-��
-- 3. ��-��-��

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') dt_dash,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24-MI-SS') dt_dash_width_time,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;

-- ��¥�� �ݿø�(ROUND), ����(TRUNC)
-- ROUND(DATE, '����') YYYY, MM, DD
desc emp;
SELECT ename, 
       TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate, -- 1980/12/17 00:00:00
       TO_CHAR(ROUND(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as round_YYYY, -- 1981/01/01 00:00:00
       TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_MM, -- 1981/01/01 00:00:00
       TO_CHAR(ROUND(hiredate-2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_MM, --1980/12/01 00:00:00 12/15���� �Ѵ��� ���� �ȳѾ �ݿø��ϸ� �ö��� ����. 
       TO_CHAR(ROUND(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as round_DD  --1980/12/17 00:00:00 �ð��� ��� ��ȭ ����.
FROM emp
WHERE ename = 'SMITH';

SELECT ename, 
TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate, -- 1980/12/17 00:00:00
TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as trunc_YYYY, -- 1980/01/01 00:00:00
TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_MM, -- 1980/12/01 00:00:00
TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as trunc_DD  --1980/12/17 00:00:00 �ð��� ��� ��ȭ ����.
FROM emp
WHERE ename = 'SMITH';

--??
SELECT SYSDATE + 30 -- 28, 29, 31
FROM dual;

-- ��¥ ���� �Լ�
-- MONTHS_BETWEEN(DATE, DATE) : �� ��¥ ������ ���� ��
-- 19801217 ~ 20191104 --> 20191117
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
       MONTHS_BETWEEN(TO_DATE('20191117', 'YYYYMMDD'), hiredate) months_between
FROM emp
WHERE ename='SMITH';

-- ADD_MONTHS(DATE, ������) : DATE�� �������� ���� ��¥
-- �������� ����� ��� �̷�, ������ ��� ����
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       ADD_MONTHS(hiredate, 467) add_months,
       ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename='SMITH';

-- NEXT_DAY(DATE, ����) : DATE ���� ù��° ������ ��¥
SELECT SYSDATE, 
       NEXT_DAY(SYSDATE, 7) first_sat, -- ���ó�¥ ���� ù ����� ����
       NEXT_DAY(SYSDATE, '�����') first_sat
FROM dual;

-- LAST_DAY(DATE) : �ش� ��¥�� ���� ���� ������ ����
SELECT SYSDATE, 
       LAST_DAY(SYSDATE) last_day,
       LAST_DAY(ADD_MONTHS(SYSDATE,1)) LAST_DAY_12
FROM dual;

-- DATE + ���� = DATE (DATE���� ������ŭ ������ DATE)
-- D1 + ���� = D2
-- �纯���� D2 ����
-- D1 + ���� - D2 = D2 - D2
-- D1 + ���� - D2 = 0
-- D1 + ���� = D2
-- �纯�� D1 ����
-- D1 + ���� - D1 = D2 - D1
-- ���� = D2 - D1
-- ��¥���� ��¥�� ���� ���ڰ� ���´�. 
SELECT TO_DATE('20191104', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD') D1,
       TO_DATE('20191201', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD') D2, -- 11������ �� �������� �˰� ���� ��
       -- 201908 : 2019�� 8���� �ϼ� : 31
       ADD_MONTHS(TO_DATE('201908', 'YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') D3
FROM dual;

