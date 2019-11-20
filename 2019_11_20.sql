-- GROUPING (cube, rollup 절의 사용된 컬럼)
-- 해당 컬럼이 소계 계산에 사용된 경우 1
-- 사용되지 않은 경우 0

-- job 컬럼
-- case1.GROUPING(job)= 1 AND GROUPING(deptno) = 1
--       job --> '총계'
-- case else
--       job --> job

-- 기존 쿼리
SELECT job, deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


-- job컬럼 하나가 길게 된 것.
SELECT CASE WHEN GROUPING(job) = 1 AND 
                 GROUPING(deptno) = 1 THEN '총계'
            ELSE job
       END AS job, deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


-- Q. GROUPING(deptno)가 1인 경우 deptno에 job명 +  소계가 들어가도록 만들기

SELECT CASE 
            WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '총계'
            ELSE job
       END AS job, 
       CASE 
            WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 1 THEN job || '소계'
            ELSE TO_CHAR(DEPTNO)
       END AS deptno, 
       GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

-- Q. report group function ( 실습 GROUP_AD3) P25
-- table: emp
-- 조건 group by절을 한번만 사용
SELECT deptno, job, sum(sal) sal 
FROM emp
GROUP BY ROLLUP (deptno, job);

-- 과제
-- Q. report group function ( 실습 GROUP_AD4) P26
-- Q. report group function ( 실습 GROUP_AD5) P27

-- << CUBE (col1, col2..) >>
-- CUBE절에 나열된 컬럼의 가능한 모든 조합에 대해 서브 그룹으로 생성
-- CUBE에 나열된 컬럼에 대해 방향성은 없다(rollup과의 차이)
-- GROUP BY CUBE(job, deptno)
-- oo : GROUP BY job, deptno
-- ox : GROUP BY job
-- xo : GROUP BY deptno
-- xx : GROUP BY        -- 모든 데이터에 대해서..

-- GROUP BY CUBE(job, deptno, mgr) -- 2의 3승, 8가지

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);
--- 스샷 있음

-----------------------------------------------------------------------------------------

--subquery를 통한 업데이트
DROP TABLE emp_test;

--emp테이블의 데이터를 포함해서 모든 컬럼을 emp_table로 생성
CREATE TABLE emp_test AS
SELECT *
FROM emp;

-- emp_test 테이블의 dept테이블에서 관리되고 있는 dname(VARCHAR2(14)) 컬럼을 추가
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

-- emp_test 테이블의 dname컬럼을 dept 테이블의 dname 컬럼 값으로 업데이트하는 쿼리 작성
UPDATE emp_test SET dname = ( SELECT dname
                              FROM dept
                              WHERE d
                              ept.deptno = emp_test.deptno);
-- WHERE empno IN (7369, 7499); --  특정 컬럼에 대해서만 넣고 싶을때
COMMIT;

-- Q. 서브쿼리 ADVANCED (correlated subquery update 실습 sub_a1) P42
-- dept테이블을 이용하여 dept_test 테이블 생성
-- dept_test 테이블에 empcnt (number) 컬럼 추가
-- subquery를 이용하여 dept_test 테이블의 empcnt 컬럼에 
-- 해당 부서원 수를 update쿼리를 작성하세요.
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

SELECT *
FROM dept_test;

-- 10번 부서의 부서원 수 구하는 쿼리
SELECT count(deptno)
FROM emp_test
WHERE deptno = 10;

ALTER TABLE dept_test ADD (empcnt NUMBER);



-- dept_test테이블의 empcnt 컬럼을 emp테이블을 이용하여 (subquery) update
UPDATE dept_test SET empcnt = (SELECT count(*)
                                FROM emp
                                WHERE deptno = dept_test.deptno);

-- 명성이답 값없으면null                                
UPDATE dept_test SET empcnt = (SELECT count(deptno)
                                FROM emp_test
                                WHERE dept_test.deptno = emp_test.deptno
                                GROUP BY deptno);
                                

rollback;                                
--------------------------------------------------------------------------------
SELECT *
FROM dept_test;


-- Q. 서브쿼리 ADVANCED(correlated subquery delete 실습 sub_a2)
-- dept 테이블을 이용하여 dept_test 테이블 생성
-- dept_test 테이블에 신규 데이터 2건 추가(나는 99있어서 1건만 추가)
INSERT INTO dept_test VALUES (98, 'it', 'daejeon', 0);
-- emp테이블의 직원들이 속하지 않은 부서 정보 삭제하는 쿼리를 
-- 서브쿼리를 이용하여 작성하세요.
DELETE FROM dept_test 
WHERE empcnt = 0;

-- 사원이 속한 부서정보 조회
SELECT *
FROM dept 
WHERE NOT EXISTS (SELECT 'x'
                  FROM emp
                  WHERE emp.deptno = dept.deptno);
              
DELETE dept_test 
WHERE NOT EXISTS (SELECT 'x'
                  FROM emp
                  WHERE emp.deptno = dept_test.deptno);              

DELETE dept_test 
WHERE empcnt = (SELECT COUNT(*)
                FROM emp
                WHERE emp.deptno = dept_test.deptno
                GROUP BY deptno);    
                                
rollback;






