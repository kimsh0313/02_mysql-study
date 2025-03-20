/*
VIEW
쿼리문을 저장할 수 있는 데이터베이스 객체
다른 테이블에 있는 데이터를 보여줄 뿐, 데이터 자체를 포함하지는 않음(가상테이블)
    물리적인 실제 테이블과의 링크 개념
뷰를 사용하면 특정 사용자가 원본 테이블에 접근하여 모든 데이터를 보게 하는게 아니라
ㄴ일부만 보여지도록 할 수 있음

CREATE [OR REPLACE] VIEW 뷰명  --*OR REPLACE 옵션: 기존에 동일한 이름의 뷰가 존재할 경우 대체
AS
저장시킬 쿼리무운

*/

-- 한식 메뉴(카테고리 4) 만 따로 조회하는 VIEW 생서엉
CREATE OR REPLACE VIEW vw_menu_korean
AS
SELECT 
    menu_code
    ,menu_name
    ,menu_price
    ,category_code
    ,orderable_status
FROM
    tbl_menu
WHERE
    category_code = 4;

SELECT * FROM vw_menu_korean;

-- 베이스 테이블의 정보가 변경되면 VIEW 결과도 같이 변경
INSERT INTO tbl_menu VALUES(NULL , '식혜맛국밥', 5500, 4, 'Y');

/*
    VIEW 를 통한 DML
    VIEW 생성시 저장시킨 쿼리문에 그룹함수, DISTINCT, GROUP BY를 사용하지 않고
    ㄴ컬럼값을 가공하지 않은 경우 VIEW를 통한 DML(INSERT,UPDATE,DELETE)까능
*/

SHOW VARIABLES LIKE 'autocommit';
SET autocommit = 0;

SELECT *FROM vw_menu_korean;

-- VIEW 를 통한 INSERT
INSERT INTO vw_menu_korean VALUES(null,'초코맛국밥',6000,4,'Y');
INSERT INTO vw_menu_korean(menu_name,menu_price,orderable_status) VALUES('수정과맛국밥',6000,'Y');
SELECT *FROM tbl_menu;

-- VIEW 를 통한 UPDATE
UPDATE
    vw_menu_korean
SET
    menu_name = '아빠손칼국수'
    ,menu_price = 80000
WHERE
--    menu_code=1; -- view 에 존재하지 않은 데이터이므로 실제 베이스테이블에도 반영이 안 됨
menu_code = 5;

-- view를 통한 DELETE
DELETE
FROM vw_menu_korean
-- WHERE menu_code = 1;
WHERE menu_code = 5;

SELECT *FROM vw_menu_korean;
SELECT *FROM tbl_menu;

/*
저장된 서브쿼리에 따라 DML로 조작이 불가능한 경우
1 뷰에 정의되어 있지 않은 컬럼으로 조작하는 경우
2 뷰에 포함되지 않은 컬럼 중에 베이스테이블 컬럼이 NOT NULL 제약조건일 경우
3 산술 표현식 또는 함수식이 정의되어있을 경우
4 JOIN을 이용해 여러 테이블을 연결한 경우우
5 DISTINCT를 포함한 경우
6 그룹함수나 GROUP BY절을 포함한 경우우
*/

CREATE OR REPLACE VIEW vw_menu_korean
AS
SELECT
    menu_code AS '메뉴버노'
   , menu_name AS '메뉴명'
    ,menu_price AS '메뉴가격'
    ,category_code AS '카테고리'
FROM
    tbl_menu
WHERE
    category_code = 4;

SELECT *FROM tbl_menu;
SELECT *FROM vw_menu_korean;

INSERT INTO vw_menu_korean VALUES(null,'솔의눈 떡볶이',40000,4); -- orderable status에 null이 들어가려고해서


UPDATE vw_menu_korean
SET 메뉴가격 = 7000
WHERE 메뉴명 = '한우딸기국밥';

UPDATE nw_menu_korean
SET orderable_status = 'N'
WHERE 메뉴명 = '한우딸기국밥';

CREATE OR REPLACE VIEW vw_menu_korean
AS
SELECT
    menu_code
    ,menu_name
    ,menu_price
    ,category_name
    ,orderable_status
FROM
    tbl_menu m
        JOIN tbl_category c ON (c.category_code = m.category_code)
WHERE 
    category_name = '한식' ;
    
SELECT *FROM vw_menu_korean;

INSERT INTO nw_menu_korean VALUES(null,'초코우유',3000,'우유','N'); -- INSERT 실패

UPDATE vw_menu_korean
SET menu_price = 15000
WHERE menu_name = '생마늘샐러드';

UPDATE vw_menu_korean
SET category_name  = 'korean'
WHERE category_name = '한식';
SELECT *FROM tbl_category;

ROLLBACK;

-- WITH CHECK OPTION 뷰의 데이터 일관성 유지를 위해 DML을 통해 데이터 삽입 및 수정시 서브쿼리의 WHERE 조건에 해당하는 것만 ㄱㄴ

CREATE OR REPLACE VIEW vw_menu_expensive
AS
SELECT
    menu_code
    ,menu_name
    ,menu_price
    ,category_code
    ,orderable_status
FROM
    tbl_menu
WHERE
    menu_price >= 20000
WITH CHECK OPTION;

SELECT *FROM vw_menu_expensive;

-- INSERT INTO vw_menu_expensive VALUES(null,  '엄마손칼국수',15000,4,'Y');
INSERT INTO vw_menu_expensive VALUES(null,  '엄마손칼국수',23000,4,'Y');

SELECT *FROM tbl_menu;

UPDATE vw_menu_expensive
-- SET orderable_status = 'n'
-- SET menu_price = 32000
SET menu_price = 12000
WHERE menu_code = 18;

