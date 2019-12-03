-- 익명 블록
SET serveroutput on;

DECLARE
    -- 사원이름을 저장할 스칼라 변수(1개의 값)
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename        
    FROM emp;
    -- 조회결과는 여러건인데 스칼라 변수에 값을 저장하려고 한다.
    -- --> 에러
    
    -- 발생예외, 발생예외를 특정 짓기 힘들때 --> OTHERS (java : Exception)
    EXCEPTION
        WHEN others THEN
            dbms_output.put_line('Exception others');
END;
/

--------------------------------------------------------------------------------------------------

-- 사용자 정의 예의
DECLARE
    -- emp 테이블 조회시 결과가 없을 경우 발생시킬 사용자 정의 예외
    -- 예외명 EXCEPTION; -- 변수명 변수타입
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    
    BEGIN
        SELECT ename
        INTO v_ename
        FROM emp
        WHERE empno=9999;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                dbms_output.put_line('데이터 미존재');
                -- 사용자가 생성한 사용자 정의 예외를 생성
                RAISE NO_EMP;
    END;
    
    EXCEPTION
        WHEN NO_EMP THEN
            dbms_output.put_line('no_emp exception');
END;
/

--------------------------------------------------------------------------------------------------

-- 사원번호를 인자로 하고, 해당 사원번호에 해당하는 사원이름을 리턴하는 함수(function)
CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
RETURN VARCHAR2 
IS 
    -- 선언부
    ret_ename emp.ename%TYPE;
BEGIN
    -- 로직
    SELECT ename
    INTO ret_ename
    FROM emp
    WHERE empno = p_empno;

    RETURN ret_ename;
END;
/

SELECT getEmpName(7369)
FROM dual;

SELECT empno, ename, getEmpName(empno)
FROM emp;

--------------------------------------------------------------------------------------------------
-- pl/sql (function 실습 function1) 53p
-- Q. 실습 function1
-- 부서번호를 파라미터로 입력받고 해당 부서의 이름을
-- 리턴하는 함수 getdeptname을 작성해보세요.
CREATE OR REPLACE FUNCTION getDeptName(p_deptno dept.deptno%TYPE)
RETURN VARCHAR2
IS
    ret_dname dept.dname%TYPE;
BEGIN
    SELECT dname
    INTO ret_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN ret_dname;
END;    
/

SELECT getDeptName(10)
FROM dual;

SELECT deptno, dname, getDeptName(deptno)
FROM dept;

----------------------------------------------------
-- 조인하지 않고도 가져올 수 있다.
SELECT empno, ename, deptno, getdeptname(deptno)
FROM emp;

-- scalar 서브 쿼리로도 가능하죠, 안좋은 사례 --> 조인처리하는게 맞음
SELECT empno, ename, deptno, getdeptname(deptno),
    (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname,
    (SELECT loc FROM dept WHERE dept.deptno = emp.deptno) loc
FROM emp;


--------------------------------------------------------------------------------------------------
-- pl/sql (function 실습 function2) 54p
-- Q. 실습 function2
-- 계층쿼리시 많이 반복되던 로직을 이택릭체로 표현하였습니다.
-- 해당 부분을 indent라는 이름의 함수로 대체해보세요.
-- 인자와 리턴값을 각자 생각해보세요.
SELECT deptcd, LPAD(' ', (LEVEL-1)*4,' ') || deptnm deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

-- 풀이
CREATE OR REPLACE FUNCTION indent(p_level NUMBER, p_dname dept.dname%TYPE)
RETURN VARCHAR2
IS
    ret_text VARCHAR2(50);
BEGIN
    SELECT LPAD(' ', (p_level - 1)*4, ' ') || p_dname
    INTO ret_text
    FROM dual;
    
    RETURN ret_text;
END;    
/

SELECT indent(2, 'ACCOUNTING'), indent(3, 'SALES')
FROM dual;

-- 답
SELECT deptcd, indent(LEVEL, deptnm) as deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

---- 패키지......

-- 트리거
desc users;
CREATE TABLE user_history (
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE
);

-- users 테이블의 pass 컬럼이 변경될 경우
-- users_history에 변경전 pass를 이력으로 남기는 트리거
CREATE OR REPLACE TRIGGER make_history
    BEFORE UPDATE ON users -- users 테이블을 업데이트 전에
    FOR EACH ROW
    
    BEGIN 
        --: NEW.컬럼명 : UPDATE 쿼리시 작성한 값
        --: OLD.컬럼명 : 현재 테이블 값
        IF :NEW.pass != :OLD.pass THEN
            INSERT INTO user_history 
            VALUES (:OLD.userid, :OLD.pass, sysdate);
        END IF;
    END;
/

SELECT *
FROM users;

-- 브라운의 pass를 바꿔보자
UPDATE users SET pass = 'brownpass'
WHERE userid = 'brown';

-- 트리거에 작성한 로직대로 들어있는지 보자.
-- 변경되기 전 값이 들어있는 것을 볼 수 있다. 
SELECT *
FROM user_history;

-- where절 안넣으면 전체 건이 바뀌니 5건이 새로 들어간다.
UPDATE users SET pass = 'newpass';

-- 시퀀스 만들어보라고 하면???
-- 시퀀스 들어가서 함...
CREATE SEQUENCE SEQ_USERS  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;

-----
-- ibatis(2.X)





