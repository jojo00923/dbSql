-- ���� ��Ǭ ����

-- 2
-- Q. �޷� �����
SELECT MIN(DECODE(d, 1, dt)) SUN, MIN(DECODE(d, 2, dt)) MON, MIN(DECODE(d, 3, dt)) TUE,  
       MIN(DECODE(d, 4, dt)) WED, MIN(DECODE(d, 5, dt)) THU, MIN(DECODE(d, 6, dt)) FRI,  
       MIN(DECODE(d, 7, dt)) SAT  
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'd') d,
            TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) -
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'd') + 1 f_sun
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))
GROUP BY f_sun
ORDER BY f_sun;

-- 2-1
-- Q. ����(�ǽ� calendar2) 20P
-- �ش� ���� ��� ������ ���� ��¥�� ������ ���� ����ϵ��� ������ �ۼ��غ�����
SELECT MIN(DECODE(d, 1, dt)) SUN, MIN(DECODE(d, 2, dt)) MON, MIN(DECODE(d, 3, dt)) TUE,  
       MIN(DECODE(d, 4, dt)) WED, MIN(DECODE(d, 5, dt)) THU, MIN(DECODE(d, 6, dt)) FRI,  
       MIN(DECODE(d, 7, dt)) SAT  
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') - TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM'), 'D') + 1 + (LEVEL-1) dt,
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') - TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM'), 'D') + 1 + (LEVEL-1), 'd') d,
            TO_DATE(:YYYYMM, 'YYYYMM') - TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM'), 'D') + 1 + (LEVEL-1) -
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') - TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM'), 'D') + 1 + (LEVEL-1), 'd') + 1 f_sun
    FROM dual
    CONNECT BY LEVEL <= LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')) + (7-TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'D')) + 1 -
    (TO_DATE(:YYYYMM, 'YYYYMM') - TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM'), 'D') + 1))
GROUP BY f_sun
ORDER BY f_sun;

-- Q. �������� (�ǽ� h_2)
-- �����ý��ۺ� ������ �μ����� ������ ��ȸ�ϴ� ������ �ۼ��ϼ���. 73p

-- ���� h_2
-- �����ý��ۺ� ������ ���� �������� ��ȸ(dept0_02)
SELECT dept_h.*, level lv, deptcd, LPAD(' ', (4*level-1), ' ') || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;  -- PRIOR�� ���� ���� ���� �����͸� �ǹ���.  =�� �������� ��ġ�� �ٲ㵵 ������. CONNECT BY deptcd = PRIOR p_deptcd
-----------------------------------------------------------------------------------------

-- ����� ��������
-- Ư�� ���κ��� �ڽ��� �θ��带 Ž��(Ʈ�� ��ü Ž���� �ƴϴ�)
-- ���������� �������� ���� �μ��� ��ȸ
-- �������� dept0_00_0

SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

---***********************************************************************����� �������� ����
-----------------------------------------------------------------------------------------
-- h_sum ���̺� ����
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

-- Q. �������� (�ǽ� h_4)  sql���� ppt 79p
-- ���������� ����.sql�� �̿��Ͽ� ���̺��� �����ϰ� ������ ���� �����
-- �������� ������ �ۼ��Ͻÿ�.
-- s_id : ��� ���̵�
-- ps_id : �θ� ��� ���̵�
-- value : ��� ��

--h_4 : ����� ����
select *
from h_sum;
SELECT LPAD(' ',4*(level-1),' ') || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

-----------------------------------------------------------------------------------------

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

-- Q. �������� �ǽ� h_5
/*
    ���������� ��ũ��Ʈ.sql�� �̿��Ͽ� ���̺��� �����ϰ� ����������
    ����� �������� ������ �ۼ� �Ͻÿ�.
    org_cd  : �μ��ڵ�
    parent_org_cd : �θ� �μ��ڵ�
    no_emp : �μ� �ο���
    */
SELECT *
FROM no_emp;
SELECT level, LPAD(' ',4*(level-1),' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-----------------------------------------------------------------------------------------
-- pruning branch (����ġ��)
-- ������������ (WHERE)���� START WITH, CONNECT BY���� ���� ����� ���Ŀ� ����ȴ�.

-- dept_h ���̺��� �ֻ��� ������ ��������� ��ȸ
SELECT deptcd, LPAD(' ', (4*level-1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- ���������� �ϼ��� ���� WHERE���� ����ȴ�.
-- ������ȹ�� �����Ǿ �������� ��ȹ���� �����κ� �Ʒ��� �ִ°�ó�� ���δ�.
SELECT deptcd, LPAD(' ', (4*level-1), ' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- ������ȹ�� �ؿ� �ִ� ���� ��ȹ�ε� ���� ����
SELECT deptcd, LPAD(' ', (4*level-1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
             AND deptnm != '������ȹ��';
-----------------------------------------------------------------------------------------
-- 83p
-- SYS_CONNECT_BY_PATH(�÷���, '-') : �ش�αװ� � ���� �����͸� Ÿ�� �Դ��� �� �� ����. (�����ڸ� ���ʿ� �־���)
SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       SYS_CONNECT_BY_PATH(org_cd, '-') path_org_cd
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') : ltrim �Լ��� �ϸ� ���ʺ��� -�� �����
SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path_org_cd,
       CONNECT_BY_ISLEAF isleaf
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- ����
-- CONNECT_BY_ROOT(col) : col�� �ֻ��� ��Ʈ �÷� ��
-- SYS_CONNECT_BY_PATH(col, ������) : col�� �������� ������ �����ڷ� ���� ���
--      . LTRIM�� ���� �ֻ��� ��� ������ �����ڸ� �����ִ� ���°� �Ϲ���
-- CONNECT_BY_ISLEAF : �ش� row�� leaf node���� �Ǻ� (1: O, 0 : X)

-----------------------------------------------------------------------------------------
-- 86p
-- �Խñ� ���������� ���� �ڷ�
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

SELECT *
FROM board_test;

-- Q. �������� (�Խñ� ���������� ���� �ڷ�.sql, �ǽ� h6) 86p
-- �Խñ��� �����ϴ� board_test ���̺��� �̿��Ͽ� ���� ������ �ۼ��Ͻÿ�.
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL   
CONNECT BY PRIOR seq = parent_seq;

-- Q. �������� (�Խñ� ���������� ���� �ڷ�.sql, �ǽ� h7) 87p
-- �Խñ��� ���� �ֽű��� �ֻ����� �´�. ���� �ֽű��� ������ �����Ͻÿ�.
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL   
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq desc;

-- Q. �������� (�Խñ� ���������� ���� �ڷ�.sql, �ǽ� h9) 94p
-- �Ϲ����� �Խ����� ���� �ֻ������� �ֽű��� ���� ����, ����� ��� �ۼ��� ������� ������ �ȴ�.
-- ��� �ϸ� �ֻ������� �ֽű� ��(desc)���� �����ϰ�, ����� ������(asc)���� ������ �� ������?

-- ���� �õ��� ��
SELECT seq, parent_seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL   
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY DECODE(parent_seq, null, seq desc, seq);

SELECT seq, parent_seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL   
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY DECODE(parent_seq, null, seq || 'desc', seq);

-- �̽���� Ǯ��
SELECT seq, parent_seq, LPAD(' ', 4*(level-1), ' ') || title title,
       CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END o1,
       CASE WHEN parent_seq IS NOT NULL THEN seq ELSE 0 END o2
FROM board_test
START WITH parent_seq IS NULL   
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END DESC, seq;

--�� Ǯ�� 1 :  CONNECT_BY_ROOT�� �̿��ؼ� 1�� 1�� ���� ����� �ֻ����� 1��, ...2��, 4�� ��.�ζ��κ並 �̿��� order by ����.
SELECT *
FROM
    (SELECT seq, parent_seq, LPAD(' ', 4*(level-1), ' ') || title title,
           CONNECT_BY_ROOT(seq) r_seq
    FROM board_test
    START WITH parent_seq IS NULL   
    CONNECT BY PRIOR seq = parent_seq)
ORDER BY r_seq DESC, seq;

-- �� Ǯ�� 2 : �÷� �ϳ��� �߰��ؼ� 1�� ���� ����� 1, 2�� ���� ����� 2, 4�� ���� ����� 4�� �Է��� �� orderby����)
SELECT *
FROM board_test;
-- �� �׷��ȣ �÷� �߰�
ALTER TABLE board_test ADD (gn NUMBER);

SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;

----------------------------------------------------------------------------------------- 
-- Q. 5000 ���� 3000, 3000 ���� 3000, 3000 ���� 2975... 800 ���� NULL
SELECT a.ename, a.sal, b.sal
FROM
(SELECT ename, sal, ROWNUM rn
FROM
    (SELECT ename, sal
    FROM emp
    ORDER BY sal DESC))a
    
    LEFT OUTER JOIN 
    
    (SELECT ename, sal, ROWNUM-1 rn
     FROM
        (SELECT ename, sal
        FROM emp
        ORDER BY sal DESC))b
ON (a.rn = b.rn);

