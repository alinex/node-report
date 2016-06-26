
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

| year | europe | switzerland | us |
|:---- |:------ |:----------- |:-- |
| 2008 | 10     | 1           | 0  |
| 2009 | 60     | 3           | 0  |
| 2010 | 30     | 3           | 12 |
| 2011 | -60    | 4           | 15 |
| 2012 | 50     | 6           | 20 |
| 2013 | 30     | 5           | 35 |
| 2014 | 20     | 8           | 20 |
| 2015 | 100    | 0           | 0  |
$$$
