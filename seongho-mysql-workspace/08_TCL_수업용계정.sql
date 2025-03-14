/*
트랜잭션
데이터베이스의 논리적인 연산단위 (업무단위)
즉, 한 번에 수행되어야 할 최소의 작업 단위
트랜잭션 ACID 원치익
    Atomicity(원자성)
        트랜잭션과 관련된 일은 모두 실행하거나 모두 실행되지 않도록 하는 특성
    Consistency(일관성)
        트랜잭션이 성공했다면 데이터베이스는 그 을관성을 유지해야됨
    Isolation(독립성)
        트랜잭션을 수행하는 도중에 다른 연산작업이 끼어들면 안 됨
    Durability (지속성)
        트랜잭션이 성공적으로 수행됐을경우 결과가 완전히 db에 반영 돼야한다
ex( 계좌이체


===
TCL
1. Transaction Control Language
2. 트랜잭션 제어어
3. 트랜잭션 대상 구문 : DML (INSERT, UPDATE, ELELTE)
4. 종류
    COMMIT : 트랜잭션에 포함되어있는 변경사항들을 영구적으로 저장( ㄹㅇdb에 반영
    ROLLBACK : 트랜잭션에 포함되어있는 변경사항들을 일괄 취소시킨 후 마지막 COMMIT시점으로 돌아감
    SAVEPOINT <savepoint명> : 임시저장점 설저엉
    ROLLBACK TO <savepoint 명>
*/
SHOW VARIABLES LIKE 'autocommit';
SET autocommit = 0;


-- 계좌 테이블 생서엉 (ssg_bank
-- id int pk
-- name varchar100 필수
-- balance, BIGINT , 양수만 , 필수
CREATE TABLE ssg_bank(
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    balance BIGINT NOT NULL CHECK(balance >=0)
    );
    
INSERT INTO
        ssg_bank
VALUES
        (1231, 'ksg',1000000),
        (456, 'asg',1000000);
COMMIT;
SELECT *FROM ssg_bank;
-- 10만원 보내기
UPDATE ssg_bank SET balance = balance -100000 WHERE id = 1231;
UPDATE ssg_bank SET balance = balance +100000 WHERE id = 456;
COMMIT;

-- 작어업2 말순씨가 길동씨한테 오십만 이체
UPDATE ssg_bank SET balance = balance +5000 WHERE id = 1231;
UPDATE ssg_bank SET balance = balance -500000 WHERE id = 456;
ROLLBACK;


-- ===================================================
use menudb;

DESC tbl_order;         -- 주문 테이블           1(부모)
DESC tbl_order_menu;    -- 주문 메뉴 테이블 N(자시익)

INSERT INTO tbl_order VALUES(1234, DATE_FORMAT(CURDATE(), '%y/%m/%d'), DATE_FORMAT(CURTIME(),'%H:%i:%s'), 14000);
INSERT INTO tbl_order_menu
VALUES(1234, 1, 2);
INSERT INTO tbl_order_menu
VALUES(1234,2,1);

SELECT *FROM tbl_order;
SELECT *FROM tbl_order_menu;
COMMIT;

INSERT INTO tbl_order VALUES(4567, DATE_FORMAT(CURDATE(), '%y/%m/%d'), DATE_FORMAT(CURTIME(),'%H:%i:%s'), 25000);
INSERT INTO tbl_order_menu
VALUES(4567,15,1);
ROLLBACK;

-- 작업 3 3번 1개 4번 1개 총가격13000
INSERT INTO tbl_order VALUES(3333, DATE_FORMAT(CURDATE(), '%y/%m/%d'), DATE_FORMAT(CURTIME(),'%H:%i:%s'), 13000);
SAVEPOINT finish_insert_order;
INSERT INTO tbl_order_menu
VALUES(3333,3,1);
INSERT INTO tbl_order_menu
VALUES(3333,4,10);
ROLLBACK TO finish_insert_order;

SELECT *FROM tbl_order;
SELECT *FROM tbl_order_menu;