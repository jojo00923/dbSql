-- SELECT : ��ȸ�� �÷��� ���
--        - ��ü �÷� ��ȸ : *
--        - �Ϻ� �÷� : �ش� �÷��� ���� (,����)
-- FROM : ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� ��� ����.
-- �� keyword�� �ٿ��� �ۼ�

-- ��� �÷��� ��ȸ
SELECT * FROM prod;

-- Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name 
FROM prod;

-- 1) lprod ���̺��� ��� �÷� ��ȸ

-- 2) buyer ���̺��� buyer_id, buyer_name �÷��� ��ȸ

-- 3) cart ���̺��� ��� �����͸� ��ȸ

-- 4) member ���̺��� mem_id, mem_pass, mem_name �÷��� ��ȸ


-- ������ / ��¥����
-- date type + ���� : ���ڸ� ���Ѵ�.
-- null�� ������ ������ ����� �׻� null�̴�.
SELECT userid, usernm, reg_dt, 
       reg_dt + 5 reg_dt_after5, 
       reg_dt - 5 as reg_dt_before5 --alias(��Ī)�� ������ �ż� �÷����� �ٲ�.
FROM users;

commit; --Ʈ������� ������ ���� �ܰ�

-- 1) prod ���̺��� prod_id, prod_name �� �÷��� ��ȸ (id, name���� ��Ī ����)

-- 2) lprod ���̺��� lprod_gu, lprod_nm �� �÷��� ��ȸ (gu, nm���� ��Ī ����)

-- 3) buyer ���̺��� buyer_id, buyer_name �� �÷��� ��ȸ(���̾���̵�, �̸����� ��Ī ����)


-- ���ڿ� ����
-- java + --> sql ||
-- CONCAT(str, str) �Լ�
-- users���̺��� userid, usernm
SELECT  userid, usernm,
        userid || usernm,
        CONCAT(userid, usernm)     
FROM users;

-- ���ڿ� ��� (�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ' || userid,
        CONCAT('����� ���̵� : ' , userid)
FROM users;

-- �ǽ� sel_con1)
-- ���� ������ ����ڰ� ������ ���̺� ����� ��ȸ

-- ���ڿ� ������ �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ���� �ۼ�


-- desc table : �ش����̺� ���� ������ ������ �˷���.
-- ���̺� ���ǵ� �÷��� �˰� ���� ��
-- 1. desc ���̺��
-- 2. select * from ���̺��
desc emp; 

SELECT *
FROM emp;

-- WHERE��, ���� ������
SELECT *
FROM users
WHERE userid = 'brown';

-- usernm�� ������ �����͸� ��ȸ�ϴ� ������ �ۼ�
