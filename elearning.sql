CREATE DATABASE  IF NOT EXISTS `elearning` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `elearning`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: elearning
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cell`
--

DROP TABLE IF EXISTS `cell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cell` (
  `CELL_ID` char(6) NOT NULL,
  `CLASS_ID` char(5) DEFAULT NULL,
  `CELL_TITLE` varchar(50) DEFAULT NULL,
  `CELL_DESCRIPTION` varchar(500) DEFAULT NULL,
  `CELL_CREATEDDATE` datetime DEFAULT NULL,
  PRIMARY KEY (`CELL_ID`),
  KEY `FK_CELL_BELONGS_CLASS` (`CLASS_ID`),
  CONSTRAINT `FK_CELL_BELONGS_CLASS` FOREIGN KEY (`CLASS_ID`) REFERENCES `class` (`CLASS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cell`
--

LOCK TABLES `cell` WRITE;
/*!40000 ALTER TABLE `cell` DISABLE KEYS */;
INSERT INTO `cell` VALUES ('100001','10001','Thông tin học phần CL001','Chào mừng đến với lớp lập trình căn bản! Lớp này là một bước đầu tuyệt vời để khám phá và nắm vững những kiến thức cơ bản về lập trình. \nTrong khoá học này, chúng tôi sẽ khám phá các nguyên tắc căn bản của lập trình và hướng dẫn bạn cách sử dụng ngôn ngữ lập trình phổ biến \nnhư Python, Java hoặc C++. Bạn sẽ học cách viết mã, đặt tên biến, sử dụng các cấu trúc điều khiển như rẽ nhánh và vòng lặp, \nvà tổ chức mã của mình để tạo ra các chương trình hoạt động một cách logic và hiệu quả.','2024-04-17 10:04:06'),('100002','10001','Nộp bài tập nhóm đợt 1','Sinh viên vui lòng nộp bài tập nhóm đã được giao ở tuần 7 tại đây','2024-04-17 10:04:06'),('100003','10001','Về lịch học','Thứ 2: 13h30 hàng tuần tại phòng 210/DI','2024-04-17 10:04:06'),('100004','10002','Đây là ô mới','         A - Nội dung giảng dạy \n\nPhần 1: Các thành phần cơ bản của ngôn ngữ lập trình Java (2 buổi)\n\n  - Giới thiệu ngôn  ngữ Java\n  - Từ khóa, kiểu dữ liệu (cơ bản và mở rộng/tham chiếu) , biến - hằng, các phép toán - biểu thức, khối lệnh và phạm vi biến, các cấu trúc điều khiễn, phương thức/hàm, tái định nghĩa, Mảng và chuỗi, ....\n\nPhần 2: Lý thuyết lập trình hướng đối tượng (1 buổi)       ','2024-04-19 10:32:57'),('100005','10002','Nộp bài tập','Nộp bài tập TH Buổi 5 - Nhóm CLC M04 - C5                ','2024-04-19 10:38:45'),('100006','10010','Bài tập tuần 9','bla bla bla','2024-05-01 09:02:40');
/*!40000 ALTER TABLE `cell` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class` (
  `CLASS_ID` char(5) NOT NULL,
  `INSTRUCTOR_ID` char(6) DEFAULT NULL,
  `CLASS_NAME` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`CLASS_ID`),
  KEY `FK_CLASS_MANAGES_INSTRUCT` (`INSTRUCTOR_ID`),
  CONSTRAINT `FK_CLASS_MANAGES_INSTRUCT` FOREIGN KEY (`INSTRUCTOR_ID`) REFERENCES `instructor` (`INSTRUCTOR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class`
--

LOCK TABLES `class` WRITE;
/*!40000 ALTER TABLE `class` DISABLE KEYS */;
INSERT INTO `class` VALUES ('10001','GV001','CL001 - Lớp lập trình căn bản (HK1, năm 2023-2024)'),('10002','GV001','CL002 - Lớp lập trình hướng đối tượng (HK2, năm 2022-2023)'),('10003','GV002','CL003 - Lớp lập trình nâng cao (HK1, năm 2023-2023)'),('10004','GV002','CL004 - Lớp hệ quản trị cơ sở dữ liệu (HK2, năm 2023-2024)'),('10005','GV003','CL005 - Lớp phân tích và thiết kế hệ thống (HK1, năm 2024-2025)'),('10006','GV001','CL006 - Lớp phân tích và thiết kế thuật toán (HK2, năm 2024-2025)'),('10007','GV002','CL007 - Lớp mạng máy tính (HK1, năm 2022-2023)'),('10008','GV003','CL008 - Lớp mạng máy tính (HK1, năm 2023-2024)'),('10009','GV001','CL009 - Lớp lập trình web (HK2, năm 2023-2024)'),('10010','GV001','CT203H QTDA HK1');
/*!40000 ALTER TABLE `class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollment`
--

DROP TABLE IF EXISTS `enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollment` (
  `CLASS_ID` char(5) NOT NULL,
  `STUDENT_ID` char(8) NOT NULL,
  PRIMARY KEY (`CLASS_ID`,`STUDENT_ID`),
  KEY `FK_ENROLLME_ENROLLS2_STUDENT` (`STUDENT_ID`),
  CONSTRAINT `FK_ENROLLME_ENROLLS2_STUDENT` FOREIGN KEY (`STUDENT_ID`) REFERENCES `student` (`STUDENT_ID`),
  CONSTRAINT `FK_ENROLLME_IS_JOINED_CLASS` FOREIGN KEY (`CLASS_ID`) REFERENCES `class` (`CLASS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollment`
--

LOCK TABLES `enrollment` WRITE;
/*!40000 ALTER TABLE `enrollment` DISABLE KEYS */;
INSERT INTO `enrollment` VALUES ('10001','B2111001'),('10001','B2111002'),('10001','B2111003'),('10002','B2111001'),('10002','B2111002'),('10002','B2111003'),('10003','B2111001'),('10010','B2111001'),('10010','B2111002'),('10010','B2111003');
/*!40000 ALTER TABLE `enrollment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `homework`
--

DROP TABLE IF EXISTS `homework`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homework` (
  `CELL_ID` char(6) NOT NULL,
  `HOMEWORK_EXPIRATIONDATE` datetime DEFAULT NULL,
  PRIMARY KEY (`CELL_ID`),
  CONSTRAINT `FK_HOMEWORK_IS_A_HW_CELL` FOREIGN KEY (`CELL_ID`) REFERENCES `cell` (`CELL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homework`
--

LOCK TABLES `homework` WRITE;
/*!40000 ALTER TABLE `homework` DISABLE KEYS */;
INSERT INTO `homework` VALUES ('100002','2024-05-10 10:00:00'),('100005','2024-04-24 10:38:00'),('100006','2024-05-03 09:02:00');
/*!40000 ALTER TABLE `homework` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `homework_detail`
--

DROP TABLE IF EXISTS `homework_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homework_detail` (
  `CELL_ID` char(6) NOT NULL,
  `STUDENT_ID` char(8) NOT NULL,
  `HWDETAIL_SUBMITDATE` datetime NOT NULL,
  `hwdetail_grade` int(11) DEFAULT NULL,
  PRIMARY KEY (`CELL_ID`,`STUDENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homework_detail`
--

LOCK TABLES `homework_detail` WRITE;
/*!40000 ALTER TABLE `homework_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `homework_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instructor`
--

DROP TABLE IF EXISTS `instructor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instructor` (
  `INSTRUCTOR_ID` char(6) NOT NULL,
  `INSTRUCTOR_NAME` varchar(50) DEFAULT NULL,
  `INSTRUCTOR_DATEOFBIRTH` date DEFAULT NULL,
  `INSTRUCTOR_PASSWORD` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`INSTRUCTOR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instructor`
--

LOCK TABLES `instructor` WRITE;
/*!40000 ALTER TABLE `instructor` DISABLE KEYS */;
INSERT INTO `instructor` VALUES ('GV001','Thai Ha X','1986-01-01','$2y$10$rzy2lLxd0wfe8GuH2T/rHu8WMwE85RpIzmSgv2Sb2GJYIYSEYzJlm'),('GV002','Huu Van Y','1980-03-01','$2y$10$TMvxc.v80b8XAbggxJ67V.VpoxOiJALmQK1eqKvQeEEfqnBwZvqEK'),('GV003','Huynh Van Z\'','1989-12-01','$2y$10$Fjsahpngm5UoqgYJr/rbkuD4bvW7WvmsRjl7y37mfDILUm5eh4Tf6');
/*!40000 ALTER TABLE `instructor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `CELL_ID` char(6) NOT NULL,
  `NOTIFICATION_NOTE` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`CELL_ID`),
  CONSTRAINT `FK_NOTIFICA_IS_A_HW2_CELL` FOREIGN KEY (`CELL_ID`) REFERENCES `cell` (`CELL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES ('100001','Đây là dòng ghi chú. Chỉ có giảng viên thấy'),('100003','Đây là dòng ghi chú. Chỉ có giảng viên thấy'),('100004','                        ');
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `STUDENT_ID` char(8) NOT NULL,
  `STUDENT_NAME` varchar(50) DEFAULT NULL,
  `STUDENT_DATEOFBIRTH` date DEFAULT NULL,
  `STUDENT_PASSWORD` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`STUDENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES ('B2111001','Nguyen Van A','2003-01-01','$2y$10$ppupZLfPeh43M9UWaJa2z.pSstk2x5X8p9R2Z7dzuG58SacAjMg46'),('B2111002','Tran Thi B','2003-05-01','$2y$10$o6dtaspkcxNnRdxaGr0ghOMuDlU6jX5M/l3FsrA1BE5F3vgXeTRPW'),('B2111003','Phan Van C','2003-11-01','$2y$10$5IqimQ8asfBdCYCkf96Bq.M011lUJa49t/5EWIKVwfODUruJgH6bm');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'elearning'
--

--
-- Dumping routines for database 'elearning'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-01 17:08:05
