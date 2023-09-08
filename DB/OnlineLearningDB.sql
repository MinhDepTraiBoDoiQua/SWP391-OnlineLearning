
-- Tạo cơ sở dữ liệu OnlineLearningDB
CREATE DATABASE OnlineLearningDB;
GO

-- Sử dụng cơ sở dữ liệu OnlineLearningDB
USE OnlineLearningDB;
GO

-- DROP DATABASE OnlineLearningDB

-- Tạo bảng User để lưu thông tin chung của tất cả các loại người dùng
CREATE TABLE [User] (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(50) NOT NULL,
    Balance DECIMAL(10, 2) DEFAULT 0,
    AvatarImagePath VARCHAR(MAX),
    BackgroundImagePath VARCHAR(MAX),
    RegistrationDate DATETIME,
    Status INT DEFAULT 1,
    UserType INT NOT NULL,
    CONSTRAINT CHK_Balance CHECK (Balance >= 0)
);

-- Tạo bảng Admin
CREATE TABLE Admin (
    UserID INT PRIMARY KEY,
    CONSTRAINT FK_Admin_User FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- Tạo bảng CourseManager
CREATE TABLE CourseManager (
    UserID INT PRIMARY KEY,
    CONSTRAINT FK_CourseManager_User FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- Tạo bảng Mentor
CREATE TABLE Mentor (
    UserID INT PRIMARY KEY,
    CONSTRAINT FK_Mentor_User FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- Tạo bảng Learner
CREATE TABLE Learner (
    UserID INT PRIMARY KEY,
    CONSTRAINT FK_Learner_User FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- Tạo bảng Certificate
CREATE TABLE Certificate (
    CertificateID INT PRIMARY KEY IDENTITY(1,1),
    MentorID INT NOT NULL,
    CertificateName NVARCHAR(255) NOT NULL,
    IssuedDate DATE NOT NULL,
    Description NVARCHAR(MAX),
    ImagePath VARCHAR(MAX),
    CONSTRAINT FK_Certificate_Mentor FOREIGN KEY (MentorID) REFERENCES Mentor(UserID)
);

-- Tạo bảng Category
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(255) NOT NULL,
    CategoryDescription NVARCHAR(MAX)
);

-- Tạo bảng Sub-Category
CREATE TABLE SubCategory (
    SubCategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryID INT NOT NULL,
    SubCategoryName NVARCHAR(255) NOT NULL,
    SubCategoryDescription NVARCHAR(MAX)
    CONSTRAINT FK_Category FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- Tạo bảng CourseCreator
CREATE TABLE CourseCreator (   
    CourseCreatorID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    CONSTRAINT FK_CourseCreator_UserID FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- Tạo bảng Course
CREATE TABLE Course (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName NVARCHAR(255) NOT NULL,
    CourseDescription NVARCHAR(MAX),
    SubCategoryID INT NOT NULL,
    ImagePath VARCHAR(MAX),
    Status INT DEFAULT 0,
    Price DECIMAL(10, 2),
    CourseCreatorID INT NOT NULL,
    CONSTRAINT FK_SubCategory FOREIGN KEY (SubCategoryID) REFERENCES SubCategory(SubCategoryID),
    CONSTRAINT FK_CourseCreator FOREIGN KEY (CourseCreatorID) REFERENCES CourseCreator(CourseCreatorID),
    CONSTRAINT CHK_Price CHECK (Price >= 0)
);

-- Tạo bảng CourseSection
CREATE TABLE CourseSection(
    SectionID INT PRIMARY KEY IDENTITY(1,1),
    CourseID INT NOT NULL,
    SectionName NVARCHAR(255) NOT NULL,
    SectionDescription NVARCHAR(MAX),
    CONSTRAINT FK_Section_Course FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Tạo bảng LessonType
CREATE TABLE LessonType (
    LessonTypeID INT PRIMARY KEY IDENTITY(1,1),
    LessonName NVARCHAR(100)
);

-- Tạo bảng Lesson
CREATE TABLE Lesson (
    LessonID INT PRIMARY KEY IDENTITY(1,1),
    SectionID INT NOT NULL,
    LessonName NVARCHAR(255) NOT NULL,
    LessonDescription NVARCHAR(MAX),
    LessonTypeID INT NOT NULL,
    LessonContent NVARCHAR(MAX),
    CONSTRAINT FK_Lesson_Section FOREIGN KEY (SectionID) REFERENCES CourseSection(SectionID),
    CONSTRAINT FK_Lesson_Type FOREIGN KEY (LessonTypeID) REFERENCES LessonType(LessonTypeID),
);

--Tạo bảng Coupon
CREATE TABLE Coupon (
    CouponID INT PRIMARY KEY IDENTITY(1,1),
    CouponCode VARCHAR(50),
    DiscountPercentage INT,
    ExpiryDate DATETIME,
    Quantity INT,
    CONSTRAINT CHK_DiscountPercentageRange CHECK (DiscountPercentage >= 0 AND DiscountPercentage <= 100),
    CONSTRAINT CHK_Quantity CHECK (Quantity >= 0)
);

-- Tạo bảng AssignmentType
CREATE TABLE AssignmentType (
    AssignmentTypeID INT PRIMARY KEY IDENTITY(1,1),
    AssignmentTypeName NVARCHAR(100) NOT NULL
);

-- Tạo bảng Assignment
CREATE TABLE Assignment (
    AssignmentID INT PRIMARY KEY IDENTITY(1,1),
    SectionID INT NOT NULL,
    AssignmentName NVARCHAR(255) NOT NULL,
    AssignmentDescription NVARCHAR(MAX),
    AssignmentTypeID INT NOT NULL,
    PassCondition DECIMAL(10, 2),
    CONSTRAINT FK_Assignment_Section FOREIGN KEY (SectionID) REFERENCES CourseSection(SectionID),
    CONSTRAINT FK_Assignment_Type FOREIGN KEY (AssignmentTypeID) REFERENCES AssignmentType(AssignmentTypeID),
    CONSTRAINT CHK_PassCondition CHECK (PassCondition >= 0 AND PassCondition <= 10)
);

-- Tạo bảng AssignmentQuestion
CREATE TABLE AssignmentQuestion (
    QuestionID INT PRIMARY KEY IDENTITY(1,1),
    AssignmentID INT NOT NULL,
    QuestionText NVARCHAR(MAX) NOT NULL,
    AnswerText NVARCHAR(MAX) NOT NULL,
    CONSTRAINT FK_Question_Assignment FOREIGN KEY (AssignmentID) REFERENCES Assignment(AssignmentID)
);

-- Tạo bảng AssignmentAnswer
--CREATE TABLE AssignmentAnswer (
--    AnswerID INT PRIMARY KEY IDENTITY(1,1),
--   QuestionID INT NOT NULL,
--    AnswerText NVARCHAR(MAX) NOT NULL,
--    CONSTRAINT FK_Answer_Question FOREIGN KEY (QuestionID) REFERENCES AssignmentQuestion(QuestionID)
--);
