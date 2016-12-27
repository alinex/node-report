<!-- internal -->


$$$ chart
width: 400
height: 400
axis:
  'y':
    type: block
    domain: quarter
    line: 'true'
  x:
    type: range
    domain: profit
    line: rect
brush:
  - type: bar
    size: 15
    target:
      - sales
      - profit
    innerPadding: 10
widget:
  - type: title
    text: Bar Chart
  - type: legend
  - type: tooltip

| quarter | sales | profit |
|:------- |:----- |:------ |
| 2015/Q1 | 50    | 35     |
| 2015/Q2 | 20    | 100    |
| 2015/Q3 | 10    | 5      |
| 2015/Q4 | 30    | 25     |
$$$
