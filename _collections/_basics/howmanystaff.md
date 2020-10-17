---
title: How Many Staff?
layout: hello
permalink: /howmany/
---

Let's ask the question another way.

If we need to bill 66kh in a year to clear ${{ site.data.constants.fixed }}M, how many staff is that *depending on how many weeks and hours the staff work*?

If staff bill 52 weeks/year, 40h/week, we apparently need 32 staff to dig out of the hole.

If staff work <b><span id="weeksperyear"></span> weeks/year</b>, and bill <b><span id="hoursperweek"></span> hours/week</b>, we need <b><span id="staffneeded"></span> staff</b> to clear the fixed overhead.

<div class="grid-row">
    <div class="grid-col-6" style="display: flex; justify-content: center;">
        <p><small>Weeks/Year</small></p>
       <div id="sliderWY"></div>
    </div>
    <div class="grid-col-6" style="display: flex; justify-content: center;">
        <p><small>Hours/Week</small></p>
       <div id="sliderHW"></div>
    </div>
</div>
<div class="grid-row">
    <canvas id="HMS"></canvas>
</div>
<div class="grid-row" style="display: flex; justify-content: center; margin: 2em;">
    <div id="message" style="align: text-center;">
    &nbsp;
    </div>
</div>

{% include chart id="HMS" %}
{% include slider id="WY" width="200" %}
{% include slider id="HW" width="200" %}

<script>
    // https://coolors.co/5f0f40-9a031e-fb8b24-e36414-0f4c5c
    chartHMS.data.datasets = [
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
    chartHMS.label = "";

    chartHMS.options.title = { display: true, text: "How Many Staff?" };
    chartHMS.options.legend = { display: true };

    chartHMS.update();
</script>

<!-- Setup sliders -->
<script>
    const billing = {{ site.data.constants.hourly }};
    const salary = {{ site.data.constants.salary }};

    function incomeFromStaff (staff, weeks, hours) {
        // Hours * Hourly rate / 1M (for scaling)
        var income = staff * (weeks * hours * {{ site.data.constants.hourly }});
        return income;
    }

    function salariesForStaff (staff) {
        var salaries = staff * (52 * 40 * {{ site.data.constants.salary }});
        return salaries;
    }

    function callback (_) {
        // Get the slider values
        var weeks = sliderWY.value();
        var hours = sliderHW.value();
        // To clear $12M, we need to find out how many 
        // staff at this billing rate are needed.
        // net = income - salaries
        // income = (weeks * hours) * staff * billing
        // salaries = (52 * 40) * staff * hourly
        // net = ((weeks * hours * billing) - (52 * 40 * hourly)) * staff
        // 12 / ((weeks * hours * billing) - (52 * 40 * hourly)) = staff
        var staff = Math.ceil(12 / ((weeks * hours * billing) - (52 * 40 * salary)));
        
        var salaries = salariesForStaff(staff);
        var income = incomeFromStaff(staff, weeks, hours)
        var net = income - salaries;
        // Set the divs.
        document.getElementById("weeksperyear").innerHTML = weeks;
        document.getElementById("hoursperweek").innerHTML = hours;
        document.getElementById("staffneeded").innerHTML = staff;

        chartHMS.data.datasets[1].data = [  net ];
        chartHMS.data.datasets[2].data = [ salaries ];

        var message = "";
        if (net <= {{ site.data.constants.fixed }}) {
            message = "Not there yet.";
        } else {
            message = String.fromCodePoint(0x1F4B5)
                + " We cleared the ${{ site.data.constants.fixed }}M with " 
                + Math.floor(staff) 
                + " staff. " 
                + String.fromCodePoint(0x1F4B5);
        }
        document.getElementById("message").innerHTML = message;
        chartHMS.update();
    };

    sliderWY.ticks(8);
    sliderWY.min(30);
    sliderWY.max(52);
    sliderWY.setCallbacks(callback);
    containerWY.call(sliderWY);
    sliderWY.value(22);

    sliderHW.min(28);
    sliderHW.max(40);
    sliderHW.setCallbacks(callback);
    containerHW.call(sliderHW);
    sliderHW.value(30);
</script>


{% capture more %}

<p>
    We are not going to work 18F staff 52 weeks/year.
</p>

<p>
    If everyone takes their full PTO every year, that's two weeks. So, the maximum number of weeks/year we should consider possible for a staff member to bill time is 50. However, there's more to reality. For example, there's a lot of slowdown around the winter holidays; does that mean there are fewer billable weeks in the year? 
</p>

<p>
    Also, staff with more years in the federal government will accrue PTO at a faster rate, meaning they have anywhere from 2-10 weeks/year they can potentially take off. Parental leave and administrative leave also reduce the number of weeks that staff might bill. 
</p>

<p>
    For now, it would be good to <b>revisit the model and see how many staff we need (at the minimum) if we are billing fewer than 50 weeks/year</b>.
</p>

<p>
    In terms of hours/week, we hire people at the top of their field, and we are attempting to foster a culture of change and innovation within the federal government. <b>This is very hard work, and easily leads to burnout</b>. If we want our staff to be change-makers and innovators, we need to create a healthy space for collaboration and continued learning in community with others. 
</p>

<p>
    An innovative, high-performing workforce needs to bill fewer than 40 hrs/week. <b>32/hours week</b> is a <em>completely reasonable choice</em>. 
</p>

<p>
    Failure to create space for change and innovation materially damages the people who work at 18F, the organization's culture, and quality of work we do.
</p>

{% endcapture %}
{% include tellme prompt="how many weeks, really..." more=more %}
