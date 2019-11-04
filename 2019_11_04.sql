-- Q. 복습 where11
-- job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원정보 조회
-- 이거나 --> OR
-- 1981년 5월 1일 이후 --> 1981년 6월 1일을 포함

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('181/06/01','YYYY/MM/DD');

-- ROWNUM과 정렬 문제
-- ORDER BY절은 SELECT절 이후에 등장
-- ROWNUM  가상컬럼이 적용되고나서 적용되기 때문에
-- 우리가 원하는대로 첫번째 데이터부터 순차적인 번호 부여가 되질 않는다.
SELECT ROWNUM, e.*
FROM emp e;

-- ORDER BY 절을 포함한 인라인 뷰를 구성
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

-- ROWNUM : 1번부터 읽어야 한다.
-- WHERE절에 ROWNUM값을 중간만 읽는건 불가능
-- 안되는 케이스
-- WHERE ROWNUM = 2
-- WHERE ROWNUM >= 2

-- 되는 케이스
-- WHERE ROWNUM = 1
-- WHERE ROWNUM <= 10

SELECT ROWNUM, a.*
FROM
(SELECT e.*
FROM emp e
ORDER BY ename)a;

-- 페이징 처리를 위한 꼼수 ROWNUM에 별칭을 부여, 해당 SQL을 INLINE VIEW로 
-- 감싸고 별칭을 통해 페이징 처리

SELECT *
FROM
    (SELECT ROWNUM rn, a.*
        FROM
            (SELECT e.*
            FROM emp e
            ORDER BY ename)a)
WHERE rn BETWEEN 10 AND 14;

-- CONCAT : 문자열 결합 - 두개의 문자열을 결합하는 함수
SELECT CONCAT('HELLO', ', WORLD')
FROM dual;

SELECT CONCAT(CONCAT('HELLO', ',') , ' WORLD')
FROM dual;

-- SUBSTR : 문자열의 부분 문자열 (java : String.substring)
-- LENGTH : 문자열의 길이
-- INSTR : 문자열에 특정 문자열이 등장하는 첫번째 인덱스
-- LPAD : 문자열에 특정 문자열을 삽입
SELECT CONCAT(CONCAT('HELLO', ',') , ' WORLD') CONCAT, -- HELLO, WORLD
       SUBSTR('HELLO, WORLD', 0, 5) substr, -- HELLO
       SUBSTR('HELLO, WORLD', 1, 5) substr1, -- HELLO
       LENGTH('HELLO, WORLD') length, -- 12
       INSTR('HELLO, WORLD', 'O') instr,  -- 5
       -- INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후 표시)
       INSTR('HELLO, WORLD', 'O', 6) instr1 , -- 9
       -- LPAD(문자열, 전체 문자열길이, 문자열이 전체문자열길이에 미치지 못할 경우 추가할 문자);
       LPAD('HELLO, WORLD', 15, '*') lpad, -- ***HELLO, WORLD
       LPAD('HELLO, WORLD', 15) lpad, --    HELLO, WORLD
       LPAD('HELLO, WORLD', 15) lpad, --    HELLO, WORLD
       RPAD('HELLO, WORLD', 15, '*') rpad, -- HELLO, WORLD***
       -- REPLACE(원본문자열, 원본 문자열에서 변경하고자 하는 대상 문자열, 변경문자열)
       REPLACE('HELLO, WORLD', 'HELLO', 'hello') replace
FROM dual;
------------------------------------------------------------------------------------------
-- REPLACE(원본문자열, 원본 문자열에서 변경하고자 하는 대상 문자열, 변경문자열)
-- TRIM(앞, 뒤 공백 제거)
-- TRIM('문자' FROM '문자열') : 문자열에서 해당 문자를 제거
SELECT REPLACE('HELLO, WORLD', 'HELLO', 'hello') replace,
       REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace,
       TRIM('    HELLO, WORLD    ') trim,
       TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;

-- ROUND(대상숫자, 반올림 결과 자리수)
SELECT ROUND(105.54, 1) r1, -- 소수점 둘째 자리에서 반올림 // 105.5
       ROUND(105.55, 1) r2, -- 소수점 둘째 자리에서 반올림 // 105.6
       ROUND(105.55, 0) r3, -- 소수점 첫째 자리에서 반올림 // 106
       ROUND(105.55, -1) r4 -- 정수 첫째 자리에서 반올림 // 110
FROM dual;

-- MOD(값, 나눌수) : 나머지
SELECT empno, ename, sal, sal/1000, /*ROUND(sal/1000) quotient,*/ MOD(sal, 1000) reminder
FROM emp;

--TRUNC 내림
SELECT 
TRUNC(105.54, 1) r1, -- 소수점 둘째 자리에서 절삭 // 105.5
TRUNC(105.55, 1) r2, -- 소수점 둘째 자리에서 절삭 // 105.5
TRUNC(105.55, 0) r3, -- 소수점 첫째 자리에서 절삭 // 105
TRUNC(105.55, -1) r4 -- 정수 첫째 자리에서 절삭 // 100
FROM dual;

-- SYSDATE : 오라클이 설치된 서버의 현재 날짜 + 시간정보를 리턴
-- 별도의 인자가 없는 함수
SELECT SYSDATE
FROM dual;

