-- participants_per_neighbourhood.sql
select
  year,
  team,
  wijk_code,
  wijk_name,
  participants,
  share_of_total
from participants_per_neighbourhood
order by year, team, wijk_code;