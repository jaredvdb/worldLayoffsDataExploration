-- Create temp column to look at any duplicate values
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS dupl_count
FROM layoffs_test;

-- While I could search the column manually, filtering by only those who are more than 1 row count will reveal any true duplicates
WITH duplicate_layoffs AS (
	SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS dupl_count
	FROM layoffs_test
)
SELECT * 
FROM duplicate_layoffs
WHERE dupl_count > 1;

-- This gets the following companies, which I'll check each- ordering by the company name
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS dupl_count
FROM layoffs_test
WHERE company = 'Casper' OR company = 'Cazoo' OR company = 'Hibob' OR company = 'Wildlife Studios' OR company = 'Yahoo'
ORDER BY company

-- I was able to see some, i.e. Casper had 3 entries with the last 2 entries being complete duplicates. I'll move to keep one of each duplicate instance 
