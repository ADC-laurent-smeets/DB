select
  m.year,
  m.age_group,
  m.members,
  m.population,
  m.members * 1.0 / m.population as membership_rate
from library_membership_by_age 
order by m.year, m.age_group