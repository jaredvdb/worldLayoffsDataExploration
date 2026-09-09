-- Create raw placeholder table in Postgre roughly matching the observed columns in the layoffs.csv file
CREATE TABLE layoffs_raw (
  company VARCHAR(50),
  location VARCHAR(50),
  industry VARCHAR(50),
  total_laid_off NUMERIC(10,3),
  percentage_laid_off NUMERIC(10,3),
  "date" date,
  stage VARCHAR(50),
  country VARCHAR(50),
  funds_raised_millions NUMERIC(10,3)
);

-- After importing data in Postgre, make a similar placeholder table for testing purposes (making sure we aren't changing the ACTUAL dataset while exploring)
CREATE TABLE layoffs_test (LIKE layoffs_raw INCLUDING ALL);

-- Copy over data, this also gives the opportunity to rearrange columns if need be
INSERT INTO layoffs_test (company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions)
SELECT company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
FROM layoffs_raw;
