SELECT *
FROM dept_test;

-- pl/sql (procedure 생성 실습 PRO_3) 18p
-- Q. 실습 PRO_3
-- UPDATEdept_test procedure 생성
-- param : deptno, dname, loc
-- logic : 입력받은 부서 정보를 dept_test 테이블에 정보 수정
-- exec registdept_test('99', 'ddit', 'daejeon');
-- dept_test테이블에 정상적으로 갱신 되었는지 확인

CREATE OR REPLACE PROCEDURE UPDATEdept_test(p_deptno IN dept_test.deptno%TYPE,
                                            p_dname IN dept_test.dname%TYPE,
                                            p_loc IN dept_test.loc%TYPE)
IS
BEGIN
    UPDATE dept_test 
    SET dname = p_dname
    WHERE deptno = p_deptno;    
    
    commit;
END;
/
exec UPDATEdept_test('99', 'ddit_m', 'daejeon');

SELECT *
FROM dept_test;

--------------------------------------------------------------------------------------------------

-- ROWTYPE : 테이블의 한 행의 데이터를 담을 수 있는 참조타입
set serveroutput on;

DECLARE
    dept_row dept%ROWTYPE; --dept의 컬럼 하나하나 설정하지 않고 dept테이블 자체를 넣음.
BEGIN 
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ', ' || 
                         dept_row.dname || ', ' || 
                         dept_row.loc);
END;
/

--------------------------------------------------------------------------------------------------

-- 복합변수 : record
DECLARE
    -- UserVo userVo;
    TYPE dept_row IS RECORD (   -- dept_row는 UserVo 같은 타입? 클래스 같은 것.
        deptno NUMBER(2), -- 이렇게 해도
        dname dept.dname%TYPE -- 이렇게 해도 된다.    
    );
    
    v_row dept_row;
    v_name dept.dname%Type; -- 위에도 이거랑 동일한테 타입이 다른것
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(v_row.deptno || ', ' || v_row.dname);
END;
/

--------------------------------------------------------------------------------------------------

-- 복합변수 : tabletype

DECLARE
    -- TYPE을 새로 선언하는 것 
    -- DEPT의 행을 나타내는 타입을 여러개 저장할 수 있는 테이블 타입
    -- INDEX BY BINARY_INTEGER 인덱스에 대한 타입을 말하는 것. BINARY_INTEGER는 PL/SQL에 있는 타입 
    -- 테이블 타입 선언할 때 이렇게 해주면됨
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    -- java : 타입 변수명;
    -- pl/sql : 변수명 타입;
    v_dept dept_tab;
    
    bi BINARY_INTEGER;
    
BEGIN

    bi := 100;
    
    SELECT *
    BULK COLLECT INTO v_dept    --  BULK COLLECT INTO는 전체 select할 때(?)
    FROM dept;
    
  --dbms_output.put_line(v_dept(0).dname);
    dbms_output.put_line(bi);
    dbms_output.put_line(v_dept(1).dname);
    dbms_output.put_line(v_dept(2).dname);
    dbms_output.put_line(v_dept(3).dname);
    dbms_output.put_line(v_dept(4).dname);
    dbms_output.put_line(v_dept(5).dname);
    
END;
/

SELECT *
FROM dept;

--------------------------------------------------------------------------------------------------

-- IF
--    ELSE IF --> ELSIF
-- END IF;

DECLARE
    ind BINARY_INTEGER;
BEGIN
    ind := 2; -- 값 할당
    
    IF ind = 1 THEN
        dbms_output.put_line(ind);
    ELSIF ind = 2 THEN   
        dbms_output.put_line('ELSEIF ' || ind );
    ELSE
        dbms_output.put_line('ELSE');
    END IF;    
END;
/

--------------------------------------------------------------------------------------------------

-- FOR LOOP :
-- FOR 인덱스 변수 IN 시작값.. 종료값 LOOP
-- END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_line('i : ' || i);
    END LOOP;
END;
/



-- 복합변수 : tabletype에 loop 적용하기

DECLARE

    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    v_dept dept_tab;
    
    bi BINARY_INTEGER;
    
BEGIN

    bi := 100;
    
    SELECT *
    BULK COLLECT INTO v_dept   
    FROM dept;
    

    dbms_output.put_line(bi);
    
    FOR i IN 1..v_dept.count LOOP
        dbms_output.put_line(v_dept(i).dname);
    END LOOP;
    
END;
/
--------------------------------------------------------------------------------------------------

-- LOOP : 계속 실행 판단 로직을 LOOP 안에서 제어
-- Java : while(true)와 비슷

DECLARE
    i NUMBER;
