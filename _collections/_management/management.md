---
title: Wrangling Cats
layout: hello
permalink: /meow/
---


<div class="grid-row grid-gap">
    <div class="grid-col-6">
       <p>
           <em>Such a good commercial</em>. It's like Ansel Adams met the Pythons.
       </p>
        <p>
            Modeling so far suggests we're rolling around ${{ site.data.constants.fixed | times: 2 }}M/year. That's probably going to require some people keeping track of people.
        </p>
        <p>
            To start, let's assume some <b>full-time</b> management positions:
        </p>
        <ol>
            <li>Director of Ops</li>
            <li>Director of Engineering</li>
            <li>Director of Design and Content</li>
            <li>Director of Product and Strategy</li>
            <li><i>Solver of Problems</i></li>
        </ol>
        <p>
            I don't know what a "solver of problems" is, but every organization probably needs one.
        </p>
        <p>
            How many more staff do we need to cover the cost of having management?
        </p>
    </div>
    <div class="grid-col-6">
        <iframe width="100%" height="315" src="https://www.youtube.com/embed/m_MaJDK3VNE" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
    </div>
</div>


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
        var net = income - (salaries + wranglerCost(5));

        chartSH.data.datasets[1].data = [  net ];
        chartSH.data.datasets[2].data = [ salaries ];

        var message = "";
        if (net < {{ site.data.constants.fixed }}) {
            message = "Not there yet.";
        } else {
            message = String.fromCodePoint(0x1F4B5)
                + "&nbsp; We cleared the ${{ site.data.constants.fixed }}M with " 
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
    sliderSH.value(55);
    chartSH.update();
</script>

{% capture more %}

<p>
    Currently, 18F utilizes a model where 1) we rotate leadership positions, and 2) they are not full-time.
</p>

<p>
    I believe a good argument could be made that staff should "keep their toe in." That is, I think it is good for a Director of Engineering to still be engineeringing.
</p>

<p>
    However, I model management's time as if they are pure overhead. Modeling a Director as if they are 25% billable is too much detail, and ultimately is lost in the noise of reality.
</p>

<p>
    I think rotating leadership positions is an excellent idea. A better model might be to staff more junior members of staff to leadership positions, with the outgoing Director serving as a mentor. This would provide greater continuity. However, it likely requires that 18F finds a way to hire more 4/4 staff, and fewer 2/2s.
</p>


{% endcapture %}
{% include tellme prompt="on management" more=more %}
