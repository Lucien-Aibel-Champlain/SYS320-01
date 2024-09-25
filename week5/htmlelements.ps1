$scrapedPage = Invoke-WebRequest -TimeoutSec 10 http://localhost/toBeScraped.html

Write-Host "Displaying the number of links on the page"
$scrapedPage.Links.Count

Write-Host "Showing the link as an HTML element"
$scrapedPage.Links

Write-Host "Displaying only the URL and text"
$scrapedPage.Links | Select outerText, href

Write-Host "Getting the outer text of every h2 tag"
$h2s = $scrapedPage.ParsedHtml.body.getElementsByTagName("h2") | Select-Object outerText
$h2s

Write-Host "Printing innerText of all div elements of class div-1"
$divs1 = $scrapedPage.ParsedHtml.body.getElementsByTagName("div") | `
    where { $_.getAttributeNode("class").nodeValue -ilike "div-1" } `
    | Select innerText
$divs1