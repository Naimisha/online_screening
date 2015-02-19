-- MySQL dump 10.13  Distrib 5.5.40, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: online_screening_dev
-- ------------------------------------------------------
-- Server version	5.5.40-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `answer_sheets`
--

DROP TABLE IF EXISTS `answer_sheets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `answer_sheets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `answer` text COLLATE utf8_unicode_ci,
  `result` text COLLATE utf8_unicode_ci,
  `score` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_answer_sheets_on_user_id` (`user_id`) USING BTREE,
  KEY `index_answer_sheets_on_exam_id` (`exam_id`),
  CONSTRAINT `fk_rails_62b7a4a74a` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`),
  CONSTRAINT `fk_rails_726f8038b6` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answer_sheets`
--

LOCK TABLES `answer_sheets` WRITE;
/*!40000 ALTER TABLE `answer_sheets` DISABLE KEYS */;
INSERT INTO `answer_sheets` VALUES (71,'[{\"id\":1,\"question_id\":3},{\"id\":2,\"question_id\":2},{\"id\":3,\"question_id\":8},{\"id\":4,\"question_id\":12},{\"id\":5,\"question_id\":4},{\"id\":6,\"question_id\":9},{\"id\":7,\"question_id\":6},{\"id\":8,\"question_id\":5},{\"id\":9,\"question_id\":7},{\"id\":10,\"question_id\":10}]','[{\"question_id\":\"3\",\"answer\":\"[{\\\"ans\\\":\\\"256\\\"}]\"},{\"question_id\":\"2\",\"answer\":\"[{\\\"ans\\\":\\\"9/20\\\"}]\"},{\"question_id\":\"8\",\"answer\":\"[{\\\"ans\\\":\\\"\\\"}]\"},{\"question_id\":\"12\",\"answer\":\"[{\\\"ans\\\":\\\"\\\"}]\"},{\"question_id\":\"4\",\"answer\":\"[{\\\"ans\\\":\\\"\\\"}]\"},{\"question_id\":\"9\",\"answer\":\"[{\\\"ans\\\":\\\"\\\"}]\"},{\"question_id\":\"6\",\"answer\":\"[{\\\"ans\\\":\\\"\\\"}]\"},{\"question_id\":\"5\",\"answer\":\"[{\\\"ans\\\":\\\"\\\"}]\"},{\"question_id\":\"7\",\"answer\":\"[{\\\"ans\\\":\\\"#\\\"},{\\\"ans\\\":\\\"linked\\\"},{\\\"ans\\\":\\\"indexed\\\"},{\\\"ans\\\":\\\"#\\\"}]\"},{\"question_id\":\"10\",\"answer\":\"[{\\\"ans\\\":\\\"\\\"}]\"}]',4,7,'2015-02-12 11:10:29','2015-02-12 11:26:34',11,'2015-02-12 11:10:32','2015-02-12 12:42:00');
/*!40000 ALTER TABLE `answer_sheets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `controllers`
--

DROP TABLE IF EXISTS `controllers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `controllers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `User` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_controllers_on_email` (`email`) USING BTREE,
  UNIQUE KEY `index_controllers_on_reset_password_token` (`reset_password_token`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `controllers`
--

LOCK TABLES `controllers` WRITE;
/*!40000 ALTER TABLE `controllers` DISABLE KEYS */;
/*!40000 ALTER TABLE `controllers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_questions`
--

DROP TABLE IF EXISTS `exam_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exam_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exam_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_exam_questions_on_exam_id` (`exam_id`) USING BTREE,
  KEY `index_exam_questions_on_question_id` (`question_id`) USING BTREE,
  CONSTRAINT `fk_rails_0ab3c721ca` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`),
  CONSTRAINT `fk_rails_55dc38ab99` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_questions`
--

LOCK TABLES `exam_questions` WRITE;
/*!40000 ALTER TABLE `exam_questions` DISABLE KEYS */;
INSERT INTO `exam_questions` VALUES (143,11,1,'2015-02-12 10:38:54','2015-02-12 10:38:54'),(144,11,2,'2015-02-12 10:38:54','2015-02-12 10:38:54'),(145,11,3,'2015-02-12 10:38:54','2015-02-12 10:38:54'),(146,11,4,'2015-02-12 10:38:54','2015-02-12 10:38:54'),(147,11,5,'2015-02-12 10:38:54','2015-02-12 10:38:54'),(148,11,6,'2015-02-12 10:38:54','2015-02-12 10:38:54'),(149,11,7,'2015-02-12 10:38:54','2015-02-12 10:38:54'),(150,11,8,'2015-02-12 10:38:54','2015-02-12 10:38:54'),(151,11,9,'2015-02-12 10:38:54','2015-02-12 10:38:54'),(152,11,10,'2015-02-12 10:38:54','2015-02-12 10:38:54'),(153,11,12,'2015-02-12 10:38:54','2015-02-12 10:38:54');
/*!40000 ALTER TABLE `exam_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exams`
--

DROP TABLE IF EXISTS `exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `duration_mins` int(11) DEFAULT NULL,
  `college_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `exam_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `no_weightages` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `weightages` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `no_questions_each_weightage` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `total_marks` int(11) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_window_time` time DEFAULT NULL,
  `end_window_time` time DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exams`
