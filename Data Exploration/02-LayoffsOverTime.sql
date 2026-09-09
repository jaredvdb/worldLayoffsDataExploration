-- Finding the amount of companies that counted a layoff by year/month (excluding those who didn't include a date, reminder of March 2020 - March 2023)
SELECT TO_CHAR(date, 'MM') AS month, TO_CHAR(date, 'YYYY') AS year, COUNT(company) AS companies_laid_off 
FROM layoffs_test
WHERE date IS NOT NULL
GROUP BY year, month
ORDER BY year, month;

-- I wanted to see this summed up month over month, but reset by the year. Comparing the output below with the output above (but removing any instance of month) helped determine this was accurate. Also interesting to see that 466 companies reported layoffs in 2023, while only 44 were in 2021 (by March due to the mentioned date frame)
WITH rolling_total AS (
	SELECT TO_CHAR(date, 'MM') AS month, TO_CHAR(date, 'YYYY') AS year, COUNT(company) AS companies_laid_off
	FROM layoffs_test
	WHERE date IS NOT NULL
	GROUP BY year, month
	ORDER BY year, month
)
SELECT year, month, SUM(companies_laid_off) OVER(PARTITION BY year ORDER BY month) AS rolling_total
FROM rolling_total;
