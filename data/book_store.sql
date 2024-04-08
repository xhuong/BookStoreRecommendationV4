CREATE TABLE `Role` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `value` VARCHAR(255) NOT NULL
) ENGINE = INNODB;

CREATE TABLE `User` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `phone_number` VARCHAR(255) NOT NULL,
    `user_name` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `role_id` INT NOT NULL
) ENGINE = INNODB;

CREATE TABLE `Book` (
    `id` VARCHAR(255) NOT NULL PRIMARY KEY UNIQUE,
    -- check
    `name` VARCHAR(255) NOT NULL,
    `price` INT NOT NULL,
    `available_quantity` INT NOT NULL,
    `year_of_publication` INT NOT NULL,
    `image_url` VARCHAR(255) NOT NULL,
    `author_id` INT NOT NULL,
    `publisher_id` INT NOT NULL
) ENGINE = INNODB;

CREATE TABLE `Publisher` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
) ENGINE = INNODB;

CREATE TABLE `Author` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
) ENGINE = INNODB;

CREATE TABLE `Review` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `review_content` VARCHAR(255),
    `review_date` DATETIME NOT NULL,
    `rating` INT NOT NULL,
    `user_id` INT NOT NULL,
    `book_id` VARCHAR(255) NOT NULL
) ENGINE = INNODB;

CREATE TABLE `Discount` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `value` INT NOT NULL,
    `number_of_uses_remaining` INT NOT NULL,
    `start_date` DATETIME NOT NULL,
    `end_date` DATETIME NOT NULL,
    `status` VARCHAR(255)
) ENGINE = INNODB;

CREATE TABLE `Order` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `order_date` DATETIME NOT NULL,
    `state` VARCHAR(255) NOT NULL,
    `discount_id` INT NOT NULL UNIQUE,
    `user_id` INT NOT NULL UNIQUE
) ENGINE = INNODB;

CREATE TABLE `Order_detail` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `book_id` VARCHAR(255) NOT NULL UNIQUE,
    `order_id` INT NOT NULL UNIQUE,
    `amount` INT NOT NULL
) ENGINE = INNODB;

CREATE TABLE `UserRelDiscount` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL UNIQUE,
    `discount_id` INT NOT NULL UNIQUE
) ENGINE = INNODB;

-- add constraint for User table
ALTER TABLE
    `User`
ADD
    CONSTRAINT `User_Role_id_fkey` FOREIGN KEY (`role_id`) REFERENCES `Role`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- add constraint for Book table
ALTER TABLE
    `Book`
ADD
    CONSTRAINT `Book_Author_id_fkey` FOREIGN KEY (`author_id`) REFERENCES `Author`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE
    `Book`
ADD
    CONSTRAINT `Book_Publisher_id_fkey` FOREIGN KEY (`publisher_id`) REFERENCES `Publisher`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- add constraint for Review table
ALTER TABLE
    `Review`
ADD
    CONSTRAINT `Review_Book_id_fkey` FOREIGN KEY (`book_id`) REFERENCES `Book`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE
    `Review`
ADD
    CONSTRAINT `Review_User_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- add constraint for Order table
ALTER TABLE
    `Order`
ADD
    CONSTRAINT `Order_User_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE
    `Order`
ADD
    CONSTRAINT `Order_Discount_id_fkey` FOREIGN KEY (`discount_id`) REFERENCES `Discount`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- add constraint for Order_detail table
ALTER TABLE
    `Order_detail`
ADD
    CONSTRAINT `OrderDetail_Order_id_fkey` FOREIGN KEY (`order_id`) REFERENCES `Order`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE
    `Order_detail`
ADD
    CONSTRAINT `OrderDetail_Book_id_fkey` FOREIGN KEY (`book_id`) REFERENCES `Book`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- add constraint for UserRelDiscount table
ALTER TABLE
    `UserRelDiscount`
ADD
    CONSTRAINT `UserRelDiscount_User_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE
    `UserRelDiscount`
ADD
    CONSTRAINT `UserRelDiscount_Discount_id_fkey` FOREIGN KEY (`discount_id`) REFERENCES `Discount`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- INSERT DATA FOR Role Table
INSERT INTO
    Role(name, value)
VALUES
    ("admin", "admin"),
    ("customer", "customer");

-- INSERT DATA FOR User Table
INSERT INTO
    User(
        name,
        phone_number,
        user_name,
        password,
        address,
        role_id
    )
VALUES
    (
        'customer02',
        '0886989988',
        'customer02',
        'customer123',
        'Quang Ninh, VN',
        1
    );

-- INSERT DATA FOR Publisher Table
INSERT INTO
    Publisher (name)
VALUES
    ('Publisher01');

-- INSERT DATA FOR Author Table
INSERT INTO
    Author (name)
VALUES
    ('Author01');

-- INSERT DATA FOR Book Table
INSERT INTO
    Book (
        id,
        name,
        price,
        available_quantity,
        year_of_publication,
        image_url,
        author_id,
        publisher_id
    )
VALUES
    (
        '0909999999',
        'Test title',
        50000,
        5,
        1930,
        'test/image.png',
        1,
        1
    );

-- INSERT DATA FOR Review Table
INSERT INTO
    Review(
        review_content,
        review_date,
        rating,
        user_id,
        book_id
    )
VALUES
    (
        'review content',
        '2023-12-31 15:30:45',
        5,
        1,
        '0909999999'
    );

-- INSERT DATA FOR Discount Table
INSERT INTO
    Discount (
        name,
        value,
        number_of_uses_remaining,
        start_date,
        end_date,
        status
    )
VALUES
    (
        'ma_khuyen_mai_01',
        20000,
        1,
        '2024-03-20 10:00:00',
        '2024-03-20 10:30:00',
        'INACTIVE' -- ACTIVE | INACTIVE | EXPIRED
    );