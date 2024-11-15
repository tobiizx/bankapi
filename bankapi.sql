-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Lis 15, 2024 at 09:19 AM
-- Wersja serwera: 10.4.32-MariaDB
-- Wersja PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bankapi`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `account`
--

CREATE TABLE `account` (
  `accountNo` int(11) NOT NULL,
  `amount` bigint(20) NOT NULL COMMENT 'wartość w groszach',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`accountNo`, `amount`, `name`, `user_id`) VALUES
(123456, 10863, 'żółty', 1),
(1234567, 13010, 'szef', 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `token`
--

CREATE TABLE `token` (
  `id` int(11) NOT NULL,
  `token` varchar(70) NOT NULL COMMENT 'sha-256',
  `ip` varchar(16) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `token`
--

INSERT INTO `token` (`id`, `token`, `ip`, `user_id`) VALUES
(1, '99fe73cd4993eaecce99e15732dcf64a442f62d8905132a65f1c6730d0934580', '::1', 1),
(2, 'ab70334a0b8bf1782d93fc5f1dcd5bd59af1d5057540ab644d9605c67d6e0c8c', '::1', 1),
(3, 'c1fcd12ba605a4d138dbe87b50f9f0b40a14d0b7be847ec0a302c6ee4db0875b', '::1', 1),
(4, 'ef20518c1ef0298b638b15ef7834741070fa0cc309405c04fa33aa58765d52a8', '::1', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `transfer`
--

CREATE TABLE `transfer` (
  `id` int(11) NOT NULL,
  `source` int(11) NOT NULL,
  `target` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transfer`
--

INSERT INTO `transfer` (`id`, `source`, `target`, `timestamp`, `amount`) VALUES
(1, 123456, 1234567, '2024-11-15 07:52:43', 2),
(2, 123456, 1234567, '2024-11-15 07:53:01', -2),
(3, 123456, 1234567, '2024-11-15 07:53:33', 3000),
(4, 123456, 1234567, '2024-11-15 08:15:26', 10000);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `email` varchar(128) NOT NULL,
  `passwordHash` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `passwordHash`) VALUES
(1, 'user1@teb.pl', '$argon2i$v=19$m=16,t=2,p=1$VzdWeUp1Rjd0Z3ZjTW9MRA$1ZN7zIYkMcmTIZkfCMN2tA'),
(2, 'user2@teb.pl', '$argon2i$v=19$m=16,t=2,p=1$Z2VSWlZHNkFaOFhuN05RWg$ST6PzApSsYLXRjhoHKWADg');

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`accountNo`),
  ADD KEY `fk_user_id` (`user_id`);

--
-- Indeksy dla tabeli `token`
--
ALTER TABLE `token`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeksy dla tabeli `transfer`
--
ALTER TABLE `transfer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_source` (`source`),
  ADD KEY `fk_target` (`target`);

--
-- Indeksy dla tabeli `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `token`
--
ALTER TABLE `token`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `transfer`
--
ALTER TABLE `transfer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `account`
--
ALTER TABLE `account`
  ADD CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `token`
--
ALTER TABLE `token`
  ADD CONSTRAINT `token_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `transfer`
--
ALTER TABLE `transfer`
  ADD CONSTRAINT `fk_source` FOREIGN KEY (`source`) REFERENCES `account` (`accountNo`),
  ADD CONSTRAINT `fk_target` FOREIGN KEY (`target`) REFERENCES `account` (`accountNo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
