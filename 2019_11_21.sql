-- 어제 못푼 문제

-- 2.emp.empno, emp.ename, emp.sal, emp_test.sal, (마지막 못함...)
-- 해당사원(emp테이블 기준)이 속한 부서의 급여평균
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal , emp.deptno, (SELECT ROUND(AVG(sal), 2)
                                                                 FROM emp
                                                                 WHERE emp.deptno = emp_test.deptno
                                                                 GROUP BY deptno) avg_sal
FROM emp, emp_test
WHERE emp.empno = emp_test.empno
ORDER BY deptno desc;

-----------------------------------------------------------------------

-- 1
-- sql응용 ppt 48p
-- Q. 서브쿼리 ADVANCED (WITH)
-- 부서별 평균 급여가 직원 전체의 급여보다 높은 부서의
-- 부서번호와 부서별 급여 평균 금액 조회

-- 전체 직원의 급여평균 2073.21
SELECT ROUND(AVG(sal), 2)
FROM emp;

-- 부서별 직원의 급여 평균 10 XXX, 20 YYY, 30 ZZZ
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno;

-- 부서별 평균 급여가 직원 전체의 급여보다 높은 부서 (10, 20)
SELECT *
FROM
    (SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
    FROM emp
    GROUP BY deptno)
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2)
                  FROM emp);
                  
-- 아래의 쿼리와 같다.                  
SELECT *
FROM
    (SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
    FROM emp
    GROUP BY deptno)
WHERE d_avgsal > (2073.21);

-- 쿼리 블럭을 WITH절에 선언하여
-- 쿼리를 간단하게 표현한다.

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

-- 달력 만들기
-- STEP1.해당 년월의 일자 만들기 8P
-- CONNECT BY LEVEL
-- 201911
-- DATE + 정수 = 일자 더하기 연산
SELECT TO_DATE(:YYYYMM, 'YYYYMM'), level
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'DD');

SELECT TO_DATE(:YYYYMM, 'YYYYMM') + level, level
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'DD');

SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level-1)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'DD');

-- 입력한 달 나오게 하기
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level-1)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');

-- 포맷으로 바꾸기
SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw, -- 주차 구하기
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'day') day,-- 요일
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- 요일을 숫자로 표현 (1이 일요일)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');

-- 인라인뷰로 사용
SELECT  a.*,  
        DECODE(d, 1, dt) sun, DECODE(d, 2, dt) mon, DECODE(d, 3, dt) tue,
        DECODE(d, 4, dt) wed, DECODE(d, 5, dt) thu, DECODE(d, 6, dt) fri,
        DECODE(d, 7, dt) sat
FROM
(SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw, -- 주차 구하기
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- 요일을 숫자로 표현 (1이 일요일)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a;

-- 주차만 나오게 바꿈
SELECT  a.iw,  
        DECODE(d, 1, dt) sun, DECODE(d, 2, dt) mon, DECODE(d, 3, dt) tue,
        DECODE(d, 4, dt) wed, DECODE(d, 5, dt) thu, DECODE(d, 6, dt) fri,
        DECODE(d, 7, dt) sat
FROM
(SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw, -- 주차 구하기
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- 요일을 숫자로 표현 (1이 일요일)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a;


-- 달력 모양으로 바꿈 ( max나 min을 사용하면 숫자가 하나니깐 그 값이 나오고, 주차로 그룹바이를 하면 ...null은 ...)
SELECT  a.iw, 
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM
(SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw, -- 주차 구하기
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- 요일을 숫자로 표현 (1이 일요일)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
GROUP BY a.iw
ORDER BY a.iw;

-- 주차가 sun일 때 하나 증가하도록 변경
SELECT  a.iw, 
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM
(SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level), 'iw') iw, -- 주차 구하기
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- 요일을 숫자로 표현 (1이 일요일)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
GROUP BY a.iw
ORDER BY a.iw;

-- 쌤 방식
SELECT  decode(d, 1, a.iw+1, a.iw) iw, 
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM
(SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw, -- 주차 구하기
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d -- 요일을 숫자로 표현 (1이 일요일)
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
GROUP BY decode(d, 1, a.iw+1, a.iw)
ORDER BY decode(d, 1, a.iw+1, a.iw);

-----------------------------------------------------------------------------------------

-- 2-1

-- Q. 복습(실습 calendar2) 20P
-- 해당 월의 모든 주차에 대해 날짜를 다음과 같이 출력하도록 쿼리를 작성해보세요.
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

-- 달력만들기 복습 데이터 넣기

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

-- Q. 복습(실습 calendar1)
-- 달력만들기 복습 데이터.sql의 일별 실적 데이터를 이용하여
-- 1~6월의 월별 실적 데이터를 다음과 같이 구하세요.

-- 우선 월별 실적 합계를 구한다.
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

-- 쌤 답

SELECT NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '01', SUM(sales))),0) jan, 
       NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '02', SUM(sales))),0) fev, 
       NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '03', SUM(sales))),0) mar,
       NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '04', SUM(sales))),0) apr, 
       NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '05', SUM(sales))),0) may,
       NVL(MAX(DECODE(TO_CHAR(dt, 'MM'), '06', SUM(sales))),0) jun
FROM sales
GROUP BY TO_CHAR(dt, 'MM');

-----------------------------------------------------------------------------------------

-- 계층쿼리 중요중요!!!! (SQL응용 PPT 51~)
-- START WITH : 계층의 시작 부분을 정의
-- CONNECT BY : 계층간 연결 조건을 정의

-- 하향식 계층쿼리 (가장 최상위 조직에서부터 모든 조직을 탐색)

SELECT *
FROM dept_h
START WITH deptcd ='dept0'           -- START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;  -- PRIOR는 현재 읽은 데이터를 말함(XX회사)
------스샷 있음!!**************************************************************************

-- LEVEL 사용해서 계층을 표현하기 전 LPAD 사용예시
SELECT dept_h.*, LEVEL, LPAD('T', 15, '*') -- T라고 하는 문자열을 찍는데, 15글자가 안되면 왼쪽에 *을 찍어라.
FROM dept_h
START WITH deptcd ='dept0'           -- START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;  -- PRIOR는 현재 읽은 데이터를 말함(XX회사)

-- LEVEL 사용해서 계층을 표현
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4, ' ') || dept_h.deptnm  
FROM dept_h
START WITH deptcd ='dept0'           -- START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;  -- PRIOR는 현재 읽은 데이터를 말함(XX회사)



-- 계층쿼리 관련 테이블 생성 쿼리 (61p 참고)
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;

-----------------------------------------------------------------------------------------
-- Q. 계층쿼리 (실습 h_2)
-- 정보시스템부 하위의 부서계층 구조를 조회하는 쿼리를 작성하세요. 73p









