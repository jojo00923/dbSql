-- 어제 햄버거지수 문제 

-- 대전지역 
-- 버거킹, 맥도날드, KFC
SELECT gb, sido, sigungu
FROM fastfood
WHERE sido LIKE '대전광역시'
AND gb IN ('버거킹', '맥도날드', 'KFC')
ORDER BY sido, sigungu, gb;

SELECT gb, sido, sigungu
FROM fastfood
WHERE sido LIKE '대전광역시'
AND gb IN ('롯데리아')
ORDER BY sido, sigungu, gb;

-- 전국 시도, 시군구별 롯데리아 건수 (144건)
SELECT sido, sigungu, count(*) cnt
FROM fastfood
WHERE gb IN ('버거킹', '맥도날드', 'KFC')
GROUP BY sido, sigungu;
ORDER BY sido, sigungu, gb;

-- 전국 시도, 시군구별 롯데리아 건수 (188건)
SELECT sido, sigungu, count(*) cnt
FROM fastfood
WHERE gb IN ('롯데리아')
GROUP BY sido, sigungu;
ORDER BY sido, sigungu, gb;


-- 답
SELECT a.sido, a.sigungu, a.cnt, b.cnt, round(a.cnt/b.cnt, 1) point
FROM
(SELECT sido, sigungu, count(*) cnt
FROM fastfood
WHERE gb IN ('버거킹', '맥도날드', 'KFC')
GROUP BY sido, sigungu) a, 
(SELECT sido, sigungu, count(*) cnt
FROM fastfood
WHERE gb IN ('롯데리아')
GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY point desc ;

-------------------------------------------------------------------
-- rownum 사용 예제
SELECT a.empno, a.ename, a.rn, b.*
FROM
    (SELECT a.*, rownum rn
    FROM
    (SELECT emp.*
    FROM emp
    ORDER BY empno desc)a) a,
    
    (SELECT b.*, rownum rn
    FROM
    (SELECT dept.*
    FROM dept
    ORDER BY deptno DESC) b) b
WHERE a.rn = b.rn(+)
ORDER BY a.rn;
-------------------------------------------------------------------

SELECT sido, sigungu, sal, ROUND(sal/people, 2) point
FROM tax
ORDER BY sal desc; -- 연말정산 납입액 랭킹
--ORDER BY point desc; 

-- 버거지수 시도, 시군구 || 연말정산 시도 시군구
-- 시도, 시군구, 버거지수, 시도, 시군구, 연말정산납입액
-- 서울시 중구    5.7    경기도 수원시   18623591


SELECT a.*, b.*
FROM
    (SELECT a.*, rownum rn
    FROM
    (SELECT a.sido, a.sigungu, round(a.cnt/b.cnt, 1) point
    FROM
    (SELECT sido, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb IN ('버거킹', '맥도날드', 'KFC')
    GROUP BY sido, sigungu) a, 
    (SELECT sido, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb IN ('롯데리아')
    GROUP BY sido, sigungu) b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY point desc)a) a,
    
    (SELECT b.*, rownum rn
    FROM
    (SELECT sido, sigungu, sal, ROUND(sal/people, 2) point
    FROM tax
    ORDER BY sal desc) b) b
WHERE a.rn = b.rn;

-- 쌤 답 (도시발전지수 문제풀이) --
SELECT a.*, b.*
FROM 
    (SELECT a.*, ROWNUM RN 
     FROM
        (SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l,
               round(a.cnt/b.cnt, 2) point
        FROM 
            --140건
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM fastfood
            WHERE gb IN ('KFC', '버거킹', '맥도날드')
            GROUP BY SIDO, SIGUNGU) a,
            
            --188건
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM fastfood
            WHERE gb IN ('롯데리아')
            GROUP BY SIDO, SIGUNGU) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu
        ORDER BY point DESC )a ) a,
    
    (SELECT b.*, rownum rn
    FROM 
    (SELECT sido, sigungu
    FROM TAX
    ORDER BY sal DESC) b ) b
WHERE b.rn = a.rn(+)
ORDER BY b.rn;

---------------------------------------------------------
-- SQL 응용 PPT

DROP TABLE emp_test;

-- multiiple insert를 위한 테스트 테이블 생성
-- empno, ename 두 개의 컬럼을 갖는 emp_test, emp_test2 테이블을 
-- emp 테이블로부터 생성한다 (CTAS)
-- 데이터는 복제하지 않는다.

CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp
WHERE 1=2;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

-- INSERT ALL
-- 하나의 INSERT SQL 문장으로 여러 테이블에 데이터를 입력
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;

-- INSERT 데이터 확인
SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

