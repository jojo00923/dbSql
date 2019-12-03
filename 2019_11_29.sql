-- CURSOR를 명시적으로 선언하지 않고
-- LOOP에서 inline 형태로 cursor사용

-- 익명 블록
-- DECLARE
--     -- cursor 선언 --> LOOP에서 inline 선언
-- BEGIN
--     FOR 레코드 IN 선언된 커서 LOOP
--     
--     END LOOP;
-- END;
-- /
set serveroutput on;

DECLARE
    -- cursor 선언 --> LOOP에서 inline 선언
BEGIN
    -- for(String str : list)
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/
-------------------------------------------------------------------------------------------------
-- pl/sql (cursor, 로직제어 실습 PRO_3) 18p
-- Q. 실습 PRO_3
-- dt.sql 파일을 통해 테이블과 데이터를 생성하고, 다음과 같은
-- 날짜 간격 사이의 평균을 구하는 프로시저 생성
-- exec acgdt
-- cursor를 사용

--  1. 어제 동규 풀이를 이용해서 풀음
DECLARE
BEGIN
    FOR rec IN (SELECT (MAX(dt)-MIN(dt))/(COUNT(*)-1) avg FROM dt) LOOP
        dbms_output.put_line(rec.avg);
    END LOOP;
END;
/

-- 승희가 도와준 풀이
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
            n := d - rec.dt; -- 처음 저장된날짜(d) 에서 두번째 날짜를 뺌 (5)
            d := rec.dt; -- 두번째 날짜
        END IF;
        i := i + 1; -- i 인덱스 증가 
        sumd := sumd + n;
    END LOOP;
        dbms_output.put_line(sumd/(i-1));
END;
/

-- 쌤 풀이

CREATE OR REPLACE PROCEDURE avgdt
IS
    -- 선언부
    prev_dt DATE;
    ind NUMBER := 0;
    diff NUMBER := 0; -- 차이값(일수)
BEGIN
    -- dt 테이블 모든 데이터 조회
    FOR rec IN (SELECT * FROM dt ORDER BY dt DESC) LOOP
        -- rec : dt 컬럼
        -- 먼저 읽은 데이터(dt) - 다음 데이터(dt) : 
        IF ind = 0 THEN -- LOOP의 첫 시작
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
-- <문제>
-- pl/sql (cursor, 로직제어 실습 PRO_4) 41p
-- Q. 실습 PRO_4
-- 발효유 일실적 생성 프로시저 생성
-- exec create_daily_sales('201910');

-- dt.sql 파일을 통해 테이블과 데이터를 생성하고, 다음과 같은
-- 인자로 들어온 년월 값에 해당하는 일실적을 생성하는 프로시저 작성
-- cycle 테이블에는 고객이 애음하는 요일이 들어있음.
-- 생성전 해당 년월에 해당하는 daily 데이터는 삭제
-- 해당 용일을 이용하여 인자로 들어온 년월의 일자로 계산하여
-- daily 테이블에 데이터 신규 생성
-- ex) 201908

SELECT *
FROM CYCLE;

SELECT *
FROM DAILY;
--DELETE나   
--      DELETE emp
--      WHERE empno IN(SELECT deptno FROM dept)
--TRUNCATE TABLE;

-- 1 100 2  1
-- 1번 고객은 100번 제품을 월요일날 한개를 먹는다.

--> CYCLE
-- 1 100 2 1

--> DAILY
-- 1 100 20191104 1
-- 1 100 20191111 1
-- 1 100 20191118 1
-- 1 100 20191125 1
-------------------------------------------------------------------------------------------------
-- <답>
-- 쌤 풀이


-- 마지막 일자 구하기

SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'))
FROM DUAL;


-- 왼쪽 테이블 만듦 , 테이블타입, 행 타입 필요 (variable타입으로 선언해보자)
SELECT TO_CHAR(TO_DATE('201911', 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
       TO_CHAR(TO_DATE('201911', 'YYYYMM') + (LEVEL-1), 'D') d -- d하면 요일이 나옴
FROM dual
CONNECT BY LEVEL <= (SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'))
                    FROM DUAL);



-- 왼쪽 테이블 넣은 프로시저 생성

CREATE OR REPLACE PROCEDURE create_daily_sales(p_yyyymm VARCHAR2) -- 파라미터에는 바이트크기를 쓰면 에러남 (8)을 빼줌.
IS
    -- 달력의 행정보를 저장할 ROCORD TYPE
    TYPE cal_row IS RECORD(
        dt VARCHAR2(8),
        D  VARCHAR2(1)
    );
    
    -- 달력 정보를 저장할 table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'D') d -- d하면 요일이 나옴
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




-- DAILY 테이블에 값 넣는 프로시저 완성

-- 왼쪽 테이블 넣은 프로시저 생성
CREATE OR REPLACE PROCEDURE create_daily_sales(p_yyyymm VARCHAR2) -- 파라미터에는 바이트크기를 쓰면 에러남 (8)을 빼줌.
IS
    -- 달력의 행정보를 저장할 ROCORD TYPE
    TYPE cal_row IS RECORD(
        dt VARCHAR2(8),
        D  VARCHAR2(1)
    );
    
    -- 달력 정보를 저장할 table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
    
    cursor cycle_cursor IS 
    SELECT * FROM CYCLE;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (LEVEL-1), 'D') d -- d하면 요일이 나옴
           BULK COLLECT INTO cal
    FROM dual
    CONNECT BY LEVEL <= (SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')), 'DD'))
                        FROM DUAL);
    
    -- 생성하려고 하는 년월의 실적 데이터를 삭제한다.
    DELETE daily
    WHERE dt LIKE p_yyyymm || '%';
    
    -- 애음주기 loop
    FOR rec IN cycle_cursor LOOP                    
        FOR i IN 1..cal.count LOOP
            -- 애음주기의 요일이랑 일자의 요일이랑 같은 비교
            IF rec.day = cal(i).d THEN
                INSERT INTO daily VALUES(rec.cid, rec.pid, cal(i).dt, rec.cnt);
            END IF;
        END LOOP;
    END LOOP;
    
    COMMIT;
    
END;
/

exec create_daily_sales('201911');

-- 조회하기

SELECT *
FROM daily;

-------------------------------------------------------------------------------------------------

-- 조인으로 하기

INSERT INTO daily
SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM
    cycle,
    (SELECT TO_CHAR(TO_DATE(:p_yyyymm, 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(:p_yyyymm, 'YYYYMM') + (LEVEL-1), 'D') d -- d하면 요일이 나옴
    FROM dual
    CONNECT BY LEVEL <= (SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(:p_yyyymm, 'YYYYMM')), 'DD'))
                        FROM DUAL)) cal
WHERE cycle.day = cal.d;




