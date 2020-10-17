---
title: More Wranglers
layout: hello
permalink: /moremeow/
---

I'll take this one step further.

How about, along with director-level positions, we have one "group lead" for every 20 people. 

Some mid-level wranglers to provide touchstones for mentorship, learning, cohesion, and the like are probably necessary.

What does that do to the picture?


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
            data: [ wranglerCost(5) ],
            label: "The Wranglers",
            backgroundColor: pattern.draw("zigzag-horizontal", "#e36414")
        }
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

    function wranglerCost (count) {
        return salariesForStaff(count);
    }

    function callback (staff) {
        // Calc hours from staff
        // Set the income.
        var income = billedFromStaff(staff);
        var salaries = salariesForStaff(staff);
        var leads = Math.ceil(staff / 20);
        var net = income - (salaries + wranglerCost(5) + wranglerCost(leads));

        chartSH.data.datasets[1].data = [  net ];
        chartSH.data.datasets[2].data = [ salaries ];
        chartSH.data.datasets[3].data = [ wranglerCost(5 + leads) ];

        var message = "";
        if (net < {{ site.data.constants.fixed }}) {
            message = "Not there yet.";
        } else {
            message = String.fromCodePoint(0x1F4B5)
                + " We cleared the ${{ site.data.constants.fixed }}M with " 
                + Math.ceil(staff) 
                + " staff and "
                + Math.ceil(5 + leads)
                + " wranglers. " 
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
    This increases 18F's overhead burden. We went from needing 55 staff to 63 staff, and we carry 9 wranglers as a result.
</p>

<p>
    If this feels like "too much management," that's OK. It's a model, and by <em>over-estimating</em> management costs, my result is a conservative estimate of what it takes to achieve cost recoverability.
</p>

{% endcapture %}
{% include tellme prompt="yet more management" more=more %}
