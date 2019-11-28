-- 어제 문제를 분석함수로 변경

SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank
FROM emp;

SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank, -- 1 2 2 4
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank, -- 1 2 2 3
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown -- 1 2  3 4
FROM emp;


-- sql 응용 ppt 105p
-- Q. 실습 ana1
-- 사원의 전체 급여 순위를 rank, dense_rank, row_number를 이용하여 구하세요.
-- 단 급여가 동일할 경우 사번이 빠른 사람이 높은순위가 되도록 작성하세요.

-- 내 풀이
SELECT ename, sal, deptno,
       RANK() OVER (ORDER BY sal desc) rank,
       DENSE_RANK() OVER (ORDER BY sal desc) d_rank,
       ROW_NUMBER() OVER (ORDER BY sal desc) rown
FROM emp;

-- 쌤 답
SELECT empno, ename, sal, deptno,
       RANK() OVER (ORDER BY sal DESC, empno) rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown
FROM emp;

-- sql 응용 ppt 106p
-- Q. 실습 no_ana2
-- 기존에 배운 내용을 활용하여 모든 사원에 대해 사원번호, 사원이름,
-- 해당사원이 속한 부서의 사원 수를 조회하는 쿼리를 작성하세요.

-- 내가 시도한 것
SELECT empno, ename, deptno, count(*),
       RANK() OVER (ORDER BY sal DESC, empno) rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown
FROM emp
GROUP BY empno, ename, deptno;

-- 쌤 답
SELECT deptno, count(*)
FROM emp
GROUP BY deptno;

SELECT ename, empno, deptno
FROM emp;

-- join을 통한 부서별 직원 수
SELECT ename, empno, a.deptno, b.cnt
FROM emp a, (SELECT deptno, count(*) cnt
             FROM emp
             GROUP BY deptno) b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;

-- 분석함수를 통한 부서별 직원 수 (COUNT) 
-- 수를 세는 것이기 때문에 정렬(order by)이 필요없다.
SELECT ename, empno, deptno, 
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- 부서별 사원의 급여 합계
-- SUM 분석함수
SELECT ename, empno, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

-- sql 응용 ppt 109p
-- Q. 실습 ana2
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여,
-- 부서번호와 해당 사원이 속한 부서의 급여 평균을 조회하는 쿼리를 작성하세요.
-- (급여 평균은 소수점 둘째 자리까지 구한다.)
SELECT empno, ename, sal, deptno,
       ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg_sal
FROM emp;

-- sql 응용 ppt 110p
-- Q. 실습 ana3
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여,
-- 부서번호와 해당 사원이 속한 부서의 가장 높은 급여를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, sal, deptno,
       MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

-- sql 응용 ppt 111p
-- Q. 실습 ana4
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여,
-- 부서번호와 해당 사원이 속한 부서의 가장 낮은 급여를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, sal, deptno,
       MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

-- 부서별 사원번호가 가장 빠른 사람
-- 부서별 사원번호가 가장 느린 사람
SELECT empno, ename, deptno,
       FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
       LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

-- 113p
-- LAG (이전행)
-- 현재행
-- LEAD (다음행)
-- 급여가 높은 순으로 정렬 했을 때 자기보다 한단계 급여가 낮은 사람의 급여,
-- 급여가 높은 순으로 정렬 했을 때 자기보다 한단계 급여가 높은 사람의 급여 -- 다시 할 예정

SELECT empno, ename, sal, 
       LAG(sal) OVER (ORDER BY sal) lag_sal,
       LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

-- sql 응용 ppt 116p
-- Q. 실습 ana5
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자,
-- 급여, 전체 사원중 급여 순위가 1단계 낮은 사람의 급여를 조회하는 쿼리를 작성하세요.
-- (급여가 같을 경우 입사일이 빠른 사람이 높은 순위)

-- 내가 푼 풀이
SELECT empno, ename, hiredate, sal, 
       LAG(sal) OVER (ORDER BY sal) lag_sal
FROM emp
ORDER BY sal desc, hiredate;

-- 쌤 답
SELECT empno, ename, hiredate, sal, 
       LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp
ORDER BY sal DESC, hiredate;

-- sql 응용 ppt 117p
-- Q. 실습 ana6
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자,
-- 직군(job), 급여정보와 담당업무(JOB)별 급여 순위가 1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요.
-- (급여가 같을 경우 입사일이 빠른 사람이 높은 순위)

-- 내 풀이
SELECT empno, ename, hiredate, job, sal, 
       LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp
ORDER BY job, sal DESC;

-- 쌤 풀이
SELECT empno, ename, hiredate, job, sal, 
       LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

-- sql 응용 ppt 118p
-- Q. 실습 no_ana6
-- 모든 사원에 대해 사원번호, 사원이름, 급여를 급여가 낮은순으로 조회해보자.
-- 급여가 동일할 경우 사원번호가 빠른 사람이 우선순위가 높다.
-- 우선순위가 가장 낮은 사람부터 본인까지의 급여 합을 새로운 컬럼에 넣어보자
-- widow 함수 없이 풀기

-- 내가 시도
SELECT a.empno, a.ename, a.sal /*c_sum*/
FROM emp a, emp b 
WHERE a.empno = b.empno
ORDER BY sal, empno;

SELECT a.empno, a.ename, a.sal /*c_sum*/
FROM emp a, emp b 
WHERE a.empno = b.empno
ORDER BY sal, empno;

SELECT a.*, ROWNUM
FROM
(SELECT empno, ename, sal
FROM emp  
ORDER BY sal, empno)a, 
(SELECT empno, ename, sal
FROM emp  
ORDER BY sal, empno)b;

-- 쌤 풀이
SELECT a.empno, a.ename, a.sal, sum(b.sal) sal_sum
FROM
    (SELECT a.*, ROWNUM rn
    FROM
        (SELECT empno, ename, sal
        FROM emp  
        ORDER BY sal, empno)a)a,
    
    (SELECT b.*, ROWNUM rn
    FROM
        (SELECT empno, ename, sal
        FROM emp  
        ORDER BY sal, empno)b)b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;

-- 120p
-- WINDOWING
-- UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든 행
-- CURRENT ROW : 현재 행
-- UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든 행
-- N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
-- N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal, -- 선행하는 것부터 자기까지의 합
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2, -- 선행하는것부터 후행하는 것들의 합(총합)
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3 -- 자기 앞, 자기, 자기 뒤 합친 것
FROM emp;

-- sql 응용 ppt 126p
-- Q. 실습 ana7
-- 사원번호, 사원이름, 부서번호, 급여 정보를 부서별로 급여, 사원번호 오름차순으로 정렬했을 때,
-- 자신의 급여와 선행하는 사원들의 급여의 합을 조회하는 쿼리를 작성하세요.
-- widow 함수 사용

SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum -- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW이 기본값이라 없어도 같음.
FROM emp;

-- between으로 자기행을 쓰지 않더라도 값이 똑같다.
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2
FROM emp;

-- RANGE(ROWS를 RANGE로 변경)
-- 논리적인 행의 위치이다. 값이 같은 것을 하나의 행으로 본다.(같은 값의 갯수를 곱한만큼 더해짐)
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2,
       SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum3,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) row_sum4
FROM emp;

