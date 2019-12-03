-- CURSOR�� ��������� �������� �ʰ�
-- LOOP���� inline ���·� cursor���

-- �͸� ���
-- DECLARE
--     -- cursor ���� --> LOOP���� inline ����
-- BEGIN
--     FOR ���ڵ� IN ����� Ŀ�� LOOP
--     
--     END LOOP;
-- END;
-- /
set serveroutput on;

DECLARE
    -- cursor ���� --> LOOP���� inline ����
BEGIN
    -- for(String str : list)
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/
-------------------------------------------------------------------------------------------------
-- pl/sql (cursor, �������� �ǽ� PRO_3) 18p
-- Q. �ǽ� PRO_3
-- dt.sql ������ ���� ���̺�� �����͸� �����ϰ�, ������ ����
-- ��¥ ���� ������ ����� ���ϴ� ���ν��� ����
-- exec acgdt
-- cursor�� ���

--  1. ���� ���� Ǯ�̸� �̿��ؼ� Ǯ��
DECLARE
BEGIN
    FOR rec IN (SELECT (MAX(dt)-MIN(dt))/(COUNT(*)-1) avg FROM dt) LOOP
        dbms_output.put_line(rec.avg);
    END LOOP;
END;
/

-- ���� ������ Ǯ��
DECLARE
    i NUMBER;
    d DATE;
    n NUMBER;
    sumd NUMBER;
BEGIN
    i := 0;
    n := 0;
    sumd := 0;
    
    FOR rec IN (SELECT dt FROM dt ORDER BY dt DESC) LOOP
        IF i = 0 THEN
            d := rec.dt;
        ELSIF i > 0 THEN
            n := d - rec.dt; -- ó�� ����ȳ�¥(d) ���� �ι�° ��¥�� �� (5)
            d := rec.dt; -- �ι�° ��¥
        END IF;
        i := i + 1; -- i �ε��� ���� 
        sumd := sumd + n;
    END LOOP;
        dbms_output.put_line(sumd/(i-1));
END;
/

-- �� Ǯ��

CREATE OR REPLACE PROCEDURE avgdt
IS
    -- �����
    prev_dt DATE;
    ind NUMBER := 0;
    diff NUMBER := 0; -- ���̰�(�ϼ�)
BEGIN
    -- dt ���̺� ��� ������ ��ȸ
    FOR rec IN (SELECT * FROM dt ORDER BY dt DESC) LOOP
        -- rec : dt �÷�
        -- ���� ���� ������(dt) - ���� ������(dt) : 
        IF ind = 0 THEN -- LOOP�� ù ����
            prev_dt := rec.dt;
        ELSE
            diff := diff + prev_dt - rec.dt;
            prev_dt := rec.dt;
        END IF;
        
        ind := ind + 1;
    END LOOP;
    dbms_output.put_line('ind : ' || ind);
    dbms_output.put_line('diff : ' || diff / (ind-1));
END;
/
exec avgdt;

-------------------------------------------------------------------------------------------------
-- <����>
-- pl/sql (cursor, �������� �ǽ� PRO_4) 41p
-- Q. �ǽ� PRO_4
-- ��ȿ�� �Ͻ��� ���� ���ν��� ����
-- exec create_daily_sales('201910');

-- dt.sql ������ ���� ���̺�� �����͸� �����ϰ�, ������ ����
-- ���ڷ� ���� ��� ���� �ش��ϴ� �Ͻ����� �����ϴ� ���ν��� �ۼ�
-- cycle ���̺��� ���� �����ϴ� ������ �������.
-- ������ �ش� ����� �ش��ϴ� daily �����ʹ� ����
-- �ش� ������ �̿��Ͽ� ���ڷ� ���� ����� ���ڷ� ����Ͽ�
-- daily ���̺� ������ �ű� ����
-- ex) 201908

SELECT *
FROM CYCLE;

SELECT *
FROM DAILY;
--DELETE��   
--      DELETE emp
--      WHERE empno IN(SELECT deptno FROM dept)
--TRUNCATE TABLE;

