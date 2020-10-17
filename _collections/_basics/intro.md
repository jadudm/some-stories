---
title: Intro
layout: hello
permalink: /intro/
---

18F is required to earn ${{ site.data.constants.fixed }}M every year.

This story is not about why that is true. It simply *is*.

18F bills staff out at a rate of ${{ site.data.constants.hourly | times: 1000000 | fmt: "0d" }}/hour. 

How many hours do we need to bill in order to make ${{site.data.constants.fixed}}M?

<div class="grid-row">
    <div class="grid-col-12" style="display: flex; justify-content: center;">
       <div id="sliderHM"></div>
    </div>
</div>
<div class="grid-row">
    <canvas id="HM"></canvas>
</div>
<div class="grid-row" style="display: flex; justify-content: center; margin: 2em;">
    <div id="message" style="align: text-center;">
    &nbsp;
    </div>
</div>

{% include chart id="HM" %}
{% include slider id="HM" chart="HM" %}

<script>
    // https://coolors.co/5f0f40-9a031e-fb8b24-e36414-0f4c5c
    chartHM.data.datasets = [
        {
            data: [12],
            label: "The Overhead",
            backgroundColor: pattern.draw("square", "#5f0f40"), 
        },
        {
            data: [0],
            label: "The Income",
            backgroundColor: pattern.draw("circle", "#9a031e"),
        }
    ]
    chartHM.label = "";

    chartHM.options.title = { display: true, text: "How Many Hours?" };
    chartHM.options.legend = { display: true };

    function callback (val) {
        // Hours * Hourly rate / 1M (for scaling)
        var income = (val * {{ site.data.constants.hourly }});
        chartHM.data.datasets[1].data = [ income ];

        var message = "";
        if (income < {{ site.data.constants.fixed }}) {
            message = "Not there yet.";
        } else {
            message = String.fromCodePoint(0x1F4B5)
                + " We cleared the ${{ site.data.constants.fixed }}M with " 
                + Math.floor(val) 
                + " hours billed." 
                + String.fromCodePoint(0x1F4B5);
        }
        document.getElementById("message").innerHTML = message;
        chartHM.update();
    };

    sliderHM.setCallbacks(callback);
    sliderHM.value(1000);
    chartHM.update();
</script>


{% capture more %}
<p>
    The "tell me more" blocks expand on the visualizations. In theory, a good visualization tells the story in its entirety. That said, many of these visualizations are making assumptions and approximations, and may require some additional storytelling to provide context.
</p>

<p>
    In most organizations, "overheads" pay for things like rent, power, and plumbing. It is not clear to this storyteller what the ${{ site.data.constants.fixed }}M overhead pays for. I have theories. You are encouraged to talk amongst yourselves and imagine some of your own.
</p>

<p>
    When people talk about being "cost recoverable," clearing this overhead is what drives our concerns. 
</p>

<p>
    Another way to think of this fixed overhead is to imagine that 18F starts every fiscal year ${{ site.data.constants.fixed }}M in the hole. We must, then, earn our way back to "break even," or $0. 
</p>

{% endcapture %}
{% include tellme prompt="tell me more" more=more %}
