---
title: KPI Dashboard
---

<Dropdown
    data={teams} 
    name=team
    value=team_name
    title="Selecteer een Team"
/>

-----

```sql latest_year
select max(year) as year from kpi_values
```

```sql total_partners
select sum(value) as total_value
from kpi_values
where code = '1a'
and year = (select max(year) from kpi_values where code = '1a')
```
```sql avg_identification
select round(avg(value), 1) as avg_value
from kpi_values
where code = '2b'
and year = (select max(year) from kpi_values where code = '2b')
```
```sql total_participants
select sum(value) as total_value
from kpi_values
where code = '3a'
and year = (select max(year) from kpi_values where code = '3a')
```
## Belangrijkste CC ({latest_year[0].year})

<Grid cols=3>
  <BigValue
    data={total_partners}
    value=total_value
    title="Totaal Partners"
  />
  
  <BigValue
    data={avg_identification}
    value=avg_value
    title="Gem. Beleving"
  />
  
  <BigValue
    data={total_participants}
    value=total_value
    title="Totaal Deelnemers"
  />
</Grid>


## Belangrijkste Cijfers - {inputs.team.value} 
```sql total_partners_team
select sum(value) as total_value
from kpi_values
where code = '1a'
and team = '${inputs.team.value}'
and year = (select max(year) from kpi_values where code = '1a')
```
```sql avg_identification_team
select round(avg(value), 1) as avg_value
from kpi_values
where code = '2b'
and team = '${inputs.team.value}'
and year = (select max(year) from kpi_values where code = '2b')
```
```sql total_participants_team
select sum(value) as total_value
from kpi_values
where code = '3a'
and team = '${inputs.team.value}'
and year = (select max(year) from kpi_values where code = '3a')
```

<Grid cols=3>
  <BigValue
    data={total_partners_team}
    value=total_value
    title="Partners"
  />
  
  <BigValue
    data={avg_identification_team}
    value=avg_value
    title="Gem. Beleving"
  />
  
  <BigValue
    data={total_participants_team}
    value=total_value
    title="Deelnemers"
  />
</Grid>



---

# KPI Dashboard voor {inputs.team.value}

```sql teams
select distinct team as team_name
from kpi_values
order by team
```



```sql team_color
select
  case
    when '${inputs.team.value}' = 'Bibliotheek' then '#AC72AE'
    when '${inputs.team.value}' = 'Educatie & Participatie' then '#94C356'
    when '${inputs.team.value}' = 'Musea' then '#E6CA47'
    else '#888888'
  end as color
```

## KPI Overzicht
```sql kpis_for_team
select
  code as indicator_code,
  indicator_name,
  indicator_short,
  case
    when indicator_name ilike '%partner%'   then 'Partnerschappen'
    when indicator_name ilike '%beleving%'  then 'Beleving & Kwaliteit'
    when indicator_name ilike '%aanbevel%'  then 'Beleving & Kwaliteit'
    when indicator_name ilike '%identific%' then 'Beleving & Inclusie'
    when indicator_name ilike '%represent%' then 'Inclusie & Representatie'
    when indicator_name ilike '%wijk%'      then 'Inclusie & Representatie'
    when indicator_name ilike '%deelnemer%' then 'Bereik & Deelname'
    when indicator_name ilike '%bereik%'    then 'Bereik & Deelname'
    when indicator_name ilike '%leden%'     then 'Bereik & Deelname'
    when indicator_name ilike '%gebruik%'   then 'Bereik & Deelname'
    else 'Overige'
  end as category,
  year,
  value
from kpi_values
where team = '${inputs.team.value}'
order by category, indicator_code, year
```
```sql kpi_1a
select year, value, indicator_name, indicator_short, category
from ${kpis_for_team}
where indicator_code = '1a'
order by year
```
```sql kpi_1a_all
select *
from kpi_values
where code = '1a'
order by team, year
```
```sql kpi_1b
select year, value, indicator_name, indicator_short, category
from ${kpis_for_team}
where indicator_code = '1b'
order by year
```
```sql kpi_1b_all
select *
from kpi_values
where code = '1b'
order by team, year
```
```sql kpi_6a
select year, value, indicator_name, indicator_short, category
from ${kpis_for_team}
where indicator_code = '6a'
order by year
```
```sql kpi_6a_all
select *
from kpi_values
where code = '6a'
order by team, year
```
```sql kpi_2a
select year, value, indicator_name, indicator_short, category
from ${kpis_for_team}
where indicator_code = '2a'
order by year
```
```sql kpi_2a_all
select *
from kpi_values
where code = '2a'
order by team, year
```
```sql kpi_2b
select year, value, indicator_name, indicator_short, category
from ${kpis_for_team}
where indicator_code = '2b'
order by year
```
```sql kpi_2b_all
select *
from kpi_values
where code = '2b'
order by team, year
```

