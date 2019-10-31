----------------------------------복습
-- 테이블에서 데이터 조회
/*
    SELECT 컬럼 : express (문자열상수) [as] 별칭
    FROM 데이터를 조회할 테이블(VIEW)
    WHERE 조건 (condition)

*/

DESC user_tables;
SELECT table_name, 'SELECT * FROM ' || table_name || ';' select_query
FROM user_tables
WHERE TABLE_NAME = 'EMP';
--전체건수 -1

SELECT *
FROM user_tables;
----------------------------------복습 끝

-- 숫자비교 연산
-- Q) 부서번호가 30번보다 크거나 같은 부서에 속한 직원 조회 (테이블 emp, 부서번호 depno)
SELECT *
FROM emp
WHERE deptno >= 30;

-- Q) 부서번호가 30번보다 작은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno < 30;

-- Q) 입사일자가 1982년 1월 1일 이후인 직원 조회 (테이블 emp, 입사일자 hiredate)
SELECT * 
FROM emp
WHERE hiredate < '82/01/01'; --문자열인데 어떻게 날짜로 인식했을까? 도구 - 설정 - 데이터베이스 - NLS에 날짜형식이 RR/MM/DD로 되어있어서  
--WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD'); -- 따라서 이렇게 쓰는게 좋다.

-- col BETWEEN X AND Y 연산   
-- 컬럼의 값이 X보다 크거나 같고, Y보다 작거나 같은 데이터
-- Q) 급여(sal)가 1000보다 크거나 같고, Y보다 작거나 같은 데이터를 조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

-- 위의 BETWEEN AND 연산자는 아래의 <=, >= 조합과 같다. (+ 부서번호가 30)
SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000
AND deptno = 30;

-- Q. 실습1 ) 조건에 맞는 데이터 조회하기
-- emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전이 사원의
-- ename, hiredate 데이터를 조회하는 쿼리를 작성하시오.
-- (단, 연산자는 between을 사용한다.)

SELECT ename, hiredate
FROM emp
WHERE hiredate between TO_DATE('82/01/01','RR/MM/DD') AND TO_DATE('1983/01/01','YYYY/MM/DD'); 

-- Q. 실습2 ) 조건에 맞는 데이터 조회하기
-- emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전이 사원의
-- ename, hiredate 데이터를 조회하는 쿼리를 작성하시오.
-- (단, 연산자는 비교연산자(>=,>,<=,<를 사용한다.)

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('82/01/01','RR/MM/DD') 
  AND hiredate <= TO_DATE('1983/01/01','YYYY/MM/DD');

-- IN 연산자
-- COL IN (values...)
-- 부서번호가 10 혹은 20인 직원 조회
SELECT *
FROM emp
WHERE deptno in (10,20);

-- IN 연산자는 OR 연산자로 표현할 수 있다.
SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;
   
-- Q. 실습3 ) 조건에 맞는 데이터 조회하기
-- users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회하시오. (아이디, 이름, 별명 나오게)
-- (IN 연산자를 사용한다.)

SELECT userid as "아이디", usernm 이름, alias 별명 
FROM users
WHERE userid in ('brown','cony','sally'); 


-- COL LIKE 'S%'
-- COL의 값이 대문자 S로 시작하는 모든 값
-- COL LIKE 'S____'
-- COL의 값이 대문자 S로 시작하고 이어서 4개의 문자열이 존재하는 값

-- emp 테이블에서 직원이름이 S로 시작하는 모든 직원 조회
SELECT *
FROM emp
WHERE ename LIKE 'S%'; -- 오라클에서 키워드는 대소문자를 가리지 않지만 값은 대소문자를 가린다.

SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- Q. 실습4 ) 조건에 맞는 데이터 조회하기
-- member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오.
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

-- Q. 실습5 ) 조건에 맞는 데이터 조회하기
-- member 테이블에서 회원의 이름에 글자[이]가 들어가는 모든 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오.
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

-- NULL 비교
-- col IS NULL
-- EMP 테이블에서 MGR 정보가 없는 사람(NULL) 조회
SELECT * 
FROM emp
WHERE mgr IS NULL;
--WHERE mgr != null; -- null 비교가 실패한다.

-- 소속 부서가 10번이 아닌 직원들
SELECT *
FROM emp
WHERE deptno != '10';
-- =, !=
-- is null, is not null

-- Q. 실습6 ) 조건에 맞는 데이터 조회하기
-- emp 테이블에서 상여(comm)가 있는 회원의 정보를 다음과 같이 조회되도록 작성하시오.
SELECT *
FROM emp
WHERE comm IS NOT NULL;

-- AND / OR
-- 관리자(mgr) 사번이 7698이고 급여(sal)가 1000 이상인 직원 조회
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal >= 1000;

-- 관리자(mgr) 사번이 7698이거나 급여(sal)가 1000 이상인 직원 조회
SELECT *
FROM emp
WHERE mgr = 7698
   OR sal >= 1000;

-- emp 테이블에서 관리자(mgr) 사번이 7698이 아니고, 7839가 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839); 

-- 위의 쿼리를 AND/OR 연산자로 변환
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;
  
-- IN, NOT IN 연산자의 NULL 처리
-- emp 테이블에서 관리자(mgr) 사번이 7698, 7839 또는 null이 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839, NULL); 
-- IN 연산자에서 결과값에 NULL이 있을 경우 의도하지 않은 동작을 한다.
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839)
  AND mgr IS NOT NULL;
  
-- Q. 실습7 ) 논리연산 (AND, OR 실습)
-- emp 테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
  
-- Q. 실습8 ) 논리연산 (AND, OR 실습)
-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
-- (IN, NOT IN 연산자 사용금지)
SELECT *
FROM emp
WHERE deptno != 10
  AND hiredate >= TO_DATE('19810601','YYYYMMDD');

-- Q. 실습9 ) 논리연산 (AND, OR 실습)
-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
-- (IN, NOT IN 연산자 사용)
SELECT *
FROM emp
WHERE deptno NOT IN 10
  AND hiredate >= TO_DATE('19810601','YYYYMMDD');

-- Q. 실습10 ) 논리연산 (AND, OR 실습)
-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
-- (부서는 10, 20, 30만 있다고 가정하고 IN 연산자를 사용)
SELECT *
FROM emp
WHERE deptno IN (20,30)
  AND hiredate >= TO_DATE('19810601','YYYYMMDD');
  
-- Q. 실습11 ) 논리연산 (AND, OR 실습)
-- emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
SELECT * 
FROM emp
WHERE job = 'SALESMAN' -- job IN('SALESMAN')과 같음.
   OR hiredate >= TO_DATE('19810601','YYYYMMDD');
  
-- Q. 실습12 ) 논리연산 (AND, OR 실습)
-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';
