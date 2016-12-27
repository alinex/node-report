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
    step: 10
    line: true
brush:
  - type: column
    target:
      - sales
      - profit
  - type: focus
    start: 1
    end: 1
widget:
  - type: title
    text: Column Chart with Focus
  - type: tooltip
  - type: legend

| quarter | sales | profit |
|:------- |:----- |:------ |
| 2015/Q1 | 50    | 35     |
| 2015/Q2 | 20    | 100    |
| 2015/Q3 | 10    | 5      |
| 2015/Q4 | 30    | 25     |
$$$
