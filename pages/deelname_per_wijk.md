---
title: "Deelname per wijk"
---

Deze pagina toont de indicator *"% deelnemers per wijk van totaal aantal deelnemers per jaar"*  
voor elk team en jaar, als choroplethkaart over de wijken van Maastricht.

## Filters
```sql team_options
select distinct team
from participants_per_neighbourhood
order by team
```
```sql year_options
select distinct year
from participants_per_neighbourhood
order by year
```

<Dropdown 
  name=team 
  label="Team" 
  data={team_options} 
  value=team 
/>

<Dropdown
  data={year_options} 
  name=year
  value=year
  title="Selecteer een jaar"
/>


## Kaart: % deelnemers per wijk
```sql participants_map
select
  year,
  team,
  wijk_code,
  wijk_name,
  participants,
  share_of_total
from participants_per_neighbourhood
where year = ${inputs.year.value}
  and team = '${inputs.team.value}'
order by wijk_code
```

<AreaMap
  data={participants_map}
  areaCol=wijk_name
  geoJsonUrl="./maastricht_buurten.geojson"
  geoId=wijk_name
  value=share_of_total
  valueFmt=pct1
  title="Aandeel deelnemers per wijk – {inputs.team.value} ({inputs.year.value})"
  legend=true
  legendType=scalar
  height=650
  colorPalette={[
    ['#f3e5f5', '#f3e5f5'],
    ['#e1bee7', '#e1bee7'],
    ['#ce93d8', '#ce93d8'],
    ['#ba68c8', '#ba68c8'],
    ['#AC72AE', '#AC72AE']
  ]}   tooltip={[
    {id: 'wijk_name', showColumnName: false, valueClass: 'text-xl font-semibold'},
    {id: 'participants', title: 'Deelnemers', fmt: 'num0', fieldClass: 'text-[grey]', valueClass: 'text-[#00b050]'},
    {id: 'share_of_total', title: 'Aandeel', fmt: 'pct1', fieldClass: 'text-[grey]', valueClass: 'text-[#00b050]'}
  ]}
/>

## Details per wijk

<DataTable
  data={participants_map}
  title="Deelnemers per wijk – {inputs.team.value} ({inputs.year.value})"
>
  <Column id=wijk_name title="Wijk"/>
  <Column id=participants title="Deelnemers" fmt=num0/>
  <Column id=share_of_total title="Aandeel" fmt=pct1/>
</DataTable>