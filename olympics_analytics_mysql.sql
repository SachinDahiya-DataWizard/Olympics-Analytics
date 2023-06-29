#------------------------------------------ TABLES ----------------------------------------------------------
#Full data
SELECT * FROM sportsstats.athlete_events;
#Region table: This table stores information about regions participating in the Olympics.
SELECT * FROM sportsstats.noc_regions;
#Athlete table: This table stores information about individual athletes participating in the Olympics.
SELECT * FROM sportsstats.athlete;
#Country table: This table stores information about countries participating in the Olympics.
SELECT * FROM sportsstats.country; 
#Games Table: This table stores information about the Olympic Games. 
SELECT * FROM sportsstats.games;
#Sport table: Sport table: This table stores information about different sports in the Olympics.
SELECT * FROM sportsstats.sport;
#Event table: This table stores information about specific events within each sport.
SELECT * FROM sportsstats.event;
#Medal table: This table stores information about specific medals (gold, silver, bronze).
SELECT * FROM sportsstats.medal;
#------------------------------------------ QUERIES ----------------------------------------------------------
#Total records
SELECT 
    COUNT(*) AS total_records
FROM
    sportsstats.athlete;
#Total number of athletes
SELECT 
    COUNT(DISTINCT (ID)) AS total_athletes
FROM
    sportsstats.athlete; 
#Total number of athletes based on Gender
SELECT 
    CASE Sex
        WHEN 'F' THEN 'Females'
        WHEN 'M' THEN 'Males'
    END AS Gender,
    COUNT(DISTINCT (ID)) AS total_athletes
FROM
    sportsstats.athlete
GROUP BY Sex;
#Top 10 nations with the highest number of athletes 
SELECT 
    r.region AS Country,
    CASE
        WHEN a.NOC IN ('URS' , 'RUS', 'EUN') THEN 'RUS'
        WHEN a.NOC IN ('GER' , 'GDR', 'FRG', 'SAA') THEN 'GER'
        WHEN a.NOC IN ('AUS' , 'ANZ') THEN 'AUS'
        WHEN a.NOC IN ('CAN' , 'NFL') THEN 'CAN'
        ELSE a.NOC
    END AS NOC,
    COUNT(DISTINCT (ID)) AS total_athletes
FROM
    sportsstats.athlete_events AS a
        LEFT JOIN
    sportsstats.noc_regions AS r ON a.NOC = r.NOC
GROUP BY Country , NOC
ORDER BY total_athletes DESC
LIMIT 10;
#Athletes in Seasons
SELECT 
    Season, COUNT(DISTINCT (ID)) AS total_athletes
FROM
    sportsstats.games
GROUP BY Season;
#10 most popular Olympic sports among athletes 
SELECT 
    Sport, COUNT(DISTINCT (ID)) AS total_athletes
FROM
    sportsstats.sport
GROUP BY Sport
ORDER BY total_athletes DESC
LIMIT 10;
#Top 10 athletes earning the highest number of medals
SELECT 
    Name, COUNT(Medal) AS total_medals
FROM
    sportsstats.medal
WHERE
    Medal <> 'NA'
GROUP BY Name
ORDER BY total_medals DESC
LIMIT 10;
#Which countries have won the most Olympic medals overall?
SELECT 
    CASE
        WHEN a.NOC IN ('URS' , 'RUS', 'EUN') THEN 'RUS'
        WHEN a.NOC IN ('GER' , 'GDR', 'FRG', 'SAA') THEN 'GER'
        WHEN a.NOC IN ('AUS' , 'ANZ') THEN 'AUS'
        WHEN a.NOC IN ('CAN' , 'NFL') THEN 'CAN'
        ELSE a.NOC
    END AS NOC,
    r.region AS Country,
    COUNT(a.Medal) AS medal_count
FROM
    sportsstats.athlete_events AS a
        LEFT JOIN
    sportsstats.noc_regions AS r ON a.NOC = r.NOC
WHERE
    a.Medal <> 'NA'
GROUP BY NOC , Country
ORDER BY medal_count DESC
LIMIT 10;
#How has the medal distribution changed over time for different sports?
SELECT DISTINCT
    (Year), Sport, COUNT(Medal) AS medal_count
FROM
    sportsstats.athlete_events
WHERE
    Medal <> 'NA'
GROUP BY Year , Sport
ORDER BY Sport DESC , medal_count DESC;
#What are the most successful sports for a particular country?
SELECT 
    r.region AS Country,
    a.Sport AS Sport,
    COUNT(a.Medal) AS medal_count
FROM
    sportsstats.athlete_events AS a
        LEFT JOIN
    sportsstats.noc_regions AS r ON a.NOC = r.NOC
WHERE
    Medal <> 'NA'
GROUP BY Country , Sport
HAVING Country IN ('USA' , 'Russia',
    'Germany',
    'UK',
    'France',
    'Italy',
    'Sweden',
    'Canada',
    'Australia',
    'Hungary')
ORDER BY medal_count DESC;
#How has the participation of countries evolved over the years?
SELECT 
    r.region AS Country,
    a.NOC,
    a.Year,
    COUNT(DISTINCT (ID)) AS total_athletes
FROM
    sportsstats.athlete_events AS a
        LEFT JOIN
    sportsstats.noc_regions AS r ON a.NOC = r.NOC
GROUP BY a.NOC , Country , a.Year
ORDER BY total_athletes DESC;
#Countries with larger populations tend to win more Olympic medals.
SELECT 
    r.region AS Country,
    a.NOC,
    COUNT(DISTINCT (a.ID)) AS total_athletes,
    COUNT(Medal) AS medal_count
FROM
    sportsstats.athlete_events AS a
        LEFT JOIN
    sportsstats.noc_regions AS r ON a.NOC = r.NOC
WHERE
    Medal <> 'NA'
GROUP BY Country , a.NOC
HAVING Country IN ('China' , 'India',
    'USA',
    'Indonesia',
    'Pakistan',
    'Brazil',
    'Nigeria',
    'Bangladesh',
    'Russia',
    'Mexico')
ORDER BY total_athletes DESC , medal_count DESC;
#Athletes' age and experience impact their chances of winning medals.
SELECT 
    Name, Age, COUNT(Medal) AS medal_count
FROM
    sportsstats.athlete_events
WHERE
    Medal <> 'NA'
GROUP BY Age , Name
HAVING Name IN ('Michael Fred Phelps, II' , 'Larysa Semenivna Latynina (Diriy-)',
    'Nikolay Yefimovich Andrianov',
    'Ole Einar Bjrndalen',
    'Edoardo Mangiarotti',
    'Takashi Ono',
    'Borys Anfiyanovych Shakhlin',
    'Jennifer Elisabeth "Jenny" Thompson (-Cumpelik)',
    'Dara Grace Torres (-Hoffman, -Minas)',
    'Ryan Steven Lochte')
ORDER BY Name , Age ASC;
#There is a correlation between a country's GDP (economic strength) and its Olympic success.
SELECT 
    r.region AS Country, a.NOC, COUNT(Medal) AS medal_count
FROM
    sportsstats.athlete_events AS a
        LEFT JOIN
    sportsstats.noc_regions AS r ON a.NOC = r.NOC
WHERE
    Medal <> 'NA'
GROUP BY Country , a.NOC
HAVING Country IN ('USA' , 'China',
    'Japan',
    'Germany',
    'UK',
    'India',
    'France',
    'Italy',
    'Canada',
    'South Korea')
ORDER BY medal_count DESC;
