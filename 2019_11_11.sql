--SMITH, WARD가 속하는 부서의 직원들 조회
SELECT *
FROM emp
WHERE deptno IN (10,20);

SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;
   
SELECT *
FROM emp
WHERE deptno in (SELECT deptno 
                 FROM emp 
                 WHERE ename IN ('SMITH','WARD'));
                 
SELECT *
FROM emp
WHERE deptno in (SELECT deptno 
                 FROM emp 
                 WHERE ename IN (:name1,:name2)); --- 물어보기

---------------------------------------------------------------------                 
-- << ANY >> : SET 중에 만족하는게 하나라도 있으면 참으로 (크기 비교)
-- SMITH 또는 WARD의 급여보다 적은 급여를 받는 직원 정보 조회

-- SMITH와 WARD의 급여
SELECT sal -- 800, 1250
FROM emp
WHERE ename IN ('SMITH','WARD');
                 
-- SMITH 또는 WARD의 급여보다 적은 급여를 받는 직원 정보         
SELECT *
FROM emp
WHERE sal < any( SELECT sal 
                 FROM emp
                 WHERE ename IN ('SMITH','WARD'));
-- << ALL >>                 
-- SMITH와 WARD의 급여보다 높은 급여를 받는 직원 정보   
-- SMITH보다도 급여가 높고 WARD보다도 급여가 높은 사람(AND)
SELECT *
FROM emp
WHERE sal < all( SELECT sal 
                 FROM emp
                 WHERE ename IN ('SMITH','WARD'));

-- << IN >>

-- 관리자의 직원정보
-- 1. 관리자인 사람만 조회
-- . mgr 컬럼에 값이 나오는 직원
SELECT DISTINCT(mgr)
FROM emp;

-- 어떤 직원의 관리자 역할을 하는 직원 정보 조회
SELECT *
FROM emp
WHERE empno IN (7839,7782,7698,7902,7566,7788);
-- KING - JONES - SCOTT
SELECT *
FROM emp
WHERE empno IN (SELECT DISTINCT(mgr)
                FROM emp);

-- << NOT IN >>
-- 관리자 역할을 하지 않는 평사원 정보 조회
-- 단 NOT IN 연산자 사용시 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
-- NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                FROM emp
                WHERE mgr IS NOT NULL);                

SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                FROM emp
                WHERE mgr IS NOT NULL);                
                 
-- << PAIR WISE >>
-- 사번 7499, 7782인 직원의 관리자, 부서번호 조회
-- 7698 30
-- 7839 10
SELECT mgr, deptno
FROM emp
WHERE empno IN (7499,7782);

-- 직원 중에 관리자와 부서번호가 (7698,30) 이거나, (7839,10)인 사람
-- mgr, deptno 컬럼을 동시에 만족시키는 직원정보 조회
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499,7782));

-- mgr, deptno 컬럼을 따로 만족시키는 직원정보 조회
-- 7698 30
-- 7839 10
-- (7698, 30), (7698, 10), (7839, 30), (7839,10)
-- (7698, 30) , ~
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499,7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN (7499,7782));

-- 아래와 위가 같다.
SELECT *
FROM emp
WHERE mgr IN (7698, 7839)
AND deptno IN (10, 30);            

-- SCALAR SUBQUERY : SELECT절에 등장하는 서브 쿼리(단 값이 하나의 행, 하나의 컬럼)
-- 직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT empno, ename, deptno, '부서명' dname -- ?? 이해 필요
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;

SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;

-- Q. 서브쿼리 (실습 sub4) 246p
-- dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음
-- 직원이 속하지 않은 부서를 조회하는 쿼리를 작성하세요.

-- 전체 조회
SELECT *
FROM dept;

-- 데이터 생성
INSERT INTO dept VALUES (99,'ddit', 'daejeon');
COMMIT;

-- 내 풀이
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     WHERE deptno IS NOT NULL);
                 
-- Q. 서브쿼리 (실습 sub5) 247p
-- cycle, product 테이블을 이용하여 cid=1인 고객이 애음하지 
-- 않는 제품을 조회하는 쿼리를 작성하세요.

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);

