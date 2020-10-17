---
title: Sixty-Six
layout: hello
permalink: /66/
---

**Sixty-six thousand hours**.

At first glance, it seems like 18F needs to bill 66kh (66 kilohours) to be fully cost recoverable.

How many staff do we need to bill 66kh in a year?

<div class="grid-row">
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
        }
    ]
    chartSH.label = "";

    chartSH.options.title = { display: true, text: "How Many Staff?" };
    chartSH.options.legend = { display: true };

    function incomeFromHours (hrs) {
        // Hours * Hourly rate / 1M (for scaling)
        var income = (hrs * {{ site.data.constants.hourly }});
        return income;
    }

    function salariesFromHours (hrs) {
        var salaries = (hrs * {{ site.data.constants.salary }});
        return salaries;
    }

    function callback (staff) {
        // Calc hours from staff
        hrs = staff * 52 * 40;
        // Set the income.
        var income = incomeFromHours(hrs);
        var salaries = salariesFromHours(hrs);
        var net = income - salaries;

        chartSH.data.datasets[1].data = [  net ];
        chartSH.data.datasets[2].data = [ salaries ];

        var message = "";
        if (net < {{ site.data.constants.fixed }}) {
            message = "Not there yet.";
        } else {
            message = String.fromCodePoint(0x1F4B5)
                + " We cleared the ${{ site.data.constants.fixed }}M with " 
                + Math.floor(staff) 
                + " staff. " 
                + String.fromCodePoint(0x1F4B5);
        }
        document.getElementById("message").innerHTML = message;
        chartSH.update();
    };

    sliderSH.min(0);
    sliderSH.max(100);
    sliderSH.setCallbacks(callback);
    containerSH.call(sliderSH);
    sliderSH.value(5);
    chartSH.update();
</script>

{% capture more %}

<p>
From <a href="https://www.youtube.com/watch?v=d4ftmOI5NnI"><em>The Princess Bride</em></a>:
</p>

<blockquote style="background: #DDDDDD; padding: 1em;">
<b>Miracle Max</b>: Sonny, true love is the greatest thing in the world... But that's not what he said! He distinctly said "to blave." And, as we all know, "to blave" means "to bluff," huh?
</blockquote>

<p>
    This visualization is true if staff bill all 52 weeks per year, 40 hours every week.
</p>

<p>
    That is, it is only true if no one has any time off, there are no gaps of any sort in billing. Put simply, there is <b>zero</b> non-billable time.
</p>

<p>
    Anyone who thinks this is a good idea is welcome to take a job at a startup, or any job in education, where endless hours are considered the norm.
</p>

{% endcapture %}
{% include tellme prompt="<em>tu blave</em>" more=more %}
