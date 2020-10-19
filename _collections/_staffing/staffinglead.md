---
title: Staffing Lead
layout: hello
permalink: /staffinglead/
numberofstaff: 63
---

<style>
    .center {
        display: flex; 
        justify-content: center; 
        align-items: center;
    }
</style>
<!-- https://coolors.co/f94144-f3722c-f8961e-f9844a-f9c74f-90be6d-43aa8b-4d908e-577590-277da1 -->

<div class="grid-row">
    <div class="grid-col-1">
        <img src="{{ site.baseurl }}/images/avataaars/a14.png" />
    </div>
    <div class="grid-col-1"> </div>
    <div class="grid-col-10">
        <p>
            There are those at 18F who refer to staffing projects as "staffing Tetris™."
        </p>
        <p>
            The staffing lead must work with leadership and business development to make sure that we have staff available to take on projects when projects are ready to launch.
        </p>
        <p>
            <b>If we have too few staff, we cannot launch projects</b>. If we cannot launch projects, we cannot bill hours.
        </p>
    </div>
</div>

<hr>

<div class="grid-row" style="margin-top: 2em; margin-bottom: 2em;">
    <div class="grid-col-10">
        A year at 18F looks different for every member of staff. It is up to the staffing lead to organize and wrangle the designers, engineers, product managers, change and content strategists to successfully launch and complete projects with partners.
    </div>
</div>

<div id="staffers"> </div>

<script>
    function staffRow (ndx) {
        html = '<div class="grid-row" style="margin-top: 2em; margin-bottom: 2em;">'
            + '<div class="grid-col-1">'
            + '<img '
            + 'src="{{ site.baseurl }}/images/avataaars/a'
            + _.sample(_.range(14))
            + '.png"'
            + 'alt="An avatar."'
            + '/>'
            + '</div>'
            + '<div class="grid-col-1"> &nbsp; </div>'
            ;
        html += '<div id="staffrow' 
            + ndx 
            + '" class="grid-col-10" style="background: #fff; display: flex; flex-direction: row;">'
            ;
        html += generateSequence(ndx);
        html += '</div></div>';

        return html
    }
    function generateSequence(ndx) {
        html = "";
        weeks = 0;
        prev = null;
        prevcolor = "#000000";
        while (weeks <= 48) {
            next = _.sample([1, 2, 8, 10, 12]);
            while ((next == prev) || (prev == 1 && next == 2) || (prev == 2 && next == 1)) {
                next = _.sample([1, 2, 8, 10, 12]);
            }
            prev = next;
            weeks += next;
            if (next < 8) {
                // document.createElement("div");
                html += '<div class="center" style="width: ' 
                + (next * 2)
                + '%; background: #ccc; height: 100%; "><div><small>' 
                + next 
                + 'w</small></div></div>'
                ;
            } else {
                color = '#' + _.sample(
                    "f94144-f3722c-f8961e-f9844a-f9c74f-90be6d-43aa8b-4d908e-577590-277da1"
                    .split("-")
                );
                while(color == prevcolor) {
                    color = '#' + _.sample(
                        "f94144-f3722c-f8961e-f9844a-f9c74f-90be6d-43aa8b-4d908e-577590-277da1"
                        .split("-")
                        );
                }
                prevcolor = color;

                html += '<div class="center" style="width: '
                    + Math.floor((next / 48) * 100)
                    + '%; background: ' 
                    + color 
                    + '; height: 100%; "><div><small>' 
                    + next 
                    + 'w</small></div></div>'
                    ;
            }
        }
        return html;
    }

    for(ndx of _.range({{ page.numberofstaff }})) {
        newRow = staffRow(ndx);
        document.getElementById("staffers").insertAdjacentHTML('beforeend', newRow);
    }

</script>