
-- Tạo cơ sở dữ liệu OnlineLearningDB
CREATE DATABASE OnlineLearningDB;
GO

-- Sử dụng cơ sở dữ liệu OnlineLearningDB
USE OnlineLearningDB;
GO

-- DROP DATABASE OnlineLearningDB

-- Tạo bảng User để lưu thông tin chung của tất cả các loại người dùng
CREATE TABLE [User] (
    User_ID INT PRIMARY KEY IDENTITY(1,1),
    First_Name NVARCHAR(100) NOT NULL,
    Last_Name NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(50) NOT NULL,
    Balance DECIMAL(10, 2) DEFAULT 0,
    Avatar_Image_Path VARCHAR(MAX),
    Background_ImagePath VARCHAR(MAX),
    Registration_Date DATETIME,
    Status INT DEFAULT 1,
    User_Type INT NOT NULL,
    CONSTRAINT CHK_Balance CHECK (Balance >= 0)
);

-- Tạo bảng Admin
CREATE TABLE Admin (
    Admin_ID INT PRIMARY KEY,
    User_ID INT NOT NULL,
    CONSTRAINT FK_Admin_User FOREIGN KEY (User_ID) REFERENCES [User](User_ID)
);

-- Tạo bảng CourseManager
CREATE TABLE CourseManager (
    Course_Manager_ID INT PRIMARY KEY,
    User_ID INT NOT NULL,
    CONSTRAINT FK_CourseManager_User FOREIGN KEY (User_ID) REFERENCES [User](User_ID)
);

-- Tạo bảng Mentor
CREATE TABLE Mentor (
    Mentor_ID INT PRIMARY KEY,
    User_ID INT NOT NULL,
    CONSTRAINT FK_Mentor_User FOREIGN KEY (User_ID) REFERENCES [User](User_ID)
);

-- Tạo bảng Learner
CREATE TABLE Learner (
    Learner_ID INT PRIMARY KEY,
    User_ID INT NOT NULL,
    CONSTRAINT FK_Learner_User FOREIGN KEY (User_ID) REFERENCES [User](User_ID)
);

-- Tạo bảng Certificate
CREATE TABLE Certificate (
    Certificate_ID INT PRIMARY KEY IDENTITY(1,1),
    Mentor_ID INT NOT NULL,
    Certificate_Name NVARCHAR(255) NOT NULL,
    Issued_Date DATE NOT NULL,
    Description NVARCHAR(MAX),
    Image_Path VARCHAR(MAX),
    CONSTRAINT FK_Certificate_Mentor FOREIGN KEY (Mentor_ID) REFERENCES Mentor(Mentor_ID)
);

-- Tạo bảng Category
CREATE TABLE Category (
    Cate_ID INT PRIMARY KEY IDENTITY(1,1),
    Cate_Name NVARCHAR(255) NOT NULL,
    Cate_Description NVARCHAR(MAX)
);

-- Tạo bảng Sub-Category
CREATE TABLE SubCategory (
    Sub_Cate_ID INT PRIMARY KEY IDENTITY(1,1),
    Cate_ID INT NOT NULL,
    Sub_Cate_Name NVARCHAR(255) NOT NULL,
    Sub_Cate_Description NVARCHAR(MAX)
    CONSTRAINT FK_Category FOREIGN KEY (Cate_ID) REFERENCES Category(Cate_ID)
);

-- Tạo bảng CourseCreator
CREATE TABLE CourseCreator (   
    Course_Creator_ID INT PRIMARY KEY IDENTITY(1,1),
    User_ID INT NOT NULL,
    CONSTRAINT FK_CourseCreator_User_ID FOREIGN KEY (User_ID) REFERENCES [User](User_ID)
);

-- Tạo bảng Course
CREATE TABLE Course (
    Course_ID INT PRIMARY KEY IDENTITY(1,1),
    Course_Name NVARCHAR(255) NOT NULL,
    Course_Description NVARCHAR(MAX),
    Sub_Cate_ID INT NOT NULL,
    Image_Path VARCHAR(MAX),
    Status INT DEFAULT 0,
    Price DECIMAL(10, 2),
    Course_Creator_ID INT NOT NULL,
    CONSTRAINT FK_SubCategory FOREIGN KEY (Sub_Cate_ID) REFERENCES SubCategory(Sub_Cate_ID),
    CONSTRAINT FK_CourseCreator FOREIGN KEY (Course_Creator_ID) REFERENCES CourseCreator(Course_Creator_ID),
    CONSTRAINT CHK_Price CHECK (Price >= 0)
);

