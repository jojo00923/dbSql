-- 조인 복습
-- 조인 왜??
-- RDBMS의 특성상 데이터 중복을 최대 배제한 설계를 한다.
-- EMP 테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는 
-- 부서번호만 갖고 있고, 부서번호를 통해 dept 테이블과 조인을 통해
-- 해당 부서의 정보를 가져올 수 있다.

-- 직원 번호, 직원 이름, 직원의 소속부서번호, 부서이름
-- emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 부서번호, 부서명, 해당부서의 인원수
-- count(col) : col 값이 존재하면 1, null :  0
--              행수가 궁금한 것이면 *

SELECT emp.deptno, dname, count(*) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY emp.deptno, dname;

-- TOTAL ROW : 14
select COUNT(*), COUNT(EMPNO), COUNT(MGR), COUNT(COMM)
from emp;

-------------------------------------------------------------

-- OUTER JOIN : 조인에 실패도 기준이 되는 테이블의 데이터는 조회결과가
--              나오도록 하는 조인 형태
-- LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이
--                  되도록 하는 조인 형태
-- RIGHT OUTER JOIN : JOIN KEYWORD 오른쪽에 위치한 테이블이 조회 기준이
--                  되도록 하는 조인 형태
-- FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복제거

-- 직원 정보와, 해당 직원의 관리자 정보 OUTER JOIN
-- 직원 번호, 직원이름, 관리자 번호, 관리자 이름

-- << ANSI LEFT OUTER JOIN>>
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

-- outer join 안 먹은거
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);

-- << ORACLE OUTER JOIN >> (left, right만 존재, fullouter는 지원하지 않음.
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

-- outer join 안 먹은거
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno;


-- << ANSI LEFT OUTER JOIN>>
SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno AND b.deptno = 10);

-- outer join 안 먹은거
SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno)
WHERE b.deptno = 10;

-- << ORACLE OUTER JOIN >>
-- oracle outer 문법에서는 outer 테이블이 되는 모든 컬럼에 (+)를 붙여줘야
-- outer join이 정상적으로 동작한다.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno(+) = 10;

-- outer join 안 먹은거
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno = 10;

-- <<ANSI RIGHT OUTER JOIN >>
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON(a.mgr = b.empno);


-- Q. 데이터결합 (실습 outerjoin1) 213p
-- buyprod 테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다.
-- 모든 품목이 나올 수 있도록 쿼리를 작성해보세요.

-- << ANSI LEFT OUTER JOIN>>
SELECT b.buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a LEFT OUTER JOIN  buyprod b ON (a.prod_id = b.buy_prod AND b.buy_date = TO_DATE('20050125', 'YYYYMMDD'));

-- << ORACLE OUTER JOIN >>
SELECT b.buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a , buyprod b
WHERE a.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

-- Q. 데이터결합 (실습 outerjoin2) 214p
-- outerjoin1에서 작업을 시작하세요. buy_date 컬럼이 null인 항목이 안나오도록
-- 다음처럼 데이터를 채워지도록 쿼리를 작성하세요.

-- 내 풀이
SELECT DECODE(b.buy_date, NULL, TO_DATE('20050125', 'YYYYMMDD'), b.buy_date) buy_date , b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a , buyprod b
WHERE a.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

-- 쌤 풀이
SELECT TO_DATE('20050125', 'YYYYMMDD') buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM prod a , buyprod b
WHERE a.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

-- Q. 데이터결합 (실습 outerjoin3) 215p
-- outerjoin2에서 작업을 시작하세요. buy_qty 컬럼이 null일 경우 
-- 0으로 보이도록 쿼리를 수정하세요.

-- 내 풀이
SELECT TO_DATE('20050125', 'YYYYMMDD') buy_date, b.buy_prod, a.prod_id, a.prod_name, DECODE(b.buy_qty, NULL, 0, b.buy_qty) buy_qty
FROM prod a , buyprod b
WHERE a.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

-- 쌤 풀이
SELECT TO_DATE('20050125', 'YYYYMMDD') buy_date, b.buy_prod, a.prod_id, a.prod_name, NVL(b.buy_qty, 0)
FROM prod a , buyprod b
WHERE a.prod_id = b.buy_prod(+)
AND b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

-- Q. 데이터결합 (실습 outerjoin4) 216p
-- cycle, product 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고,
-- 고객1이 애음하지 않는 제품도 다음과 같이 조회되도록 쿼리를 작성하세요.
-- (고객은 cid=1인 고객만 나오도록 제한, null 처리)

SELECT product.pid, pnm, NVL(cid, 1) cid,  NVL(day, 0) day, NVL(cnt, 0) cnt
FROM cycle, product
WHERE cycle.pid(+) = product.pid
AND cycle.cid(+) = 1;

-- Q. 데이터결합 (실습 outerjoin5) 217p
-- cycle, product 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고,
-- 고객1이 애음하지 않는 제품도 다음과 같이 조회되며 고객이름을 포함하여 쿼리를 작성하세요.
-- (고객은 cid=1인 고객만 나오도록 제한, null 처리)
SELECT a.pid, a.pnm, a.cid, cnm, a.day, a.cnt
FROM
(    SELECT product.pid, pnm, NVL(cid, 1) cid,  NVL(day, 0) day, NVL(cnt, 0) cnt
    FROM cycle, product
    WHERE cycle.pid(+) = product.pid
    AND cycle.cid(+) = 1)a, customer b
WHERE a.cid = b.cid
ORDER BY pid desc, day desc;

-- Q. 데이터결합 (실습 crossjoin1) 223p
-- customer, product 테이블을 이용하여 고객이 애음 가능한 모든 제품의
-- 정보를 조합하여 다음과 같이 조회되도록 쿼리를 작성하세요.
SELECT cid, cnm, pid, pnm
FROM customer CROSS JOIN product;

-- subquery : main 쿼리에 속하는 부분 쿼리
-- 사용되는 위치 :
-- SELECT - scalar subquery (하나의 행과, 하나의 컬럼만 조회되는 쿼리이어야 한다.)
-- FROM - inline view
-- WHERE - subquery

-- SCALAR subquery
SELECT empno, ename, SYSDATE now/*현재날짜*/ 
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now  -- SELECT 안에 있는 SELECT절에는 하나의 컬럼만 써야함.
FROM emp;



-- WHERE - subquery
SELECT deptno  -- 20
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;

SELECT *
FROM emp
WHERE deptno = (SELECT deptno  -- 20
                FROM emp
                WHERE ename = 'SMITH');

-- Q. 서브쿼리 (실습 sub1) 230p
-- 평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요.

-- 내 풀이
-- 우선 평균 급여를 구한다.
SELECT SUM(sal)/COUNT(empno)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT SUM(sal)/COUNT(empno)
             FROM emp);
            
-- 쌤 풀이
SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);

-- Q. 서브쿼리 (실습 sub2) 231p
-- 평균 급여보다 높은 급여를 받는 직원의 정보를 조회하세요.

SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);



