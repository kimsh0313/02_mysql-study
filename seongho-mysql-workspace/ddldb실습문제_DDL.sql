use ddldb;
CREATE TABLE tbl_publisher(
    pub_no INT PRIMARY KEY AUTO_INCREMENT COMMENT '출판사번호',
    pub_name VARCHAR(255) NOT NULL COMMENT '출판사명',
    phone VARCHAR(255) COMMENT '전화번호'
        );

INSERT INTO tbl_publisher
VALUES
    (null, 'BR','02-1111-2222'),
    (null, '문학동네','02-3333-4444'),
    (null, '바람개비','02-5555-6666');
    
SELECT * FROM tbl_book;

CREATE TABLE tbl_book(
    bk_no INT PRIMARY KEY AUTO_INCREMENT COMMENT '도서번호',
    bk_title VARCHAR(255) NOT NULL COMMENT '도서명',
    bk_author VARCHAR(255) NOT NULL COMMENT '저자',
    bk_price INT  COMMENT '도서가격',
    bk_pub_no INT  COMMENT '출판사번호',
    FOREIGN KEY(bk_pub_no)
    REFERENCES tbl_publisher(pub_no)
    ON DELETE CASCADE
        );

INSERT INTO tbl_book
VALUES
    (null, '칭찬 고래 춤','고래',10000,1),
    (null, '자바 정석','홍길동',20000,2),
    (null, '오라클 마스터하기','오라클',30000,2),
    (null, '자바 정복','제임스 뭐시기',15000,1),
    (null, '문 익히기','선생님',15000,3);
    
    SELECT * FROM tbl_book;
    
CREATE TABLE tbl_member(
    mem_no INT PRIMARY KEY 
    AUTO_INCREMENT COMMENT '회원번호',
    mem_id VARCHAR(30) NOT NULL UNIQUE COMMENT '아이디',
    mem_pwd VARCHAR(30) NOT NULL COMMENT '비밀번호',
    mem_name VARCHAR(30) NOT NULL COMMENT '회원명',
    gender CHAR(1) CHECK(gender IN ('M', 'F')) COMMENT '성별', 
    address VARCHAR(255) COMMENT '주소',
    phone VARCHAR(30) COMMENT '전화번호',
    status CHAR(1)  DEFAULT 'N' COMMENT '탈퇴여부' CHECK(status IN('Y','N')) ,
    enroll_dt DATETIME DEFAULT NOW() COMMENT'가입일시'
);
DROP TABLE tbl_member;
SELECT  * FROM tbl_member;
INSERT INTO tbl_member
VALUES
    (1001, 'user01','pw01','홍길동','M','서울 강서','1111-1111',default,default),
    (null, 'user02','pw02','강보람','F','서울 강남','1511-1111',default,default),
    (null, 'user03','pw03','신사임당','F','서울 강','1411-1111',default,default),
    (null, 'user04','pw04','백신아','F','서울 강북','1311-1111',default,default),
    (null, 'user05','pw05','김말똥','M','서울 강가','1211-1111',default,default);
    

    
    