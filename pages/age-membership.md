---
title: "Leeftijd & Bibliotheekleden"
---

# Leeftijdsverdeling en bibliotheekleden

Deze pagina toont:

- de **leeftijdsverdeling** van inwoners (per enkelvoudige leeftijd),  
- het **aandeel bibliotheekleden** per leeftijd.

---

## Selecteer jaar

```year_options
select distinct year
from population_individuals
order by year;
```


```bin_options
select 1 as bin
union all select 5
union all select 10
order by bin;
```

<Dropdown
    data={year_options} 
    name=year
    value=year
    title="Selecteer een jaar"
/>
<Dropdown 
     data={bin_options}
     name=agebin 
     value=bin
     title="Groepeer leeftijden per ..." 
/>



```membership_raw
select
  age,
  population,
  members
from library_membership_by_age
where year = '${inputs.year.value}'
```

```membership_binned_long
select
  floor(age / ${inputs.agebin.value}) * ${inputs.agebin.value} as age_bin,
  'Population' as group_name,
  sum(population) as value
from ${membership_raw}
group by age_bin

union all

select
  floor(age / ${inputs.agebin.value}) * ${inputs.agebin.value} as age_bin,
  'Members' as group_name,
  sum(members) as value
from ${membership_raw}
group by age_bin
```

<BarChart
data={membership_binned_long}
x=age_bin
y=value
series=group_name
type=grouped
xAxisTitle="Leeftijd (jaar)"
yAxisTitle="Aantal personen"
chartAreaHeight=300 
/>


```membership_share_raw
select
  age,
  population,
  members,
  case when population = 0 then 0 else members * 1.0 / population end as share_members
from library_membership_by_age
where year = '${inputs.year.value}'
```



```membership_share_binned
select
  floor(age / ${inputs.agebin.value}) * ${inputs.agebin.value} as age_bin,
  sum(population) as population,
  sum(members) as members,
  case
    when sum(population) = 0 then 0
    else sum(members)*1.0 / sum(population)
  end as share_members
from ${membership_share_raw}
group by age_bin
```

<LineChart
data={membership_share_binned}
x=age_bin
y=share_members
xAxisTitle="Leeftijd (jaar)"
yAxisTitle="Aandeel leden van populatie"
yFmt=pct1
chartAreaHeight=300 
/>