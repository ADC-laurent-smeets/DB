-- library_membership_by_age.sql
select
  year,
  age,
  population,
  members,
  membership_rate
from library_membership_by_age
order by year, age;