BEGIN
    i := 0; -- 초기화
    
    LOOP
        dbms_output.put_line(i);
        i := i + 1;
        -- loop 계속 진행 여부 판단
        EXIT WHEN i >= 5;
    END LOOP;    
END;
/

--------------------------------------------------------------------------------------------------

-- dt.sql
-- 오늘 날짜 기준 5일 데이터 table 만들기

 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;

-- pl/sql (cursor 로직제어 실습 PRO_3) 40p
-- Q. 실습 PRO_3
-- dt.sql 파일을 통해 테이블과 데이터를 생성하고, 다음과 같은
-- 날짜 간격사이의 평균을 구하는 프로시저 생성
-- exec avgdt

-- 간격 평균 : 5 일

-- 승희가 도와준 것
DECLARE
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    
    dt_table dt_tab;
    dd NUMBER;
    sumdd NUMBER;
    t number;
BEGIN
    sumdd := 0;
    t := 0;

    SELECT *
    BULK COLLECT INTO dt_table   
    FROM dt;
    
    FOR i IN 1..dt_table.count-1 LOOP
        dbms_output.put_line(dt_table(i).dt);
        dd := dt_table(i).dt - dt_table(i+1).dt; 
        dbms_output.put_line(dd);
        sumdd := dd + sumdd; 
        dbms_output.put_line(sumdd);
    END LOOP;

    dbms_output.put_line('간격 평균 : ' || sumdd / (dt_table.count-1));      
END;
/

-- 쌤 풀이
DECLARE
    TYPE d_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    
    d_table d_tab;

    diff_sum NUMBER;

BEGIN
    diff_sum := 0;

    SELECT *
    BULK COLLECT INTO d_table   
    FROM dt
    ORDER BY dt;
    
    FOR i IN 1..d_table.count LOOP
        IF i != 1 THEN
            dbms_output.put_line(d_table(i).dt - d_table(i-1).dt);
            diff_sum := diff_sum + (d_table(i).dt - d_table(i-1).dt); 
        END IF;
    END LOOP;

    dbms_output.put_line('diff_sum : ' || diff_sum);   
    dbms_output.put_line('간격 평균 : ' || (diff_sum / (d_table.count-1)));      
END;
/
--------------------------------------------------------------------------------------------------
-- ++  이어서
-- lead, lag 현재행의 이전, 이후 데이터를 가져올 수 있다.

SELECT *
FROM dt
ORDER BY dt desc;

-- 분석함수로 구하기
SELECT AVG(diff)
FROM
    (SELECT dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
    FROM dt);
    
-- 분석함수를 사용하지 못하는 환경에서 구하기
SELECT ROWNUM RN, dt
FROM
    (SELECT dt
    FROM dt
    ORDER BY dt DESC);
    
-- 내가 시도한 풀이    
SELECT *
FROM
    (SELECT ROWNUM RN, dt
    FROM
        (SELECT dt
        FROM dt
        ORDER BY dt DESC)a,
        (SELECT dt
        FROM dt
        ORDER BY dt DESC)b)
WHERE a.rn = b.rn-1    ;


-- 쌤 답
SELECT AVG(a.dt - b.dt)
FROM
(SELECT ROWNUM RN, dt
FROM
    (SELECT dt
    FROM dt
    ORDER BY dt DESC)) a,
(SELECT ROWNUM RN, dt
FROM
    (SELECT dt
    FROM dt
    ORDER BY dt DESC)) b    
WHERE a.rn = b.rn(+) -1;

-- 동규 풀이
-- HALL OF HONOR
SELECT (MAX(dt)-MIN(dt)) / (COUNT(*)-1)
FROM dt;

--------------------------------------------------------------------------------------------------

-- cursor
-- 테이블 타입 없이 sql 그대로 작업함.

DECLARE
    -- 커서 선언
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
    
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    -- 커서 열기
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; -- 더이상 읽은 데이터가 없을 때 종료
    END LOOP;
END;
/

-- FOR LOOP CURSOR 결합

DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
--    v_deptno dept.deptno%TYPE;    
--    v_dname dept.dname%TYPE;
BEGIN
    FOR rec IN dept_cursor LOOP
        dbms_output.put_line(rec.deptno || ', ' ||  rec.dname);
    END LOOP;
END;
/

-- 파라미터가 있는 명시적 커서

DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job
        FROM emp
        WHERE job = p_job;
        
--    v_empno emp.empno%TYPE;    
--    v_ename emp.ename%TYPE;
--    v_job emp.job%TYPE;
BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP -- 여기서 emp는 레코드명임.
        dbms_output.put_line(emp.empno || ', ' ||  emp.ename || ', ' || emp.job);
    END LOOP;
END;
/