-- Q. 서브쿼리 (실습 sub6) 248p
-- cycle 테이블을 이용하여 cid=2인 고객이 애음하는 제품 중
-- cid=1인 고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요.

SELECT *
FROM cycle
WHERE pid IN (SELECT pid
              FROM cycle
              WHERE cid =  2)
  AND cid = 1;
  
------------------------------------------------------------------------------------------------------------------------------------------------------ 
-- 과제  
-- Q. 서브쿼리 (실습 sub7) 249p
-- cycle, product 테이블을 이용하여 cid=2인 고객이 애음하는 제품 중
-- cid=1인 고객도 애음하는 제품의 애음정보를 조회하고 고객명과 제품명까지 포함하는 쿼리를 작성하세요.  

-- scalar subquery
SELECT cid, (select cnm from customer where cid = cycle.cid) cnm, pid, (select pnm from product where pid = cycle.pid) pnm, day, cnt
FROM cycle
WHERE pid IN (SELECT pid
              FROM cycle
              WHERE cid =  2)
  AND cid = 1;
-- join 
SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM cycle, customer, product
WHERE cycle.pid IN (SELECT pid
              FROM cycle
              WHERE cid =  2)
  AND cycle.cid = 1
  AND cycle.cid = customer.cid
  AND cycle.pid = product.pid;
------------------------------------------------------------------------------------------------------------------------------------------------------

-- EXISTS : MAIN 쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
-- 만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에
-- 성능면에서 유리

-- MGR가 존재하는 직원 조회 -- 이해 필요
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'f'
              FROM emp
              WHERE empno = a.mgr);
              
-- MGR가 존재하지 않는 직원 조회
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X' 
              FROM emp
              WHERE empno = a.mgr);
                 
-- Q. 서브쿼리 (EXISTS연산자 - 실습 sub8) 251p
-- 아래 쿼리를 subquery를 사용하지 않고 작성하세요.                   

-- MGR가 존재하는 직원 조회 ( 못풀음)
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- 부서에 소속된 직원이 있는 부서 정보 조회(EXISTS)

-- 이렇게 나와야함
SELECT *
FROM dept
WHERE deptno IN (10, 20, 30);

-- 내 풀이, 쌤 풀이
SELECT *
FROM dept
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE deptno = dept.deptno);

-- IN으로 변경해보자
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                 FROM emp);                 
                 
------------------------------------------------------------------------------------------------------------------------------------------------------                 
-- 과제
-- Q. 서브쿼리 (EXISTS연산자 - 실습 sub9) 252p
-- cycle, product 테이블을 이용하여 cid=1인 고객이 애음하지 않는 제품을
-- 조회하는 쿼리를 EXISTS 연산자를 이용하여 작성하세요.

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);

SELECT *
FROM product
WHERE NOT EXISTS(SELECT 'X'
                  FROM cycle
                  WHERE cid = 1
                  AND pid = product.pid);
------------------------------------------------------------------------------------------------------------------------------------------------------
                  
-- 집합연산
-- << UNION >>      : 쿼리 두개를 합침. 합집함, 중복을 제거
--                  DBMS에서는 중복을 제거하기 위해 데이터를 정렬
--                  (대량의 데이터에 대해 정렬시 부하)
-- << UNION ALL >>  : UNION과 같은 개념
--                  중복을 제거하지 않고, 위 아래 집합을 결합 --> 중복 가능
--                  위아래 집합에 중복되는 데이터가 없다는 것을 확신하면
--                  UNION 연산자보다 성능면에서 유리
-- 사번이 7566 또는 7698인 사원 조회 (사번이랑, 이름)

-- UNION 
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION

-- 사번이 7369 또는 7499인 사원 조회 (사번이랑, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;

-- UNION ALL 

-- 사번이 7566 또는 7698인 사원 조회 (사번이랑, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;

-- INTERSECT(교집합 : 위 아래 집합간 공통 데이터)
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7499);

-- MINUS(차집합 : 위 집합에서 아래 집합을 제거)
-- 순서가 존재
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7499);




SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'PC25'
AND TABLE_NAME IN ('PROD','LPROD')
AND CONSTRAINT_TYPE IN ('P','R');
















                 
                 