/*
## DML
*/
/*
INSERT
1. 새로운 행을 추가하는 구문
2.테이블의 행 수가 증가됨
3. 문법
ㄴ 1) INSERT INTO 테이블명 VALUES(입력값1,입력값2...)
    ㄴ 테이블 컬럼 순번대로 값을 전달해야 됨
    2) INSERT INTO 테이블명(컬럼1, 컬럼2,...)VALUES(입력값1,입력값2,..)
    ㄴ지정한 컬럼 순번대로 값을 전달해야됨
        ㄴ지정안된 컬럼에는 Default값이 설정되어있을 경우 Default값이 들어감
                                                                        아닐경우 NULL이 들어감
    3)
*/
SELECT * FROM tbl_menu;

DESC tbl_menu;

INSERT INTO tbl_menu VALUES(23, '바나나맛해장국',8500,4,'y');
INSERT INTO tbl_menu VALUES(24, '미역맛초콜릿',18500);
INSERT INTO tbl_menu VALUES(24, '미역맛초콜릿',18500, 4, 'Y', 'test');

INSERT INTO tbl_menu(menu_name, menu_price,category_code,orderable_status) 
VALUES('미역맛초콜릿',6000,7,'Y');
INSERT INTO tbl_menu(menu_name, menu_price,orderable_status) 
VALUES('김케이크',99999,'N');

-- 여러행 일괄 삽입 ㄱㄴ
INSERT INTO
    tbl_menu
VALUES (null, '참치아이스크림',1500,12,'Y'),
             (null, '소금커피' ,1234,11,'Y');

INSERT INTO 
    tbl_menu(menu_name, menu_price,orderable_status) 
VALUES  ('김케이크',99999,'N'),
              ('호박케이크',89999,'N');
              
-- 데이터 값 작성시 서브쿼리 ㄱㄴ
INSERT INTO
    tbl_menu(menu_name, menu_price,category_code,orderable_status)
VALUES('곱창커피',5000, (SELECT category_code
                                                    FROM tbl_category
                                                    WHERE category_name= '커피'),'Y');
                                                    
/*
 REPLACE
 INSERT시 PRIMARY KEY 또는 UNIQUE KEY가 중복될 여지가 있을 경우
 REPLACE를 통해 중복된 데이터를 덮어씌운다
 정확히는 삭제됐다가 다시 삽입되는 구조
*/
-- INSERT INTO tbl_menu VALUES(17, '참기름소주',5000,10,'Y'); 중복키가 존재하여 오류발생
REPLACE INTO tbl_menu VALUES(17, '참기름소주',5000,10,'Y'); -- 중복키가 존재하여 수정
REPLACE tbl_menu VALUES(40, '까나리소주',5000,10,'Y'); -- 중복키가 존재하지 않아 삽입만
COMMIT; -- 수정 불가
/*
UPDATE
1. 테이블에 기록되어 있는 기존의 컬럼값을 수정
2. 테이블 행 수는 변화 없음
3. 문법
    ㄴ UPDATE 테이블명 
        SET 컬럼명 = 바꿀값,
        SET 컬럼명 = 바꿀값,
        ...
        WHERE 조건; -- 조건절이 없으면 전체 행 대상으로 다 수정됨

*/
UPDATE
    tbl_menu
SET
    category_code = 10;

SELECT * FROM tbl_menu;

ROLLBACK;

UPDATE
    tbl_menu
SET
    category_code = 8
WHERE 
    menu_name = '바나나맛해장국';
    
-- 참치아이스크림 메뉴의 카테고리 번호9 ,가격 3000 메뉴명 참치베스킨라빈스

UPDATE
    tbl_menu
SET
    category_code = 9,
    menu_name = '참치베라',
    menu_price = 3000
WHERE 
    menu_name = '참치아이스크림';
    
 SELECT * FROM tbl_menu;
   
UPDATE
    tbl_menu
SET
    menu_price = menu_price * 1.1;
    
-- update 내에 서브쿼리 ㄱㄴ
-- 커피 메뉴 가격 5000수정

UPDATE
    tbl_menu
SET
    menu_price = 5000
WHERE
    category_code = (SELECT category_code
                            FROM tbl_category
                            WHERE category_name = '커피');
-- 22번 메뉴 가격을 우럭 스무디 가격으로 수정

UPDATE
    tbl_menu
SET
    menu_price = (SELECT menu_price
                        FROM tbl_menu
                        WHERE menu_name = '우럭스무디') -- oracle에선 가능하나 mysql에서는 자기 자신 테이블의 데이터 사용시 1093에러
WHERE
    menu_code = 22;


    
UPDATE
    tbl_menu
SET
    menu_price = (
                        SELECT menu_price
                        FROM(
                        SELECT menu_price
                        FROM tbl_menu
                        WHERE menu_name = '우럭스무디'
                        )wooruk
                    )
WHERE
    menu_code = 23;
   
 SELECT * FROM tbl_menu;
COMMIT;

/*
DELETE
1. 테이블의 행 삭제 구문
2. 테이블의 행 개수가 줄어듦
3. 문법
    ㄴ DELETE
        FROM 테이블명
        WHERE 조건 ; 조건절 제시 안 할 경우 전체 행 삭제되니 유의
*/
 SELECT * FROM tbl_menu;
 DELETE
 FROM tbl_menu;
 
 SELECT * FROM tbl_menu;
 ROLLBACK;
 SELECT * FROM tbl_menu;
 
 DELETE
 FROM tbl_menu
 WHERE category_code = (
                                    SELECT
                                        FROM(
                                                SELECT category_code
                                                FROM tbl_menu
                                                WHERE menu_name='민트미역국'
                                                ) mint
                                            );
SELECT * FROM tbl_menu;

DELETE
FROM tbl_menu
LIMIT 2; -- offset 지정은 안 됨

DELETE
FROM tbl_menu
ORDER BY menu_price DESC
LIMIT 2;
    SELECT * FROM tbl_menu;
                                                