-- TO_CHAR : DATE 타입을 문자열로 변환
-- 날짜를 문자열로 변환시에 포맷을 지정
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
       TO_CHAR(SYSDATE + (1/24/60) * 30, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;

-- Q. 실습1 ) Function (date 실습) 107p
-- 1. 2019년 12월 31일을 date형으로 표현
-- 2. 2019년 12월 31일을 date형으로 표현하고 5일 이전 날짜
-- 3. 현재 날짜
-- 4. 현재 날짜에서 3일 전 값
-- 위 4개 컬럼을 생성하여 다음과 같이 조회하는 쿼리를 작성하세요.

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

-- date format : TO_CHAR(date, '포맷'), TO_DATE(날짜 문자열, '포맷')
-- 년도 : YYYY, YY, RR : 2자일때랑 4자일때랑 다름
-- RR : 50보다 클 경우 앞자리는 19, 50보다 작을 경우 앞자리는 20
-- YYYY, RRRR은 동일
-- 가급적이면 명시적으로 표현
-- D : 요일을 숫자로 표기 (일요일-1, 월요일-2, 화요일-3...토요일-7)
SELECT TO_CHAR(TO_DATE('35/03/01','RR/MM/DD'), 'YYYY/MM/DD') r1, -- 2035/03/01
       TO_CHAR(TO_DATE('55/03/01','RR/MM/DD'), 'YYYY/MM/DD') r2, -- 1955/03/01, 55보다 크면 19가 붙음
       TO_CHAR(TO_DATE('35/03/01','YY/MM/DD'), 'YYYY/MM/DD') y2, -- 2035/03/01
       TO_CHAR(SYSDATE, 'D') d, -- 오늘은 월요일-2
       TO_CHAR(SYSDATE, 'IW') iw, --주차 표기
       TO_CHAR(TO_DATE('20191231','YYYYMMDD'), 'IW') this_year -- 해가 넘어가서 29일부터 1주차됨
FROM dual;

-- Q. 실습2 ) Function (date 실습) 111p
-- 오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오.
-- 1. 년-월-일
-- 2. 년-월-일 시간(24)-분-초
-- 3. 일-월-년

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') dt_dash,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24-MI-SS') dt_dash_width_time,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;

-- 날짜의 반올림(ROUND), 절삭(TRUNC)
-- ROUND(DATE, '포맷') YYYY, MM, DD
desc emp;
SELECT ename, 
       TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate, -- 1980/12/17 00:00:00
       TO_CHAR(ROUND(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as round_YYYY, -- 1981/01/01 00:00:00
       TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_MM, -- 1981/01/01 00:00:00
       TO_CHAR(ROUND(hiredate-2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_MM, --1980/12/01 00:00:00 12/15일은 한달의 반이 안넘어서 반올림하면 올라가지 않음. 
       TO_CHAR(ROUND(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as round_DD  --1980/12/17 00:00:00 시간이 없어서 변화 없음.
FROM emp
WHERE ename = 'SMITH';

SELECT ename, 
TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate, -- 1980/12/17 00:00:00
TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as trunc_YYYY, -- 1980/01/01 00:00:00
TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_MM, -- 1980/12/01 00:00:00
TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as trunc_DD  --1980/12/17 00:00:00 시간이 없어서 변화 없음.
FROM emp
WHERE ename = 'SMITH';

--??
SELECT SYSDATE + 30 -- 28, 29, 31
FROM dual;

-- 날짜 연산 함수
-- MONTHS_BETWEEN(DATE, DATE) : 두 날짜 사이의 개월 수
-- 19801217 ~ 20191104 --> 20191117
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
       MONTHS_BETWEEN(TO_DATE('20191117', 'YYYYMMDD'), hiredate) months_between
FROM emp
WHERE ename='SMITH';

-- ADD_MONTHS(DATE, 개월수) : DATE에 개월수가 지난 날짜
-- 개월수가 양수일 경우 미래, 음수일 경우 과거
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       ADD_MONTHS(hiredate, 467) add_months,
       ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename='SMITH';

-- NEXT_DAY(DATE, 요일) : DATE 이후 첫번째 요일의 날짜
SELECT SYSDATE, 
       NEXT_DAY(SYSDATE, 7) first_sat, -- 오늘날짜 이후 첫 토요일 일자
       NEXT_DAY(SYSDATE, '토요일') first_sat
FROM dual;

-- LAST_DAY(DATE) : 해당 날짜가 속한 월의 마지막 일자
SELECT SYSDATE, 
       LAST_DAY(SYSDATE) last_day,
       LAST_DAY(ADD_MONTHS(SYSDATE,1)) LAST_DAY_12
FROM dual;

-- DATE + 정수 = DATE (DATE에서 정수만큼 이후의 DATE)
-- D1 + 정수 = D2
-- 양변에서 D2 차감
-- D1 + 정수 - D2 = D2 - D2
-- D1 + 정수 - D2 = 0
-- D1 + 정수 = D2
-- 양변에 D1 차감
-- D1 + 정수 - D1 = D2 - D1
-- 정수 = D2 - D1
-- 날짜에서 날짜를 빼면 일자가 나온다. 
SELECT TO_DATE('20191104', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD') D1,
       TO_DATE('20191201', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD') D2, -- 11월달이 총 몇일인지 알고 싶을 때
       -- 201908 : 2019년 8월의 일수 : 31
       ADD_MONTHS(TO_DATE('201908', 'YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') D3
FROM dual;

