
$$$ chart
width: 400
height: 400
axis:
  x:
    type: fullblock
    domain: year
    line: solid gradient
  'y':
    type: range
    domain:
      - -100
      - 100
    step: 10
    line: gradient dashed
brush:
  - type: area
    symbol: curve
    target:
      - europe
      - switzerland
      - us
widget:
  - type: title
    text: Area Chart
  - type: legend

| quarter | sales | profit |
|:------- |:----- |:------ |
| 2015/Q1 | 50    | 35     |
| 2015/Q2 | 20    | 100    |
| 2015/Q3 | 10    | 5      |
| 2015/Q4 | 30    | 25     |
$$$
