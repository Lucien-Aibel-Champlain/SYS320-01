function gatherClasses() {
    $page = Invoke-WebRequest -TimeoutSec 2 http://localhost/Courses-1.html

    #get all the <tr> in the document
    $trs = $page.ParsedHtml.body.getElementsByTagName("tr")

    #go through every tr and format it into a nice table
    $fullTable = @()
    for ($i=1; $i -lt $trs.length; $i++) { 
        $tds = $trs[$i].getElementsByTagName("td")

        #Seperate start time and end time
        $times = $tds[5].innerText.split("-")

        $fullTable += [pscustomobject]@{"Class Code" = $tds[0].innerText; `
                                        "Title" = $tds[1].innerText; `
                                        "Days" = daysTranslator($tds[4].innerText); `
                                        "Start Time" = $times[0]; `
                                        "End Time" = $times[1]; `
                                        "Instructor" = $tds[6].innerText; `
                                        "Location" = $tds[9].innerText;
                                        }

    }
    return $fullTable
}

function daysTranslator($dateString) {
    $days = @()
    if ($dateString -ilike "*M*") { $days += "Monday" }

    if ($dateString -match "T[WTF]") { $days += "Tuesday" }
    elseif ($dateString -ilike "*T*") { $days += "Tuesday" }

    if ($dateString -ilike "*W*") { $days += "Wednesday" }

    if ($dateString -ilike "*TH*") { $days += "Thursday" }

    if ($dateString -ilike "*F*") { $days += "Friday" }
    
    return $days
}