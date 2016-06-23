
$$$ chart
width: 800
height: 400
theme: dark
axis:
  padding:
    left: 5
    top: 10
  area:
    width: 80%
    x: 10%
  x:
    type: block
    domain: quarter
    line: true
  'y':
    type: range
    domain:
      - -120
      - 120
    step: 10
    line: true
    orient: right
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
    text: Column Chart
  - type: tooltip
  - type: legend

| quarter | sales | profit |
|:------- |:----- |:------ |
| 1Q      | 50    | 35     |
| 2Q      | -20   | -100   |
| 3Q      | 10    | -5     |
| 4Q      | 30    | 25     |
$$$