<!-- NEW: Score distribution for donut chart (2b) -->
```sql score_distribution_team
select 
  score,
  count,
  percentage,
  case 
    when score >= 9 then 'Uitstekend (9-10)'
    when score >= 7 then 'Goed (7-8)'
    when score >= 5 then 'Voldoende (5-6)'
    else 'Onvoldoende (1-4)'
  end as score_category
from score_distribution_2b
where team = '${inputs.team.value}'
and year = (select max(year) from score_distribution_2b)
order by score
```

```sql score_categories_team
select 
  score_category as name,
  sum(count) as value
from (
  select 
    score,
    count,
    case 
      when score >= 9 then 'Uitstekend (9-10)'
      when score >= 7 then 'Goed (7-8)'
      when score >= 5 then 'Voldoende (5-6)'
      else 'Onvoldoende (1-4)'
    end as score_category
  from score_distribution_2b
  where team = '${inputs.team.value}'
  and year = (select max(year) from score_distribution_2b)
)
group by score_category
order by 
  case name
    when 'Uitstekend (9-10)' then 1
    when 'Goed (7-8)' then 2
    when 'Voldoende (5-6)' then 3
    else 4
  end
```

```sql score_categories_all
select 
  team,
  case 
    when score >= 9 then 'Uitstekend (9-10)'
    when score >= 7 then 'Goed (7-8)'
    when score >= 5 then 'Voldoende (5-6)'
    else 'Onvoldoende (1-4)'
  end as score_category,
  sum(count) as count,
  round(sum(percentage), 1) as percentage
from score_distribution_2b
where year = (select max(year) from score_distribution_2b)
group by team, score_category
order by team,
  case score_category
    when 'Uitstekend (9-10)' then 1
    when 'Goed (7-8)' then 2
    when 'Voldoende (5-6)' then 3
    else 4
  end
```

```sql kpi_2c
select year, value, indicator_name, indicator_short, category
from ${kpis_for_team}
where indicator_code = '2c'
order by year
```
```sql kpi_2c_all
select *
from kpi_values
where code = '2c'
order by team, year
```
```sql kpi_3a
select year, value, indicator_name, indicator_short, category
from ${kpis_for_team}
where indicator_code = '3a'
order by year
```
```sql kpi_3a_all
select *
from kpi_values
where code = '3a'
order by team, year
```

<!-- NEW: Monthly participants for line chart (3a) -->
```sql monthly_participants_team
select 
  date,
  year,
  month,
  month_name,
  participants,
  year_month
from monthly_participants_3a
where team = '${inputs.team.value}'
order by date
```

```sql monthly_participants_latest_year
select 
  month,
  month_name,
  participants
from monthly_participants_3a
where team = '${inputs.team.value}'
and year = (select max(year) from monthly_participants_3a)
order by month
```

```sql monthly_participants_all_teams
select 
  team,
  date,
  year,
  month,
  month_name,
  participants
from monthly_participants_3a
order by team, date
```

```sql monthly_participants_all_latest
select 
  team,
  month,
  month_name,
  participants
from monthly_participants_3a
where year = (select max(year) from monthly_participants_3a)
order by team, month
```

