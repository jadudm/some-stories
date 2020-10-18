---
title: Time
layout: hello
permalink: /time/
---

*If staff are working on hiring, they are not billing hours.*

Now, [what about staffing]({{ site.baseurl }}/staffing/)

<div class="grid-row" style="padding-top: 3em;">
    <div class="grid-col-12" style="display: flex; justify-content: center;">
        <p><small>Staff</small></p>
       <div id="sliderSH"></div>
    </div>
</div>
<div class="grid-row">
    <canvas id="SH"></canvas>
</div>
<div class="grid-row" style="display: flex; justify-content: center; margin: 2em;">
    <div id="message" style="align: text-center;">
    &nbsp;
    </div>
</div>

{% include chart id="SH" %}
{% include slider id="SH" chart="SH" %}

<script>
    // https://coolors.co/5f0f40-9a031e-fb8b24-e36414-0f4c5c
    chartSH.data.datasets = [
        {
            data: [12],
            label: "The Overhead",
            backgroundColor: pattern.draw("square", "#5f0f40"), 
        },
        {
            data: [0],
            label: "Net Income",
            backgroundColor: pattern.draw("circle", "#9a031e"),
        },
        {
            data: [0],
            label: "The Salaries",
            backgroundColor: pattern.draw("diamond", "#fb8b24")
        },
        {
            data: [ 0 ],
            label: "Hiring Backfill",
            backgroundColor: pattern.draw("zigzag-horizontal", "#0f4c5c")
        },
    ]
    chartSH.label = "";

    chartSH.options.title = { display: true, text: "How Many Staff?" };
    chartSH.options.legend = { display: true };

    function billedFromStaff (staff) {
        // Hours * Hourly rate / 1M (for scaling)
        var income = staff * (48 * 32 * {{ site.data.constants.hourly }});
        return income;
    }

    function salariesForStaff (staff) {
        var salaries = staff * (52 * 40 * {{ site.data.constants.salary }});
        return salaries;
    }

    function backfillCost (count) {
        return salariesForStaff(count);
    }

    function callback (staff) {
        // Calc hours from staff
        // Set the income.
        var income = billedFromStaff(staff);
        var salaries = salariesForStaff(staff);
        var hires = Math.ceil(staff * {{ site.data.constants.turnover }});
        var overheadHours = hires * {{ site.data.constants.onboarding }};
        var staffNeeded = Math.ceil(overheadHours / (48 * 32));
        var net = income - (salaries + backfillCost(staffNeeded) );

        chartSH.data.datasets[1].data = [  net ];
        chartSH.data.datasets[2].data = [ salaries ];
        chartSH.data.datasets[3].data = [ backfillCost(staffNeeded) ];

        var message = "";
        if (net < {{ site.data.constants.fixed }}) {
            message = "Not there yet.";
        } else {
            message = String.fromCodePoint(0x1F4B5)
                + "&nbsp; We cleared the ${{ site.data.constants.fixed }}M with " 
                + Math.ceil(staff) 
                + " staff and "
                + staffNeeded
                + " staff to cover hiring overheads. " 
                + String.fromCodePoint(0x1F4B5);
        }
        document.getElementById("message").innerHTML = message;
        chartSH.update();
    };

    sliderSH.min(0);
    sliderSH.max(100);
    sliderSH.setCallbacks(callback);
    containerSH.call(sliderSH);
    sliderSH.value(55);
    chartSH.update();
</script>

{% capture more %}
<p>
    Whenever there is work that 18F staff does that is non-billable, we fall short of achieving cost-recoverability. On one hand, we could consider this part of the 8 hours/week that staff have for innovation and growth. However, from a staff perspective, taking part in hiring neither 1) contributes to their personal growth nor 2) advances their billable projects. 
</p>

<p> 
    Therefore, I'm going to model all non-billable work as time that needs to be made up by additional billable staff time. This increases the number of staff we need to achieve cost recoverability.
</p>
<hr>
<p>
    An interview requires:
</p>

<ol>
    <li>
        Between 1-2 hours of phone work.
    </li>
    <li>
        An interview cycle, involving 5 hours of staff time.
    </li>
    <li>
        A report-out post-interview, another 5 hours of staff time.
    </li>
</ol>

<p>
    When new staff join, they typically have 80 hours of on-boarding time. This is non-billable.
</p>

<p>
    New staff require orientation, some of which is provided by staff. This is non-billable; call this another 10 hours (for the new hire and existing staff... so, 20 hours).
</p>

<p>
    A hire  (conservatively) hits the bottom line as {{ site.data.constants.onboarding }} hours of non-billable time.
</p>

<p>
    That time must be made up. Making up time means having people to do the work. 
</p>

<p>
    <b>I'm modeling time lost to hiring as time that must be made up by hiring additional staff.</b>
</p>

{% endcapture %}
{% include tellme prompt="the details of hiring" more=more %}