-- INSERT ALL 컬럼 정의
ROLLBACK;

-- multiple insert (unconditional insert)
INSERT ALL
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL    
SELECT 2 empno, 'sally' ename FROM dual;    

-- multiple insert (conditional insert)
ROLLBACK;
INSERT ALL
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE    -- 조건을 통과하지 못할 때만 실행
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL    
SELECT 2 empno, 'sally' ename FROM dual;  

-- INSERT FIRST
-- 조건에 만족하는 첫번째 INSERT 구문만 실행
INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test (empno) VALUES (empno) -- 사원번호만 입력
    WHEN empno > 5 THEN   
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual;  

SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

-- << MERGE >>
-- 조건에 만족하는 데이터가 있으면 UPDATE
-- 조건에 만족하는 데이터가 없으면 INSERT

-- empno가 7369인 데이터를 emp 테이블로부터 emp_test테이블에  복사(insert)
INSERT INTO emp_test 
SELECT empno, ename
FROM emp
WHERE empno=7369;

SELECT *
FROM emp_test;

-- emp테이블에 데이터 중 emp_test 테이블의 empno와 같은 값을 갖는 데이터가 있을 경우
-- emp_test.ename = ename || '_merge' 값으로 update
-- 데이터가 없을 경우에는 emp_test테이블에 insert
ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));
-- TABLE
MERGE INTO emp_test
USING emp -- TABLE, VIEW, SUB_QUERY 올 수 있음
 ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);

-- VIEW    ~~~~~~~~~~~~~~~~~~~
MERGE INTO emp_test
USING 
(SELECT *
 FROM emp
 WHERE emp.empno IN(7369,7499)) emp
 ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);
    

-- 다른 테이블을 통하지 않고 테이블 자체의 데이터 존재 유무로
-- merge 하는 경우
ROLLBACK;

-- empno = 1, ename = 'brown'
-- empno가 같은 값이 있으면 ename을 'brown'으로 update
-- empno가 같은 값이 없으면 신규 insert

MERGE INTO emp_test
USING dual
 ON (emp_test.empno = 1) -- empno가 1인 데이터
WHEN MATCHED THEN -- empno가 1인 데이터가 있는 경우
    UPDATE SET ename = 'brown'  || '_merge' -- on절에서 사용된 컬럼은 업데이트 안됨
WHEN NOT MATCHED THEN    -- empno가 1인 데이터가 없는 경우
    INSERT VALUES (1, 'brown');

SELECT *
FROM emp_test;    

-- MERGE를 안쓸 경우 다음과 같이 세개의 쿼리를 써야한다.
SELECT 'X'
FROM emp_test
WHERE empno = 1;

UPDATE emp_test SET ename = 'brown' || '_merge'
WHERE empno = 1;

INSERT INTO emp_test VALUES (1, 'brown');

-- report group function ppt 17p
-- Q. 그룹별 합계, 전체 합계를 다음과 같이 구하려면? (실습 GROUP_AD1)
-- table : emp

-- 내가 풀던 것 (미완성)
SELECT deptno, sum(sal)
FROM emp 
WHERE deptno = deptno
GROUP BY deptno;

-- 쌤 답
-- 부서별 급여의 합
SELECT deptno, sum(sal)
FROM emp 
GROUP BY deptno

UNION ALL

-- 모든 직원의 급여의 합
SELECT null, sum(sal) sal
FROM emp ;

-- << rollup >>
-- group by의 서브 그룹을 생성
-- GROUP BY ROLLUP ( {col,})
-- 컬럼을 오른쪽에서부터 제거해가면서 나온 서브그루을
-- GROUP BY 하여 UNION한 것과 동일
-- ex : GROUP BY ROLLUP (job, deptno)
--      GROUP BY job, deptno
--      UNION
--      GROUP BY job
--      UNION
--      GROUP BY --> 총계 (모든 행에 대해 적용)

SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


-- 아래 쿼리를 rollup 형태로 변경

SELECT deptno, sum(sal)
FROM emp 
GROUP BY ROLLUP (deptno);

-- << GROUPING SETS >>
-- GROUPING SETS (col1, col2 ...)
-- grouping sets의 나열된 항목이 하나의 서브그룹으로 group by절에 이용된다.

-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2
-- 와 동일하다.

-- emp 테이블을 이용하여 부서별 급여합과, 담당업부(job)별 급여합을 구하시오.
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno;

SELECT job, SUM(sal)
FROM emp
GROUP BY job;

-- 부서번호, job, 급여합계
SELECT deptno, null job, SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, job, SUM(sal)
FROM emp
GROUP BY job;

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job);

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job, (deptno, job));

