<!-- internal -->


$$$ chart
width: 400
height: 400
axis:
  x:
    type: block
    domain: quarter
  'y':
    type: range
    domain: profit
    step: 5
  c:
    type: grid3d
    domain:
      - sales
      - profit
  depth: 20
  degree: 30
brush:
  - type: column3d
    outerPadding: 10
    innerPadding: 5
widget:
  - type: title
    text: 3D Column Chart
  - type: tooltip
  - type: legend

| quarter | sales | profit |
|:------- |:----- |:------ |
| 2015/Q1 | 50    | 35     |
| 2015/Q2 | 20    | 100    |
| 2015/Q3 | 10    | 5      |
| 2015/Q4 | 30    | 25     |
$$$
