-- 복습
-- 그룹함수
-- multi row function : 여러개의 행을 입력으로 하나의 결과 행을 생성
-- SUM, MAX, MIN, AVG, COUNT
-- GROUP BY col | express
-- SELECT 절에는 GROUP BY 절에 기술된 COL, EXPRESS 표기 가능


-- 직원 중 가장 높은 급여 조회
-- 14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

-- 부서별 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--------------------------------------------------------------------------------------------------------------------
-- Q. group function 실습 grp3 161p
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
-- 내가 푼 것
SELECT decode(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- 쌤 답
SELECT decode(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY decode(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT');

-- Q. group function 실습 grp4 162p
-- emp테이블을 이용하여 다음을 구하시오.
-- 직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요.

SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, count(*) cnt -- *는 그룹바이 된걸 기준으로 센다.
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM')
ORDER BY TO_CHAR(hiredate, 'YYYYMM');

-- Q. group function 실습 grp5 163p
-- emp테이블을 이용하여 다음을 구하시오.
-- 직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요.
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyymm, count(*) cnt 
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

-- Q. group function 실습 grp6 164p
-- 회사에 존재하는 부서의 개수는 몇개인지 조회하는 쿼리를 작성하시오. (dept테이블 사용)

SELECT count(deptno) cnt
FROM dept;

-- diptno 컬럼에서 중복을 제거하는 것. 여기에서는 부서가 40번이 없어서 맞지 않음.
SELECT distinct deptno
FROM emp;

-- JOIN
-- emp 테이블에는 dname 컬럼이 없다. --> 부서번호(deptno)밖에 없음.
desc emp;

-- emp테이블에 부서이름을 저장할 수 있는 dname 컬럼 추가
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
*/
-- emp테이블 dname 컬럼에 데이터 수정
UPDATE emp SET dname ='ACCOUNTING' WHERE deptno=10;
UPDATE emp SET dname ='RESEARCH' WHERE deptno=20;
UPDATE emp SET dname ='SALES' WHERE deptno=30;
commit;

-- 이렇게 해서 deptno를 decode했었는데
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

-- dname 컬럼이 생겨서 이제 이렇게만 해주면 됨.
SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

-- dname 컬럼을 삭제함.
ALTER TABLE emp DROP COLUMN dname;
commit;

-- ansi natural join : 조인하는 테이블의 컬럼명이 같은 컬럼을 기준으로 JOIN
SELECT deptno, ename, dname
FROM emp NATURAL JOIN dept;

-- ORACLE join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 테이블에 별칭을 줘서 사용할 수도 있다.
SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI JOIN WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

-- ORACLE join
-- from 절에 조인 대상 테이블 나열
-- where절에 조인조건 기술
-- 기존에 사용하던 조건 제약도 기술 가능
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN'; -- job이 SALESMAN인 사람만 대상으로 조회
  
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.job = 'SALESMAN'
AND emp.deptno = dept.deptno; -- where 안에 순서가 바뀌어도 잘 작동함.

-- JOIN with ON (개발자가 조인 컬럼을 on절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- SELF join : 같은 테이블끼리 조인 ppt 176p
-- emp 테이블의 mgr 정보를 참고하기 위해서 emp 테이블과 조인을 해야한다.
-- a : 직원 정보, b : 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno) -- a의 mgr정보과 b의 empno가 같은사람, 그래서 KING은 mgr이 없어서 빠짐.
WHERE a.empno BETWEEN 7369 AND 7698;

-- SELT join 예시를 Oracle join으로 변경해보자.
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno BETWEEN 7369 AND 7698;

-- non-equi joing (등식 조인이 아닌 경우) 177p
SELECT *
FROM salgrade; -- sal의 등급

-- 직원의 급여 등급은?(non-equijoin)
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

-- 직원의 급여 등급은?(JOIN with ON으로)
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON (emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

-- non-equi join
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr != b.empno
AND a.empno = 7369; -- mgr가 7369인 데이터 하나 빼고 나와서 13개 나옴.

-- non-equi join
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno = 7369; -- join조건을 기술하지 않아 b테이블은 모든 컬럼 나와서 14개 나옴.(Partition product, 묻지마join)

-- Q. 데이터결합 (실습 join0) 180p
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
SELECT a.empno, a.ename, b.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;

-- Q. 데이터결합 (실습 join0_1) 181p
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
-- (부서번호가 10, 30인 데이터만 조회)

-- and, or
SELECT a.empno, a.ename, b.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
AND (a.deptno = 10
OR a.deptno = 30)
ORDER BY empno;

-- in
SELECT a.empno, a.ename, b.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
AND a.deptno IN (10,30)
ORDER BY empno;