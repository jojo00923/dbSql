SELECT *
FROM no_emp;

-- 1.leaf node 찾기
SELECT LPAD(' ', (LEVEL-1)*4, ' ') || org_cd, s_emp
FROM
    (SELECT org_cd, parent_org_cd, SUM(s_emp) s_emp
    FROM
        (SELECT org_cd, parent_org_cd,
               sum(no_emp/org_cnt) OVER (PARTITION BY gr ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
        FROM
            (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr ,COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
            FROM
                (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
                FROM no_emp
                START WITH parent_org_cd IS NULL
                CONNECT BY PRIOR org_cd = parent_org_cd) a
            START WITH leaf = 1
            CONNECT BY PRIOR parent_org_cd = org_cd))
        GROUP BY org_cd, parent_org_cd)
    START WITH parent_org_cd IS NULL
    CONNECT BY PRIOR org_cd = parent_org_cd;
    
-- 1단계
SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
FROM no_emp
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;
    
-- 2단계
SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr  ,COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt 
FROM
    (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
    FROM no_emp
    START WITH parent_org_cd IS NULL
    CONNECT BY PRIOR org_cd = parent_org_cd) a
START WITH leaf = 1
CONNECT BY PRIOR parent_org_cd = org_cd;

-- 3단계                 
SELECT org_cd, parent_org_cd,
       sum(no_emp/org_cnt) OVER (PARTITION BY gr ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
FROM
    (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr ,COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt 
    FROM
        (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
        FROM no_emp
        START WITH parent_org_cd IS NULL
        CONNECT BY PRIOR org_cd = parent_org_cd) a
    START WITH leaf = 1
    CONNECT BY PRIOR parent_org_cd = org_cd);
           
-- 4단계
SELECT org_cd, parent_org_cd, SUM(s_emp) s_emp -- SUM(s_emp) s_emp : org_cd와 parent_org_cd가 같은 것끼리 s_emp를 더해줌.
FROM
    (SELECT org_cd, parent_org_cd,
           sum(no_emp/org_cnt) OVER (PARTITION BY gr ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
    FROM
        (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr ,COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
        FROM
            (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
            FROM no_emp
            START WITH parent_org_cd IS NULL
            CONNECT BY PRIOR org_cd = parent_org_cd) a
        START WITH leaf = 1
        CONNECT BY PRIOR parent_org_cd = org_cd))
GROUP BY org_cd, parent_org_cd;
        
-- 최종
SELECT LPAD(' ', (LEVEL-1)*4, ' ') || org_cd, s_emp
FROM
    (SELECT org_cd, parent_org_cd, SUM(s_emp) s_emp
    FROM
        (SELECT org_cd, parent_org_cd,
               sum(no_emp/org_cnt) OVER (PARTITION BY gr ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
        FROM
            (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr ,COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
            FROM
                (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
                FROM no_emp
                START WITH parent_org_cd IS NULL
                CONNECT BY PRIOR org_cd = parent_org_cd) a
            START WITH leaf = 1
            CONNECT BY PRIOR parent_org_cd = org_cd))
    GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;

---------------------------------------------------------------------------------------------------------------------------------

-- << PL/SQL >>
-- 오라클에서 제공하는 프로그래밍 언어
-- 할당연산 :=
-- System.out.println(""); --> dbms_output.put_line('');
-- Log4j
-- set serveroutput ON : 화면 출력 기능을 활성화

-- PL/SQL 구조
-- declare : 변수, 상수 선언
-- begin : 로직 실행
-- exception : 예외처리
DESC dept;

set serveroutput on;

-- 1
DECLARE
    -- 변수 선언
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    dbms_output.put_line('test');
END;
/
-- 2
DECLARE
    -- 변수 선언
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname -- INTO :  값을 선언한 변수에 담을 때(한건일때만)
    FROM dept
    WHERE deptno = '10';
    
    -- SELECT절의 결과를 변수에 잘 할당했는지 확인
    dbms_output.put_line('dname : ' ||  dname || '(' || deptno || ')');
END;
/
-- 3 
DECLARE
    -- 변수 선언
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname -- 여러건일 땐 에러남
    FROM dept;
    
    -- SELECT절의 결과를 변수에 잘 할당했는지 확인
    dbms_output.put_line('dname : ' ||  dname || '(' || deptno || ')');
END;
/    
-- 4
DECLARE
    -- 참조 변수 선언 (테이블 컬럼타입이 변경되어도 pl/sql 구문을 수정할 필요가 없다.)
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname 
    FROM dept
    WHERE deptno = '10';
    
    -- SELECT절의 결과를 변수에 잘 할당했는지 확인
    dbms_output.put_line('dname : ' ||  dname || '(' || deptno || ')');
END;
/

-- 10번 부서의 부서이름과 LOC정보를 화면에 출력하는 프로시저
-- 프로시저명 : printdept
-- CREATE OR REPLACE VIEW

-- 프로시저 객체 생성
CREATE OR REPLACE PROCEDURE printdept 
IS
    -- 변수 선언
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc 
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line('dname, loc = ' || dname || ',' || loc);
END;
/

exec printdept;

-- 부서번호를 프로시저 인자로 받기
CREATE OR REPLACE PROCEDURE printdept_p(p_deptno IN dept.deptno%TYPE)
IS
    -- 변수 선언
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc 
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    dbms_output.put_line('dname, loc = ' || dname || ',' || loc);
END;
/
-- 실행
exec printdept_p(30);

-- pl/sql (procedure 생성 실습 PRO_1) 16p
-- Q. 실습 PRO_1
-- printemp procedure 생성
-- param : empno
-- logic : empno에 해당하는 사원의 정보를 조회하여
--         사원이름, 부서이름을 화면에 출력

CREATE OR REPLACE PROCEDURE printemp(empno_p IN emp.empno%TYPE)
IS
    -- 변수 선언
    ll emp.ename%TYPE; -- ll은 ename임
    dname dept.dname%TYPE;
BEGIN
    SELECT emp.ename, dept.dname
    INTO ll, dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno
    AND emp.empno = empno_p;
    
    dbms_output.put_line('ename = ' || ll || ', dname = ' || dname);
END;
/

exec printemp(7369);

---------------------------------------------------------------------------------------------------------------------------------

select *
from dept_test;

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

DELETE dept_test
WHERE deptno > 90;

-- pl/sql (procedure 생성 실습 PRO_2) 17p
-- Q. 실습 PRO_2
-- registdept_test procedure 생성
-- param : deptno, dname, loc
-- logic : 입력받은 부서 정보를 dept_test 테이블에 신규 입력
-- exec registdept_test('99', 'ddit', 'daejeon');
-- dept_test테이블에 정상적으로 입력 되었는지 확인

CREATE OR REPLACE PROCEDURE registdept_test(p_deptno IN dept_test.deptno%TYPE,
                                            p_dname IN dept_test.dname%TYPE,
                                            p_loc IN dept_test.loc%TYPE)
IS
    deptno dept_test.deptno%TYPE;
    dname dept_test.dname%TYPE;
    loc dept_test.loc%TYPE;
BEGIN
    INSERT INTO dept_test 
    VALUES (p_deptno, p_dname, p_loc)  ;
    
    dbms_output.put_line('deptno = ' || deptno || ', dname = ' || dname || ', loc = ' || loc);
    commit;
END;
/
exec registdept_test('99', 'ddit', 'daejeon');

SELECT *
FROM dept_test;












