-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 10, 2024 at 02:12 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `recover_0.1`
--

-- --------------------------------------------------------

--
-- Table structure for table `challanges`
--

CREATE TABLE `challanges` (
  `id` int(10) UNSIGNED NOT NULL,
  `header` varchar(50) DEFAULT NULL,
  `info` varchar(300) DEFAULT NULL,
  `points` tinyint(3) UNSIGNED DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `challanges`
--

INSERT INTO `challanges` (`id`, `header`, `info`, `points`) VALUES
(1, 'Dzień Ziemi', 'spróbuj przez cały dzień obyć się bez sztucznego oświetlenia. Wykorzystaj naturalne światło i dołóż swoją cegiełkę do ochrony naszej planety!', 5);

-- --------------------------------------------------------

--
-- Table structure for table `quizquestions`
--

CREATE TABLE `quizquestions` (
  `id` int(10) UNSIGNED NOT NULL,
  `question` varchar(50) DEFAULT NULL,
  `answers` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quizquestions`
--

INSERT INTO `quizquestions` (`id`, `question`, `answers`) VALUES
(2, 'Ile litrów wody średnio zużywa się podczas 10-minu', '{\"options\": [\"20 litrów\", \"50 litrów\", \"100 litrów\"], \"correct_answer\": 3, \"explanation\": \"Prysznic zużywa średnio 10 litrów wody na minutę.\"}'),
(3, 'Jaki procent światowego zużycia plastiku jest podd', '{\"options\": [\"około 9%\", \"około 25%\", \"około 50%\"], \"correct_answer\": 1, \"explanation\": \"Około 9% plastiku jest poddawane recyklingowi, reszta trafia na wysypiska lub do środowiska.\"}'),
(4, 'Ile lat średnio rozkłada się plastikowa butelka?', '{\"options\": [\"100 lat\", \"450 lat\", \"1000 lat\"], \"correct_answer\": 2, \"explanation\": \"Plastikowa butelka rozkłada się średnio około 450 lat, co jest poważnym obciążeniem dla środowiska.\"}'),
(5, 'Ile litrów wody potrzeba do wyprodukowania jednej ', '{\"options\": [\"około 500 litrów\", \"około 1500 litrów\", \"około 2700 litrów\"], \"correct_answer\": 3, \"explanation\": \"Do wyprodukowania jednej koszulki bawełnianej potrzeba około 2700 litrów wody.\"}'),
(6, 'Jaki procent globalnych emisji gazów cieplarnianyc', '{\"options\": [\"około 14%\", \"około 23%\", \"około 35%\"], \"correct_answer\": 1, \"explanation\": \"Transport odpowiada za około 14% globalnych emisji gazów cieplarnianych.\"}'),
(7, 'Ile kilogramów odpadów produkuje rocznie przeciętn', '{\"options\": [\"około 200 kg\", \"około 400 kg\", \"około 600 kg\"], \"correct_answer\": 2, \"explanation\": \"Przeciętny człowiek produkuje około 400 kg odpadów rocznie.\"}');

-- --------------------------------------------------------

--
-- Table structure for table `records`
--

CREATE TABLE `records` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `info` varchar(200) DEFAULT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `pointsBase` tinyint(1) DEFAULT 1,
  `pointsBonus` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `records`
--

INSERT INTO `records` (`id`, `name`, `info`, `tags`, `pointsBase`, `pointsBonus`) VALUES
(1, 'Butelki PET', 'Jeśli dziś nie używałeś jednorazowej plastikowej butelki, gratulacje! Dzięki temu pomagasz zmniejszyć ilość plastiku w środowisku i chronisz naszą planetę.', NULL, 1, 30),
(2, 'Jedzenie Mięsa', 'Produkcja mięsa mocno obciąża środowisko – spróbuj ograniczyć jego spożycie lub wyeliminować je całkowicie. To mały krok, który może zrobić dużą różnicę dla planety!', '[\"notVegan\"]', 2, 14),
(3, 'Używanie Suszarki', 'Pozwól włosom wyschnąć naturalnie, to zdrowsze dla nich i pomaga oszczędzać energię, którą zużywa suszarka.', '[\"hairDryer\"]', 1, 45),
(4, 'Wypięcie z sieci', 'Odłączaj urządzenia z gniazdek – nawet wyłączone, nadal zużywają energię. To prosty sposób na oszczędzanie prądu i ochronę środowiska!', NULL, 1, 21),
(5, 'Wspólna jazda', 'Podróżuj wspólnie – im więcej osób w samochodzie, tym mniejszy ślad węglowy przypadający na każdego pasażera. To oszczędność paliwa i korzyść dla planety!', '[\"car\"]', 3, 7),
(6, 'Wyłącz klimatyzację', 'Zamiast tego przewietrz pomieszczenie lub ubierz się odpowiednio do temperatury. To prosty sposób na oszczędność energii i wsparcie dla środowiska!', '[\"AC\"]', 1, 30);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `mail` varchar(100) NOT NULL,
  `userPasword` varchar(100) NOT NULL,
  `nick` varchar(30) NOT NULL,
  `mainStreak` mediumint(9) NOT NULL DEFAULT 0,
  `points` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `streaks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`streaks`)),
  `quizQuestions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`quizQuestions`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `mail`, `userPasword`, `nick`, `mainStreak`, `points`, `tags`, `streaks`, `quizQuestions`) VALUES
(1, 'urzytkownika@poczta.skrzynka.irl', '$2y$10$4wrrFpc2mT9Sml6qIA5yjemi0pagatUNtIn5k.q34bh', 'user', 24, 84, '[\"apartment\", \"notVegan\", \"hairDryer\"]', '[{\"id\": 1, \"days\": 24, \"longestStreak\": 76}, {\"id\": 2, \"days\": 0, \"longestStreak\": 5}, {\"id\": 3, \"days\": 11, \"longestStreak\": 12}, {\"id\": 4, \"days\": 2, \"longestStreak\": 25}]', '{\"correct\": [2, 6], \"uncorrect\": [3, 4, 5]}'),
(2, 'abcdef@123.xyz', '$2y$10$8dKed78FO48snzdf9xjKbg8HF891', 'qwerty', 50, 312, '[\"detachedHouse\", \"vegan\", \"AC\", \"car\"]', '[{\"id\": 1, \"days\": 50, \"longestStreak\": 50}, {\"id\": 4, \"days\": 13, \"longestStreak\": 22}, {\"id\": 5, \"days\": 0, \"longestStreak\": 1}, {\"id\": 6, \"days\": 5, \"longestStreak\": 34}]', '{\"correct\": [2, 3, 4], \"uncorrect\": [5, 6]}');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `challanges`
--
ALTER TABLE `challanges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `quizquestions`
--
ALTER TABLE `quizquestions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `records`
--
ALTER TABLE `records`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `challanges`
--
ALTER TABLE `challanges`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `quizquestions`
--
ALTER TABLE `quizquestions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `records`
--
ALTER TABLE `records`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
