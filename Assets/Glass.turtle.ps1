Push-Location $PSScriptRoot
$glassTurtle = turtle id Glass ViewBox 1080 turtles @(
    turtle start (1080 * 3/8) (1080 * 3/8) square (1080/2) fill '#4488ff' stroke '#224488' PathClass 'brightBlue-fill blue-stroke' PathAttribute @{opacity='.5'}
    turtle start (
        (1080 * 5/8)
    ) (
        (1080 * 5/8)
    ) square (-1080/2) fill '#4488ff' stroke '#224488' PathClass 'brightBlue-fill blue-stroke' PathAttribute @{opacity='.75'}
    turtle style "@import url('https://fonts.googleapis.com/css?family=Abel')" text "Glass" textAttribute ([Ordered]@{
        x='50%'
        y='50%'
        'font-size' = '3em'
        'font-family' = 'Abel'
        fill='#224488'
        class='blue-fill'
    })
)
$glassTurtle | Save-Turtle ./Glass.svg
$glassTurtle | Save-Turtle ./Glass.png

${3/8} = 1080 * 3/8
${1/4} = 1080 * 1/4
${5/8} = 1080 * 5/8
${3/4} = 1080 * 3/4
${1/2} = 1080 * 1/2

$glassTurtleMorph = turtle id Glass ViewBox 1080 turtles @(
    turtle fill '#4488ff' stroke '#224488' PathClass 'brightBlue-fill blue-stroke' PathAttribute @{opacity='.5'} morph @(
        turtle start ${3/8} ${3/8} square ${1/2}
        turtle start ${1/4} ${1/4} square ${1/2}
        turtle start ${3/8} ${3/8} square ${1/2}
    )
    turtle fill '#4488ff' stroke '#224488' PathClass 'brightBlue-fill blue-stroke' PathAttribute @{opacity='.75'} morph @(
        turtle start ${5/8} ${5/8} square (${1/2} * -1)
        turtle start ${3/4} ${3/4} square (${1/2} * -1)
        turtle start ${5/8} ${5/8} square (${1/2} * -1)
    )
    turtle style "@import url('https://fonts.googleapis.com/css?family=Abel')" text "Glass" textAttribute ([Ordered]@{
        x='50%'
        y='50%'
        'font-size' = '3em'
        'font-family' = 'Abel'
        fill='#224488'
        class='blue-fill'
    })
)

$glassTurtleMorph | Save-Turtle ./Glass-Animated.svg

Pop-Location