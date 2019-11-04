-- 복습
-- WHERE
-- 연산자
-- 비교 : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' (%: 다수의 문자열과 매칭, _ : 정확히 한글자 매칭)
-- IS NULL (!= NULL은 안됨)
-- AND, OR, NOT

-- Q. emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는
-- 직원 정보조회
-- BETWEEN AND

-- >=, <=


-- Q. emp 테이블에서 관리자(mgr)가 있는 직원만 조회


-- Q. 실습13 ) 논리연산 (AND, OR 실습)
-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요. 
-- (like 연산자를 사용하지 마세요. empno는 정수 4자리까지 허용 78,780,789)
-- empno : 7800 ~ 7899
--         780 ~ 789
--         7~78

  
-- 쌤 답


-- 연산의 우선순위 AND가 OR보다 높다.
  -- Q. 실습13 ) 논리연산 (AND, OR 실습)
-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요. 
-- (like 연산자를 사용하지 마세요. empno는 정수 4자리까지 허용 78,780,789) 
   
-- Q. 실습14 ) 논리연산 (AND, OR 실습)
-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요. 

  
-- order by 컬럼명 | 별칭 | 컬럼인덱스 [ASC | DESC]
-- order by 구문은 WHERE절 다음에 기술
-- WHERE 절이 없을 경우 FROM절 다음에 기술
-- emp테이블을 ename 기준으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename ASC; -- ASC(기본 오름차순)

-- 이름(ename)을 기준으로 내림차순
SELECT *
FROM emp
ORDER BY ename DESC;

-- job을 기준으로 내림차순으로 정렬, 만약 job이 같은 경우
-- 사번(empno)으로 올림차순 정렬
SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

-- 별칭으로 정렬하기
-- 사원 번호(empno), 사원명(ename), 연봉(sal * 12) as year_sal
-- year_sal 별칭으로 오른차순 정렬
SELECT empno, ename, sal, sal *12 AS year_sal
FROM emp
ORDER BY year_sal ASC;

-- SELECT절 컬럼 순서 인덱스로 정렬
SELECT empno, ename, sal, sal *12 AS year_sal
FROM emp
ORDER BY 2;

-- Q. 실습1 ) 데이터 정렬 (ORDER BY 실습)
-- dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요.


-- Q. dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요.


-- 컬럼명을 명시하지 않았습니다. 지난 수업시간에 배운 내용으로 올바른 컬럼을 찾아보세요.

-- Q. 실습2 ) 데이터 정렬 (ORDER BY 실습)
-- emp 테이블에서 상여(comm) 정보가 있는 사람들만 조회하고,
-- 상여(comm)를 많이 받는 사람이 먼저 조회되도록 하고, 상여가 같을 경우
-- 사번으로 오름차순 정렬하세요.


-- Q. 실습3 ) 데이터 정렬 (ORDER BY 실습)
-- emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군(job) 순으로
-- 오름차순 정렬하고, 직업이 같은 경우 사번이 큰 사원이 먼저 조회되도록
-- 쿼리를 작성하세요.


-- Q. 실습4 ) 데이터 정렬 (ORDER BY 실습)
-- emp 테이블에서 10번 부서(deptno)혹은 30번 부서에 속하는 사람 중 
-- 급여(sal)가 1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록
-- 쿼리를 작성하시오.


-- emp 테이블을 사번(empno), 이름(ename)을 급여 기준으로 오름차순 정렬하고
-- 정렬된 결과순으로 ROWNUM

-- 잘못된 예
SELECT ROWNUM, empno, ename, sal
FROM emp
ORDER BY sal;

-- 잘된 예
SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a;

-- Q. 실습1 ) 데이터 정렬 (ROWNUM 실습) 84p
-- emp 테이블에서 ROWNUM값이 1~10인 값만 조회하는 쿼리를 작성해보세요.
-- (정렬없이 진행하세요, 결과는 화면과 다를 수 있습니다.) 


-- Q. 실습2 ) 데이터 정렬 (ROWNUM 실습) 86p
-- ROWNUM 값이 11~14인 값만 조회하는 쿼리를 작성해보세요.
-- HINT : alias, inline-view


--쌤 답


-- FUNCTION
-- DUAL 테이블 조회
SELECT 'HELLO WORLD' as msg
FROM DUAL;

-- 문자열 대소문자 관련 함수
-- LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('hello, world')
FROM dual;

SELECT LOWER('Hello, World')
FROM dual;

SELECT UPPER('Hello, World')
FROM dual;

SELECT INITCAP('hello, world')
FROM dual;

-- FUNCTION은 WHERE절에서도 사용가능
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith'; -- ename컬럼 안에 있는 데이터들을 소문자로 변환한다음 비교하는 것.

-- 개발자 SQL 칠거지악
-- 1.좌변을 가공하지 말아라
-- 좌변(TAVLE의 컬럼)을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
-- Function Based Index -> FBI

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
       RPAD('HELLO, WORLD', 15, '*') rpad -- HELLO, WORLD***
FROM dual;