-- Tạo bảng CourseSection
CREATE TABLE CourseSection(
    Section_ID INT PRIMARY KEY IDENTITY(1,1),
    Course_ID INT NOT NULL,
    Section_Name NVARCHAR(255) NOT NULL,
    Section_Description NVARCHAR(MAX),
    CONSTRAINT FK_Section_Course FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

-- Tạo bảng LessonType
CREATE TABLE LessonType (
    Lesson_Type_ID INT PRIMARY KEY IDENTITY(1,1),
    Lesson_Name NVARCHAR(100)
);

-- Tạo bảng Lesson
CREATE TABLE Lesson (
    Lesson_ID INT PRIMARY KEY IDENTITY(1,1),
    Section_ID INT NOT NULL,
    Lesson_Name NVARCHAR(255) NOT NULL,
    Lesson_Description NVARCHAR(MAX),
    Lesson_Type_ID INT NOT NULL,
    Lesson_Content NVARCHAR(MAX),
    CONSTRAINT FK_Lesson_Section FOREIGN KEY (Section_ID) REFERENCES CourseSection(Section_ID),
    CONSTRAINT FK_Lesson_Type FOREIGN KEY (Lesson_Type_ID) REFERENCES LessonType(Lesson_Type_ID),
);

--Tạo bảng Coupon
CREATE TABLE Coupon (
    Coupon_ID INT PRIMARY KEY IDENTITY(1,1),
    Coupon_Code VARCHAR(50),
    Discount_Percentage INT,
    Expiry_Date DATETIME,
    Quantity INT,
    CONSTRAINT CHK_DiscountPercentageRange CHECK (Discount_Percentage >= 0 AND Discount_Percentage <= 100),
    CONSTRAINT CHK_Quantity CHECK (Quantity >= 0)
);

-- Tạo bảng AssignmentType
CREATE TABLE AssignmentType (
    Assignment_Type_ID INT PRIMARY KEY IDENTITY(1,1),
    Assignment_Type_Name NVARCHAR(100) NOT NULL
);

-- Tạo bảng Assignment
CREATE TABLE Assignment (
    Assignment_ID INT PRIMARY KEY IDENTITY(1,1),
    Section_ID INT NOT NULL,
    Assignment_Name NVARCHAR(255) NOT NULL,
    Assignment_Description NVARCHAR(MAX),
    Assignment_Type_ID INT NOT NULL,
    Pass_Condition DECIMAL(10, 2),
    CONSTRAINT FK_Assignment_Section FOREIGN KEY (Section_ID) REFERENCES CourseSection(Section_ID),
    CONSTRAINT FK_Assignment_Type FOREIGN KEY (Assignment_Type_ID) REFERENCES AssignmentType(Assignment_Type_ID),
    CONSTRAINT CHK_PassCondition CHECK (Pass_Condition >= 0 AND Pass_Condition <= 10)
);

-- Tạo bảng AssignmentQuestion
CREATE TABLE AssignmentQuestion (
    Question_ID INT PRIMARY KEY IDENTITY(1,1),
    Assignment_ID INT NOT NULL,
    Question_Text NVARCHAR(MAX) NOT NULL,
    Answer_Text NVARCHAR(MAX) NOT NULL,
    CONSTRAINT FK_Question_Assignment FOREIGN KEY (Assignment_ID) REFERENCES Assignment(Assignment_ID)
);

CREATE TABLE [Order] (
    Order_ID INT IDENTITY (1, 1) PRIMARY KEY,
    User_ID INT NOT NULL,
    Order_Date DATETIME,
    Course_ID INT NOT NULL,
    Coupon_ID INT,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES [User](User_ID),
    FOREIGN KEY (Coupon_ID) REFERENCES Coupon(Coupon_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID),
    CONSTRAINT CHK_Order_Price CHECK (Price >= 0)
);

CREATE TABLE Feedback (
    Feedback_ID INT PRIMARY KEY,
    User_ID INT NOT NULL,
    Course_ID INT NOT NULL,
    Rating INT NOT NULL,
    Comment NVARCHAR(MAX),
    Feedback_Date DATETIME,
    FOREIGN KEY (User_ID) REFERENCES [User](User_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID),
    CONSTRAINT CHK_Rating CHECK (Rating >= 0 AND Rating <= 5)
);

CREATE TABLE CourseProgress (
    Course_ID INT NOT NULL,
    User_ID INT NOT NULL,
    Status INT DEFAULT 0,
    FOREIGN KEY (User_ID) REFERENCES [User](User_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID),
);