-- 1 100 2  1
-- 1�� ���� 100�� ��ǰ�� �����ϳ� �Ѱ��� �Դ´�.

--> CYCLE
-- 1 100 2 1

--> DAILY
-- 1 100 20191104 1
-- 1 100 20191111 1
-- 1 100 20191118 1
-- 1 100 20191125 1
-------------------------------------------------------------------------------------------------
-- <��>
-- �� Ǯ��


-- ������ ���� ���ϱ�

SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'))
FROM DUAL;


-- ���� ���̺� ���� , ���̺�Ÿ��, �� Ÿ�� �ʿ� (variableŸ������ �����غ���)
SELECT TO_CHAR(TO_DATE('201911', 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
       TO_CHAR(TO_DATE('201911', 'YYYYMM') + (LEVEL-1), 'D') d -- d�ϸ� ������ ����
FROM dual
CONNECT BY LEVEL <= (SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'))
                    FROM DUAL);



-- ���� ���̺� ���� ���ν��� ����

CREATE OR REPLACE PROCEDURE create_daily_sales(p_yyyymm VARCHAR2) -- �Ķ���Ϳ��� ����Ʈũ�⸦ ���� ������ (8)�� ����.
IS
    -- �޷��� �������� ������ ROCORD TYPE
    TYPE cal_row IS RECORD(
        dt VARCHAR2(8),
        D  VARCHAR2(1)
    );
    
    -- �޷� ������ ������ table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'D') d -- d�ϸ� ������ ����
           BUlK COLLECT INTO cal
    FROM dual
    CONNECT BY LEVEL <= (SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'))
                        FROM DUAL);
    FOR i IN 1..cal.count LOOP
        dbms_output.put_line(cal(i).dt || ', ' || cal(i).d);
    END LOOP;
    
END;
/
exec create_daily_sales('201908');




-- DAILY ���̺� �� �ִ� ���ν��� �ϼ�

-- ���� ���̺� ���� ���ν��� ����
CREATE OR REPLACE PROCEDURE create_daily_sales(p_yyyymm VARCHAR2) -- �Ķ���Ϳ��� ����Ʈũ�⸦ ���� ������ (8)�� ����.
IS
    -- �޷��� �������� ������ ROCORD TYPE
    TYPE cal_row IS RECORD(
        dt VARCHAR2(8),
        D  VARCHAR2(1)
    );
    
    -- �޷� ������ ������ table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
    
    cursor cycle_cursor IS 
    SELECT * FROM CYCLE;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'D') d -- d�ϸ� ������ ����
           BULK COLLECT INTO cal
    FROM dual
    CONNECT BY LEVEL <= (SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')), 'DD'))
                        FROM DUAL);
    
    -- �����Ϸ��� �ϴ� ����� ���� �����͸� �����Ѵ�.
    DELETE daily
    WHERE dt LIKE p_yyyymm || '%';
    
    -- �����ֱ� loop
    FOR rec IN cycle_cursor LOOP                    
        FOR i IN 1..cal.count LOOP
            -- �����ֱ��� �����̶� ������ �����̶� ���� ��
            IF rec.day = cal(i).d THEN
                INSERT INTO daily VALUES(rec.cid, rec.pid, cal(i).dt, rec.cnt);
            END IF;
        END LOOP;
    END LOOP;
    
    COMMIT;
    
END;
/

exec create_daily_sales('201911');

-- ��ȸ�ϱ�

SELECT *
FROM daily;

-------------------------------------------------------------------------------------------------

-- �������� �ϱ�

INSERT INTO daily
SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM
    cycle,
    (SELECT TO_CHAR(TO_DATE(:p_yyyymm, 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(:p_yyyymm, 'YYYYMM') + (LEVEL-1), 'D') d -- d�ϸ� ������ ����
    FROM dual
    CONNECT BY LEVEL <= (SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(:p_yyyymm, 'YYYYMM')), 'DD'))
                        FROM DUAL)) cal
WHERE cycle.day = cal.d;




