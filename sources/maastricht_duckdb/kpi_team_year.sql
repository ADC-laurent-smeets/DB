-- kpi_team_year.sql
select
  year,
  team,
  code as indicator_code,
  indicator_name,
  indicator_type,
  unit,
  measurement_text,
  value
from kpi_values
order by year, team, code;
