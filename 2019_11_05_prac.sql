-- 년월 파라미터가 주어졌을 때 해당년월의 일수를 구하는 문제
-- 201911 --> 30 / 201912 --> 31

-- 한달 더한 후 원래값을 빼면 = 일수
-- 마지막날짜 구한 후 --> DD만 추출
SELECT  TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD') day_cnt
FROM dual;

SELECT :yyyymm as param, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD') day_cnt
FROM dual;

-- 실행계획을 작성하라는 것
explain plan for -- 실행하면 설명되었습니다.라고 뜸
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369'; -- 7369문자열이 숫자로 묵시적 형변환

-- 실행계획을 확인할 때 쓰는 쿼리
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

-- function null
-- NVL(coll, coll이 null일 경우 대체할 값)
SELECT empno, ename,sal, comm, nvl(comm, 0) nvl_comm,
       sal + comm, 
       sal + nvl(comm, 0),
       nvl(sal + comm, 0) -- 어디다가 nvl을 적용할지 잘 생각해봐야 한다.
FROM emp;

--NVL2(coll, coll이 null이 아닐 경우 표현되는 값, coll null일 경우 표현 되는 값)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

-- NULLIF(expr1, expr2)
-- expr1 == expr2 같으면 null
-- else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

-- COALESCE(expr1, expr2, expr3 ...)
-- 함수 인자 중 null이 아닌 첫번째 인자
-- comm을 먼저 넣고 comm이 null이면 sal을 넣는다.
SELECT empno, ename, sal, comm, coalesce(comm, sal) 
FROM emp;

-- Q. 실습4 ) Function (null 실습) 137p
-- emp테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요.

-- nvl

-- nvl2

-- coalesce

-- Q. 실습5 ) Function (null 실습) 138p
-- users테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요.
-- reg_dt가 null일 경우 sysdate를 적용


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

-- Q. 실습1) Function (Condition 실습) 143p
-- emp 테이블을 이용하여 deptno에 따라 부서명으로 변경해서 다음과 같이 조회되도록 쿼리를 작성하세요.

-- case


-- decode


-- Q. 실습2) Function (Condition 실습) 144p
-- emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진대상자인지 조회하는 쿼리를 작성하세요.
-- (생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다

-- 내가 푼 것
-- 올해가 홀수이면 홀수 입사일자인 사람, 올해가 짝수이면 짝수 입사일자인 사람이 대상자이다.


-- 쌤 답

-- 올 해는 짝수인가? 홀수인가?
-- 1. 올해 년도 구하기 (DATE --> TO_CHAR(DATE, FORMAT)
-- 2. 올해 년도가 짝수인지 계산
-- 어떤 수를 2로 나누면 나머지는 항상 2보다 작다.
-- 2로 나눌경우 나머지는 0, 1
-- MOD(대상, 나눌값)


--emp 테이블에서 입사일자가 홀수년인지 짝수년인지 확인


-- Q. 실습3) Function (Condition 실습) 145p
-- users 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진대상자인지 조회하는 쿼리를 작성하세요.
-- (생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다)

-- 그룹함수 (AVG, MAX, MIN, SUM, COUNT)
-- 그룹함수는 NULL값을 계산대상에서 제외한다.
-- (그래서 SUM(comm), COUNT(*), COUNT(mgr) 이 각각 달랐다.)
-- 직원 중 가장 높은 급여를 받는 사람의 급여
-- 직원 중 가장 낮은 급여를 받는 사람의 급여
-- 직원의 급여 평균 (소수점 둘째자리까지만 나오게 --> 소수점 3째자리에서 반올림)
-- 직원의 급여 전체합
-- 직원의 수
-- 특정 컬럼의 수 (null이 없으면 1)
SELECT MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp;

-- 부서별 가장 높은 급여를 받는 사람의 급여
-- GROUP BY절에 기술되지 않은 컬럼이 SELECT절에 기술될 경우 에러



--!! GROP BY를 할 때 관련 없는 컬럼이 나오면 에러발생함. !!--
SELECT deptno, ename, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--!! 이런식으로 그룹함수만 오게 변경해야한다. !!--
SELECT deptno, MIN(ename), MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--!!의미없는 문자열이나 정수는 괜찮다.!!--
SELECT deptno, 'test', 1,  MAX(sal) max_sal
FROM emp
GROUP BY deptno;

-- 부서별 최대 급여
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--!!에러발생, WHERE(조건절) 그룹함수일때는 쓸 수 없다. HAVING으로 써야함. !!--
SELECT deptno, MAX(sal) max_sal
FROM emp
WHERE MAX(sal) > 3000
GROUP BY deptno;

-- Q. 실습1) Function (group function 실습) 159p
-- emp테이블을 이용하여 다음을 구하시오.
-- 직원중 가장 높은 급여
-- 직원중 가장 낮은 급여
-- 직원의 급여 평균
-- 직원의 급여 합
-- 직원중 급여가 있는 직원의 수 (null 제외)
-- 직원중 상급자가 있는 직원의 수 (null 제외)
-- 전체 직원의 수

-- Q. 실습2) Function (group function 실습) 160p
/*
    emp테이블을 이용하여 다음을 구하시오
    - 부서기준 직원중 가장 높은 급여
    - 부서기준 직원중 가장 낮은 급여
    - 부서기준 직원의 급여 평균
    - 부서기준 직원의 급여 합
    - 부서의 직원중 급여가 있는 직원의 수(NULL제외)
    - 부서의 직원중 상급자가 있는 직원의 수(NULL제외)
    - 부서의 전체 직원의 수
*/