```sql kpi_3b
select year, value, indicator_name, indicator_short, category
from ${kpis_for_team}
where indicator_code = '3b'
order by year
```
```sql kpi_3b_all
select *
from kpi_values
where code = '3b'
order by team, year
```
```sql kpi_4a
select year, value, indicator_name, indicator_short, category
from ${kpis_for_team}
where indicator_code = '4a'
order by year
```
```sql kpi_4a_all
select *
from kpi_values
where code = '4a'
order by team, year
```
```sql kpi_4b
select year, value, indicator_name, indicator_short, category
from ${kpis_for_team}
where indicator_code = '4b'
order by year
```
```sql kpi_4b_all
select *
from kpi_values
where code = '4b'
order by team, year
```
```sql kpi_5a
select year, value, indicator_name, indicator_short, category
from ${kpis_for_team}
where indicator_code = '5a'
order by year
```
```sql kpi_5a_all
select *
from kpi_values
where code = '5a'
order by team, year
```

<Tabs fullWidth=true>
  <Tab label="Geselecteerd team">

   
# Partnerschappen

<Grid cols=2>
  <BarChart
    data={kpi_1a}
    x=year
    y=value
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Aantal Partners"
    fillColor={team_color[0].color}
  />
  
  <BarChart
    data={kpi_1b}
    x=year
    y=value
    xAxisTitle="Jaar"
    yAxisTitle="%"
    title="% via Partners"
    fillColor={team_color[0].color}
  />
  
  <BarChart
    data={kpi_6a}
    x=year
    y=value
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Partnernetwerken"
    fillColor={team_color[0].color}
  />
</Grid>

# Beleving & Inclusie

<Grid cols=2>
  <BarChart
    data={kpi_2a}
    x=year
    y=value
    xAxisTitle="Jaar"
    yAxisTitle="%"
    title="% Identificatie"
    fillColor={team_color[0].color}
  />
  
  <!-- Original average score bar chart -->
  <BarChart
    data={kpi_2b}
    x=year
    y=value
    xAxisTitle="Jaar"
    yAxisTitle="Score"
    title="Gem. Belevingsscore"
    fillColor={team_color[0].color}
  />
</Grid>

### Belevingsscores Verdeling ({latest_year[0].year})


