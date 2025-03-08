 {%macro date_spine(start_date, end_date) %}

 WITH RECURSIVE dates as (
  
  SELECT CAST('{{start_date}}' as DATE) as date
  UNION ALL
  SELECT DATE_ADD(date, INTERVAL 1 DAY)
  FROM dates
  WHERE date< CAST('{{end_date}}' as DATE)


 )

 select * from dates
 {% endmacro %}