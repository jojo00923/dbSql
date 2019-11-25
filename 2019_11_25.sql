-- 평가 문제 --
-- member 테이블을 이용하여 member2 테이블을 생성
-- member2 테이블에서
-- 김은대 회원(mem_id='a001')의 직업(mem_job)을 '군인'으로 변경 후
-- commit하고 조회

SELECT *
FROM member;

CREATE TABLE member2 AS
SELECT *
FROM member;

SELECT *
FROM member2;

UPDATE member2 SET mem_job = '군인'
WHERE mem_id = 'a001';
commit;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id = 'a001';

-- 제품별 제품 구매 수량(buy_qty) 합계, 제품 구매 금액(buy_cost) 합계
-- 제품코드, 제품명, 수량합계, 금액합계

SELECT *
FROM prod;
SELECT *
FROM buyprod;

SELECT buy_prod, SUM(buy_qty), SUM(buy_cost)
FROM buyprod
GROUP BY buy_prod
ORDER BY buy_prod;

-- 내가 푼 것
SELECT buy_prod, prod.prod_name, SUM(buy_qty), SUM(buy_cost)
FROM buyprod, prod
WHERE buyprod.buy_prod = prod.prod_id
GROUP BY buy_prod, prod_name
ORDER BY buy_prod;

-- 쌤 답
SELECT buy_prod, b.prod_name, sum_qty, sum_cost
FROM 
(SELECT buy_prod, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
FROM buyprod
GROUP BY buy_prod)a, prod b 
WHERE a.buy_prod = b.prod_id;

-- VW_PROD_BUY(view 생성)
CREATE VIEW VW_PROD_BUY AS  -- CREATE OR REPLACE VIEW VW_PROD_BUY AS
SELECT buy_prod, prod.prod_name, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost 
FROM buyprod, prod
WHERE buyprod.buy_prod = prod.prod_id
GROUP BY buy_prod, prod_name
ORDER BY buy_prod;

-- 생성되어있는 뷰 확인
SELECT *
FROM USER_VIEWS;

---------------------------------------------------------------------

-- 분석함수 / window 함수 (도전해보기 실습 ana0)
-- 사원의 부서별 급여(sal)별 순위 구하기
-- emp 테이블 사용

-- 내가 시도 중
SELECT *
FROM emp;


SELECT a.ename, a.sal, a.deptno
FROM
(SELECT ename, sal, deptno
FROM emp
GROUP BY ename, sal, deptno)a
ORDER BY deptno;

SELECT b.*
FROM
(SELECT COUNT(*) cnt
FROM emp
GROUP BY deptno)b;


SELECT a.ename, a.sal, a.deptno, (SELECT COUNT(*) cnt
                                    FROM emp
                                    WHERE a.deptno = deptno
                                    GROUP BY deptno) rank
FROM
(SELECT ename, sal, deptno
FROM emp
GROUP BY ename, sal, deptno)a
ORDER BY deptno;


--- 쌤 답

-- 부서별 랭킹
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
    FROM
    (SELECT ename, sal, deptno
    FROM emp
    ORDER BY deptno, sal desc)a)a,

(SELECT b.rn, ROWNUM j_rn
FROM
(SELECT a.deptno, b.rn
FROM
    (SELECT deptno, COUNT(*) cnt -- 3, 5, 6
    FROM emp
    GROUP BY deptno)a,
    (SELECT ROWNUM rn -- 1~14
    FROM emp) b
WHERE a.cnt >= b.rn
ORDER BY a.deptno, b.rn)b)b
WHERE a.j_rn = b.j_rn;

--부서별 랭킹
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
     FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) a ) a, 
(SELECT b.rn, ROWNUM j_rn
FROM 
(SELECT a.deptno, b.rn 
 FROM
    (SELECT deptno, COUNT(*) cnt --3, 5, 6
     FROM emp
     GROUP BY deptno )a,
    (SELECT ROWNUM rn --1~14
     FROM emp) b
WHERE  a.cnt >= b.rn
ORDER BY a.deptno, b.rn ) b ) b
WHERE a.j_rn = b.j_rn;

-- 분석함수를 사용한 답
SELECT ename, sal, deptno, 
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;       
       