<Grid cols=2>
  <!-- NEW: Donut chart showing score distribution -->
  <ECharts config={
  {
    tooltip: {
      formatter: '{b}: {c} ({d}%)'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [
      {
        type: 'pie',
        radius: ['40%', '70%'],
        itemStyle: {
          borderRadius: 10,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: {
          show: true,
          formatter: '{b}\n{d}%'
        },
        data: [...score_categories_team],
      }
    ]
  }
}/>
  
  <!-- Detailed score distribution bar chart -->
  <BarChart
    data={score_distribution_team}
    x=score
    y=count
    xAxisTitle="Score"
    yAxisTitle="Aantal"
    title="Scores per Punt"
    fillColor={team_color[0].color}
  />
</Grid>

# Beleving & Kwaliteit

<Grid cols=2>
  <BarChart
    data={kpi_2c}
    x=year
    y=value
    xAxisTitle="Jaar"
    yAxisTitle="%"
    title="% Aanbeveling"
    fillColor={team_color[0].color}
  />
</Grid>

# Bereik & Deelname

<Grid cols=2>
  <!-- Original yearly bar chart -->
  <BarChart
    data={kpi_3a}
    x=year
    y=value
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Deelnemers per Jaar"
    fillColor={team_color[0].color}
  />
  
  <BarChart
    data={kpi_3b}
    x=year
    y=value
    xAxisTitle="Jaar"
    yAxisTitle="%"
    title="% Impact"
    fillColor={team_color[0].color}
  />
</Grid>

### Deelnemers per Maand ({latest_year[0].year})

<!-- NEW: Monthly line chart showing summer dip -->
<LineChart
  data={monthly_participants_latest_year}
  x=month_name
  y=participants
  xAxisTitle="Maand"
  yAxisTitle="Deelnemers"
  title="Maandelijks Verloop"
  lineColor={team_color[0].color}
  markers=true
  sort=false
/>

### Deelnemers per Maand (Alle Jaren)

<LineChart
  data={monthly_participants_team}
  x=date
  y=participants
  xAxisTitle="Datum"
  yAxisTitle="Deelnemers"
  title="Maandelijks Verloop (2023-2026)"
  lineColor={team_color[0].color}
/>

# Inclusie & Representatie

<Grid cols=2>
  <BarChart
    data={kpi_4a}
    x=year
    y=value
    xAxisTitle="Jaar"
    yAxisTitle="%"
    title="% Representativiteit"
    fillColor={team_color[0].color}
  />
  
  <BarChart
    data={kpi_4b}
    x=year
    y=value
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Deelnemers/Wijk"
    fillColor={team_color[0].color}
  />
</Grid>

# Overige

<Grid cols=2>
  <BarChart
    data={kpi_5a}
    x=year
    y=value
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Bereik/Gebruik"
    fillColor={team_color[0].color}
  />
</Grid>

  </Tab>
  
  <Tab label="Teams vergelijken">

 
# Partnerschappen

<Grid cols=2>
  <BarChart
    data={kpi_1a_all}
    x=year
    y=value
    series=team
    type=grouped
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Aantal Partners"
  />
  
  <BarChart
    data={kpi_1b_all}
    x=year
    y=value
    series=team
    type=grouped
    xAxisTitle="Jaar"
    yAxisTitle="%"
    title="% via Partners"
  />
  
  <BarChart
    data={kpi_6a_all}
    x=year
    y=value
    series=team
    type=grouped
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Partnernetwerken"
  />
</Grid>

# Beleving & Inclusie

<Grid cols=2>
  <BarChart
    data={kpi_2a_all}
    x=year
    y=value
    series=team
    type=grouped
    xAxisTitle="Jaar"
    yAxisTitle="%"
    title="% Identificatie"
  />
  
  <BarChart
    data={kpi_2b_all}
    x=year
    y=value
    series=team
    type=grouped
    xAxisTitle="Jaar"
    yAxisTitle="Score"
    title="Gem. Belevingsscore"
  />
</Grid>

### Belevingsscores Verdeling per Team ({latest_year[0].year})

<BarChart
  data={score_categories_all}
  x=team
  y=count
  series=score_category
  type=stacked100
  xAxisTitle="Team"
  yAxisTitle="%"
  title="Score Verdeling per Team"
  colorPalette={['#22c55e', '#84cc16', '#eab308', '#ef4444']}
/>

# Beleving & Kwaliteit

<Grid cols=2>
  <BarChart
    data={kpi_2c_all}
    x=year
    y=value
    series=team
    type=grouped
    xAxisTitle="Jaar"
    yAxisTitle="%"
    title="% Aanbeveling"
  />
</Grid>

# Bereik & Deelname

<Grid cols=2>
  <BarChart
    data={kpi_3a_all}
    x=year
    y=value
    series=team
    type=grouped
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Deelnemers per Jaar"
  />
  
  <BarChart
    data={kpi_3b_all}
    x=year
    y=value
    series=team
    type=grouped
    xAxisTitle="Jaar"
    yAxisTitle="%"
    title="% Impact"
  />
</Grid>

### Deelnemers per Maand - Alle Teams ({latest_year[0].year})

<LineChart
  data={monthly_participants_all_latest}
  x=month
  y=participants
  series=team
  xAxisTitle="Maand"
  yAxisTitle="Deelnemers"
  title="Maandelijks Verloop per Team"
  markers=true
/>

# Inclusie & Representatie

<Grid cols=2>
  <BarChart
    data={kpi_4a_all}
    x=year
    y=value
    series=team
    type=grouped
    xAxisTitle="Jaar"
    yAxisTitle="%"
    title="% Representativiteit"
  />
  
  <BarChart
    data={kpi_4b_all}
    x=year
    y=value
    series=team
    type=grouped
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Deelnemers/Wijk"
  />
</Grid>

# Overige

<Grid cols=2>
  <BarChart
    data={kpi_5a_all}
    x=year
    y=value
    series=team
    type=grouped
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Bereik/Gebruik"
  />
</Grid>

  </Tab>
  
  <Tab label="Teams gestapeld">

 
# Partnerschappen

<Grid cols=2>
  <BarChart
    data={kpi_1a_all}
    x=year
    y=value
    series=team
    type=stacked
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Aantal Partners"
  />
  
  <BarChart
    data={kpi_6a_all}
    x=year
    y=value
    series=team
    type=stacked
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Partnernetwerken"
  />
</Grid>

# Beleving & Inclusie

<Grid cols=2>
  <BarChart
    data={kpi_2b_all}
    x=year
    y=value
    series=team
    type=stacked
    xAxisTitle="Jaar"
    yAxisTitle="Score"
    title="Belevingsscore"
  />
</Grid>

# Bereik & Deelname

<Grid cols=2>
  <BarChart
    data={kpi_3a_all}
    x=year
    y=value
    series=team
    type=stacked
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Deelnemers"
  />
</Grid>

# Inclusie & Representatie

<Grid cols=2>
  <BarChart
    data={kpi_4b_all}
    x=year
    y=value
    series=team
    type=stacked
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Deelnemers/Wijk"
  />
</Grid>

# Overige

<Grid cols=2>
  <BarChart
    data={kpi_5a_all}
    x=year
    y=value
    series=team
    type=stacked
    xAxisTitle="Jaar"
    yAxisTitle="Aantal"
    title="Bereik/Gebruik"
  />
</Grid>

  </Tab>
</Tabs>

## Table


<DataTable
data={bib_table_categorized}
groupBy=category
subtotals=false
totalRow=false
wrap=true
groupsOpen=true>
<Column id=category title="Categorie" />
<Column id=indicator_name title="Indicator" wrap=true width="340px" />
<Column id=y2023 title="2023" fmt="#,##0" />

<Column id=y2024 title="2024" fmt="#,##0" />
<Column id=delta_24_vs_23 title="Δ 24 vs 23" fmt="#,##0" contentType=delta />

<Column id=y2025 title="2025" fmt="#,##0" />
<Column id=delta_25_vs_24 title="Δ 25 vs 24" fmt="#,##0" contentType=delta />

<Column id=y2026 title="2026" fmt="#,##0" />

<Column id=delta_26_vs_25 title="Δ 26 vs 25" fmt="#,##0" contentType=delta />
</DataTable>


```kpi_pivot
select
  indicator_name,
  team,
  year,
  value
from kpi_team_year
```


```bib_table
select
  indicator_name,
  max(case when year = 2023 then value end) as y2023,
  max(case when year = 2024 then value end) as y2024,
  max(case when year = 2025 then value end) as y2025,
  max(case when year = 2026 then value end) as y2026
from ${kpi_pivot}
where team = '${inputs.team.value}'
group by indicator_name
```


```bib_table_categorized
select
  indicator_name,
  case
    when indicator_name ilike '%partner%'   then 'Partnerschappen'
    when indicator_name ilike '%beleving%'  then 'Beleving & Kwaliteit'
    when indicator_name ilike '%aanbevel%'  then 'Beleving & Kwaliteit'
    when indicator_name ilike '%identific%' then 'Beleving & Inclusie'
    when indicator_name ilike '%represent%' then 'Inclusie & Representatie'
    when indicator_name ilike '%wijk%'      then 'Inclusie & Representatie'
    when indicator_name ilike '%deelnemer%' then 'Bereik & Deelname'
    when indicator_name ilike '%bereik%'    then 'Bereik & Deelname'
    when indicator_name ilike '%leden%'     then 'Bereik & Deelname'
    when indicator_name ilike '%gebruik%'   then 'Bereik & Deelname'
    else 'Overige'
  end as category,
  y2023,
  y2024,
  y2025,
  y2026,
  -- absolute veranderingen t.o.v. vorig jaar
  y2024 - y2023 as delta_24_vs_23,
  y2025 - y2024 as delta_25_vs_24,
  y2026 - y2025 as delta_26_vs_25
from ${bib_table}
order by category, indicator_name;
```
