-- Basic statistic discovery
SELECT MAX(total_laid_off) AS max_laid_off, 
	MIN(total_laid_off) AS min_laid_off, 
	AVG(total_laid_off) AS avg_laid_off, 
	MAX(percentage_laid_off) AS max_perc_laid_off, 
	MIN(percentage_laid_off) AS min_perc_laid_off,
	AVG(percentage_laid_off) AS avg_perc_laid_off,
	MAX(funds_raised_millions) AS max_funds_raised_millions, 
	MIN(funds_raised_millions) AS min_funds_raised_millions,
	AVG(funds_raised_millions) AS avg_funds_raised_millions
FROM layoffs_test;

/*  Column                    Number (Rounded for convenience)
    max_laid_off              12000	
    min_laid_off              3	
    avg_laid_off              237.266
    max_perc_laid_off         1.00	
    min_perc_laid_off         0.00	
    avg_perc_laid_off         0.258
    max_funds_raised_millions 0.00	
    min_funds_raised_millions 0.00	
    avg_funds_raised_millions 823.135
*/

-- Some noted a max percentage laid off as 1, or 100%. Looking at the counts of full layoffs in certain industries. Helped identify that the top 5 industry full layoffs included Food (13), Retail (13), Finance (12), Education (9), and Healthcare (7)
SELECT industry, COUNT(company) AS num_full_layoff
FROM layoffs_test
WHERE percentage_laid_off = 1
GROUP BY industry
ORDER BY num_full_layoff DESC;

-- Also looked at overall industry stats with number of layoffs per industry, their average laid off numbers, and the money raised
SELECT industry, COUNT(company) AS num_layoff, AVG(total_laid_off) AS avg_laid_off
FROM layoffs_test
GROUP BY industry
ORDER BY num_layoff DESC;

/* Found below stats by changing the order by to the necessary group
  -Finance, Retail, Healthcase, Transport, and Food make up the top 5 total laid off industries
  -Hardware, Consumer, Other, Fiutness, and Sales made up the top 5 in terms of avg laid off
  -Media, Transportation, Consumer, Real Estate, and Finance raised the most total money. Interestingly Media raised 509b, nearly twice as much as the number 2 spot while having 60% less layoffs
*/

-- Similar process to look at country, with the US having a staggering 1543 companies with layoffs over the #2 India with 148
SELECT country, COUNT(company) AS num_layoff, AVG(total_laid_off) AS avg_laid_off
FROM layoffs_test
GROUP BY country
ORDER BY num_layoff DESC;
