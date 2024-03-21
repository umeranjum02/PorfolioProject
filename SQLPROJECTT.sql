--Select all statements
SELECT *
FROM PlayersInfo
ORDER BY 1

SELECT *
FROM PlayersAttributes
ORDER BY 1,2

--SELECT THE COLUMNS WE ARE GOING TO USE
SELECT name, full_name, birth_date, nationality, age, overall_rating
FROM PlayersInfo
ORDER BY 1,2

SELECT finishing, long_passing, short_passing, shot_power, penalties
FROM PlayersAttributes
ORDER BY 1

--SELECT PLAYER WITH THE HIGHEST OVERALL
SELECT full_name, MAX(OVERALL_RATING) AS MAX_OVERALL
FROM PlayersInfo
GROUP BY full_name, overall_rating 
HAVING overall_rating = MAX(overall_rating)
ORDER BY 2 DESC, 1

SELECT name, full_name, nationality, age, overall_rating
FROM PlayersInfo
WHERE overall_rating = (SELECT MAX(OVERALL_RATING) FROM PlayersInfo)    

--SELECT THE PERECENTAGE OF PLAYERS WHO REPRESESNT DIFFERENT NATIONALITIES
SELECT NATIONALITY, COUNT(*) AS total_players, (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM PlayersInfo)) AS percentage
FROM PlayersInfo
GROUP BY nationality
ORDER BY nationality

--SELECT THE COUNTRY WITH MAX NO OF PLAYERS
SELECT nationality, COUNT(NATIONALITY) AS MAX_COUNT
FROM PlayersInfo
--WHERE nationality = MAX(COUNT(NATIONALITY))
GROUP BY nationality
order by MAX_COUNT desc

--SELECT THE PLAYER WITH HIGHEST RELEASE CLAUSE
SELECT full_name, nationality, age, overall_rating, release_clause_euro
FROM PlayersInfo
WHERE release_clause_euro = (SELECT MAX(RELEASE_CLAUSE_EURO) FROM PlayersInfo)

--AVG AGE OF THE PLAYERS FROM GERMANY
SELECT full_name, AGE, (SELECT AVG(AGE) FROM PlayersInfo WHERE nationality = 'Germany')
FROM PlayersInfo
WHERE nationality = 'Germany'
GROUP BY full_name, age
ORDER BY age

--AVG AGE OF PLAYERS FROM EACH NATIONALITY
SELECT DISTINCT(NATIONALITY), AVG(AGE) AS Average_Age, COUNT(NATIONALITY) AS No_Of_Players
FROM PlayersInfo
--WHERE nationality = (SELECT DISTINCT(nationality) FROM PlayersInfo)
GROUP BY nationality
ORDER BY 2 DESC

--SELECT THE YOUNGEST AND THE OLDEST PLAYER FROM EACH NATIONALITY
SELECT DISTINCT(NATIONALITY), MIN(AGE) AS YoungestPlayer, MAX(AGE) AS OldestPlayer, COUNT(NATIONALITY) AS TotalPlayers
FROM PlayersInfo
GROUP BY nationality
ORDER BY 2,3 DESC

--USING JOINS
--SELECT MIDFIELDERS WITH SHORT PASSING > 80

SELECT PlayersInfo.name, PlayersInfo.full_name, PlayersInfo.positions, PlayersAttributes.short_passing, 
COUNT(POSITIONS) OVER (PARTITION BY POSITIONS)
FROM PlayersInfo JOIN
PlayersAttributes
ON PlayersInfo.name = PlayersAttributes.name
WHERE positions LIKE '%M%' AND short_passing > 80
ORDER BY 1

--CASE STATEMENTS
--LABEL PLAYERS AS YOUNG WHEN BELOW 25, MATURE WHEN BELOW 30 AND VETERAN WHEN ABOVE 30
SELECT PlayersInfo.age, PlayersAttributes.*,
CASE
WHEN AGE <= 25 THEN 'YOUNG'
WHEN AGE > 25 AND AGE <= 30 THEN 'MATURE'
ELSE 'VETERAN'
END AS Player_Status
FROM PlayersInfo
JOIN PlayersAttributes
ON PlayersInfo.name = PlayersAttributes.name
ORDER BY age

--USING CTEs(COMMON TABLE EXPRESSIONS)
--SELECT PLAYERS FROM EACH NATIONALITY WITH THE HIGHEST SHOT POWER
WITH PLAYER_SHOT_POWER
AS
(SELECT PlayersInfo.name, PlayersInfo.nationality, PlayersAttributes.shot_power
FROM PlayersInfo
JOIN PlayersAttributes
ON PlayersInfo.name = PlayersAttributes.name
WHERE nationality = (SELECT DISTINCT(nationality) FROM PlayersInfo ) AND shot_power = (SELECT MAX(SHOT_POWER) FROM PlayersAttributes)
GROUP BY PlayersInfo.name, PlayersInfo.nationality, PlayersAttributes.shot_power
)
SELECT *
FROM PLAYER_SHOT_POWER


--USING TEMP TABLE
DROP TABLE IF EXISTS #PLAYERS
CREATE TABLE #PLAYERS
(
NATIONALITY VARCHAR(255),
NAME VARCHAR(255),
MAX_SHOT_POWER INT
)

INSERT INTO #PLAYERS
SELECT DISTINCT(PlayersInfo.nationality),PlayersInfo.name, MAX(PlayersAttributes.shot_power) AS MAX_SHOT_POWER
FROM PlayersInfo
JOIN PlayersAttributes
ON PlayersInfo.name = PlayersAttributes.name
GROUP BY PlayersInfo.name, PlayersAttributes.shot_power, PlayersInfo.nationality
HAVING COUNT(NATIONALITY) = 1 
ORDER BY 3 DESC

SELECT *
FROM #PLAYERS
ORDER BY 3 DESC

--CREATING VIEW FOR LATER VISUALIZATIONS
CREATE VIEW AVG_NO_PLAYERS AS
SELECT DISTINCT(NATIONALITY), AVG(AGE) AS Average_Age, COUNT(NATIONALITY) AS No_Of_Players
FROM PlayersInfo
--WHERE nationality = (SELECT DISTINCT(nationality) FROM PlayersInfo)
GROUP BY nationality
--ORDER BY 2 DESC