--

LOCK TABLES `exams` WRITE;
/*!40000 ALTER TABLE `exams` DISABLE KEYS */;
INSERT INTO `exams` VALUES (11,580,'Nirma University','2015-02-10 17:19:21','2015-02-12 10:15:14','Nirma Screening Test','2015-02-12','10:27:00','2','[{\"weightage\":\"2\"},{\"weightage\":\"1\"}]','[{\"no_questions\":\"2\"},{\"no_questions\":\"8\"}]',12,'Activated','03:27:00','18:12:00'),(12,180,'Chandubhai S Patel Institute of Technology','2015-02-12 07:34:47','2015-02-12 08:35:02','Charusat Screening test','2015-02-12',NULL,NULL,NULL,NULL,NULL,'Deactivated','13:00:00','18:00:00');
/*!40000 ALTER TABLE `exams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `privileges`
--

DROP TABLE IF EXISTS `privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `privileges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_privileges_on_role_id` (`role_id`) USING BTREE,
  KEY `index_privileges_on_user_id` (`user_id`) USING BTREE,
  CONSTRAINT `fk_rails_2342624677` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `fk_rails_3fa24be448` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `privileges`
--

LOCK TABLES `privileges` WRITE;
/*!40000 ALTER TABLE `privileges` DISABLE KEYS */;
INSERT INTO `privileges` VALUES (1,1,1,'2015-01-30 05:30:20','2015-01-30 05:30:20'),(5,5,1,'2015-02-10 16:26:05','2015-02-11 05:36:16'),(6,6,1,'2015-02-11 06:06:18','2015-02-11 06:07:29'),(7,7,2,'2015-02-11 06:09:28','2015-02-11 06:09:28');
/*!40000 ALTER TABLE `privileges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` text COLLATE utf8_unicode_ci,
  `options` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `answer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `weightage` int(11) DEFAULT NULL,
  `qtype` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `nooptions` int(11) DEFAULT NULL,
  `image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,'A bag contains 2 red, 3 green and 2 blue balls. Two balls are drawn at random. What is the probability that none of the balls drawn is blue?','[{\"opt\":\"10/21\"},{\"opt\":\"11/21\"},{\"opt\":\"2/7\"},{\"opt\":\"5/7\"}]','[{\"ans\":\"10/21\"}]',1,'mcq','2015-01-30 05:51:05','2015-02-11 18:41:02',4,''),(2,'Tickets numbered 1 to 20 are mixed up and then a ticket is drawn at random. What is the probability that the ticket drawn has a number which is a multiple of 3 or 5?','[{\"opt\":\"1/2\"},{\"opt\":\"2/5\"},{\"opt\":\"8/15\"},{\"opt\":\"9/20\"}]','[{\"ans\":\"9/20\"}]',2,'mcq','2015-01-30 05:52:09','2015-02-11 18:15:53',4,''),(3,'Number of subsets of power set of {1, 2, 3} is','[{\"opt\":\"256\"}]','[{\"ans\":\"256\"}]',2,'numerical','2015-01-30 06:04:38','2015-02-11 18:16:02',1,''),(4,'Maximum window size for sliding window protocol for bandwidth b (Mbps), propagation delay p (s) and packet size f (Mb) is','[{\"opt\":\"b*p*f\"},{\"opt\":\"2*b*p/f\"},{\"opt\":\"2*b*p/f + 1\"}]','[{\"ans\":\"2*b*p/f + 1\"}]',1,'mcq','2015-01-30 07:37:18','2015-02-11 18:16:10',3,''),(5,'A station in a network forwards incoming packets by placing them on its shortest output queue. What routing algorithm is being used?','[{\"opt\":\"Hot potato routing\"},{\"opt\":\"Flooding\"},{\"opt\":\"Static routing\"},{\"opt\":\"Delta routing\"},{\"opt\":\"None the above\"}]','[]',1,'mcq','2015-01-30 07:49:42','2015-02-11 18:16:31',5,''),(6,'Frames from one LAN can be transmitted to another LAN via the device','[{\"opt\":\"Router\"},{\"opt\":\"Bridge\"},{\"opt\":\"Repeater\"},{\"opt\":\"Modem\"}]','[{\"ans\":\"Bridge\"}]',1,'mcq','2015-01-30 08:03:09','2015-02-11 18:42:45',4,''),(7,'The three major methods of allocating disk space that are in wide use are','[{\"opt\":\"contiguous\"},{\"opt\":\"linked\"},{\"opt\":\"indexed\"},{\"opt\":\"hashed\"}]','[{\"ans\":\"contiguous\"},{\"ans\":\"linked\"},{\"ans\":\"indexed\"},{\"ans\":\"#\"}]',1,'multi','2015-02-04 17:01:07','2015-02-11 18:25:19',4,''),(8,'On systems where there are multiple operating system, the decision to load a particular one is done by ','[{\"opt\":\"boot loader\"},{\"opt\":\"boot strap\"},{\"opt\":\"process control block\"},{\"opt\":\"file control block\"}]','[{\"ans\":\"boot loader\"}]',1,'mcq','2015-02-10 11:06:21','2015-02-11 18:26:43',4,''),(9,'Which of the following condition is required for deadlock to be possible?','[{\"opt\":\"mutual exlusion\"},{\"opt\":\"a process may hold allocated resources while awaiting assignment of other resources\"},{\"opt\":\" no resource can be forcibly removed from a process holding it\"},{\"opt\":\"all of the mentioned\"}]','[{\"ans\":\"all of the mentioned\"}]',1,'mcq','2015-02-11 18:29:48','2015-02-11 18:29:48',4,''),(10,'What is process of defining two or more methods within same class that have same name but different parameters declaration?','[{\"opt\":\"method overloading\"},{\"opt\":\"method overriding\"},{\"opt\":\"method hiding\"},{\"opt\":\"none of the mentioned\"}]','[{\"ans\":\"method overloading\"}]',1,'mcq','2015-02-11 18:32:00','2015-02-11 18:32:00',4,''),(12,'Problem 1','[{\"opt\":\"2\"}]','[{\"ans\":\"2\"}]',1,'numerical','2015-02-12 06:22:05','2015-02-12 06:22:05',1,'');
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','2015-01-30 05:29:33','2015-01-30 05:29:33'),(2,'user','2015-01-30 05:29:50','2015-01-30 05:29:50');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20150106063604'),('20150106091606'),('20150108105707'),('20150109053154'),('20150120061615'),('20150120061643'),('20150120071329'),('20150122075222'),('20150123074003'),('20150127072918'),('20150127073207'),('20150127082552'),('20150127102949'),('20150203063153'),('20150206074201'),('20150206075750'),('20150206080410'),('20150209054423'),('20150209062939'),('20150209065756'),('20150210072922'),('20150210173816');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timers`
--

DROP TABLE IF EXISTS `timers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `finished` tinyint(1) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rails_b29f144422` (`exam_id`),
  KEY `fk_rails_35e5dfc429` (`user_id`),
  CONSTRAINT `fk_rails_35e5dfc429` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_b29f144422` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timers`
--

LOCK TABLES `timers` WRITE;
/*!40000 ALTER TABLE `timers` DISABLE KEYS */;
/*!40000 ALTER TABLE `timers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `student_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone_no` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `degree` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `passing_year` int(11) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `registration_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`) USING BTREE,
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'psharshit17@gmail.com','$2a$10$7W.Jm4YvWlzX4nsSF9cWOex1u3j8YypryKA80OAbhi7XeOM8JpMYa',NULL,NULL,NULL,61,'2015-02-10 06:34:08','2015-02-10 06:31:03','192.168.43.234','192.168.43.234','1','Harshit','Patel','9662037063','B.Tech.',2015,'1993-08-17',NULL,'2015-01-30 05:28:37','2015-02-10 06:34:08'),(5,'harry@gmail.com','$2a$04$p69WjqBnCMo4HQ7EzuLri.euGTYtdnWFeV3NoSmPO0DOn.vYZuFlK',NULL,NULL,NULL,64,'2015-02-12 10:38:17','2015-02-12 10:14:52','192.168.1.197','192.168.1.197','1','Harry','Potter','9999999999','B.Tech.',2015,'1994-08-15',NULL,'2015-02-10 16:26:05','2015-02-12 10:38:17'),(6,'ron@gmail.com','$2a$10$LnAQHRt6MY58v0MdVb.6Hut9aLnX294LiFXhrTQiueI6uJ31fVdYm',NULL,NULL,NULL,2,'2015-02-11 06:07:47','2015-02-11 06:06:18','192.168.1.197','192.168.1.197','3','Ronald','Weasley','9999999999','B.Tech.',2015,'1993-06-23',NULL,'2015-02-11 06:06:18','2015-02-11 06:07:47'),(7,'hermoine@gmail.com','$2a$10$JsM.xIJjUud7VXab9841rOrJobUiRmoaH3FqEl6vm9lTqoBqHRnq2',NULL,NULL,NULL,50,'2015-02-12 11:10:28','2015-02-12 11:09:09','192.168.1.197','192.168.1.197','5','Hermoine','Granger','9999999999','B.Tech.',2015,'1994-04-15',NULL,'2015-02-11 06:09:27','2015-02-12 11:10:28');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-02-12 17:11:45
