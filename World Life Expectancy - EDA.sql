# World Life Expectancy Project (Exploratory Data Analysis)

SELECT * 
FROM world_life_expectancy
;

# There is 0s for some countries that is a data quality issue, should be looked into when data cleaning
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years ASC
;

# the avg life expectancy for each year, as a total planet
SELECT Year, ROUND(AVG(`Life expectancy`), 2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

# Correlation between life expectancy and all the other columns
SELECT * 
FROM world_life_expectancy
;

# life expectancy vs gdp, found some correlation
SELECT Country, ROUND(AVG(`Life expectancy`), 1) AS Life_Exp, ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC
;

# show what the high gdp vs low gdp averages are
SELECT 
SUM(CASE WHEN GDP  >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP  >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP  <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP  <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_Expectancy
FROM world_life_expectancy
;

# the status of developing vs developed and their life expectancy, the count of both
SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`), 1) AS Life_Exp
FROM world_life_expectancy
GROUP BY Status
;

# looked at life expectancy vs bmi, positive correlation
SELECT Country, ROUND(AVG(`Life expectancy`), 1) AS Life_Exp, ROUND(AVG(BMI), 1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;

# Rolling Total: Gonna give us each of these rows,.. doing order by year to add them year after year, want it in a structured way
SELECT Country, 
Year, 
`Life expectancy`, 
`Adult Mortality`,
SUM(`Adult Mortality`) OVER (PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;
