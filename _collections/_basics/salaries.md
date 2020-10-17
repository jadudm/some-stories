---
title: Salaries
layout: hello
permalink: /salaries/
---


Staff, it turns out, like to be paid.

Assuming GS15 step 1 (GS15s1):

1. with an upward regional adjustment of 20%, and 
2. 65% overheads (meaning the costs of healthcare, retirement, and so forth), 

we come up with an hourly rate of ${{ site.data.constants.salary | times: 1000000 | fmt: "0d" }}/hour.

If we bill ${{ site.data.constants.hourly | times: 1000000 | fmt: "0d" }}/hour, and pay people ${{ site.data.constants.salary | times: 1000000 | fmt: "0d" }}/hour, how many hours of work do we need to bill in order to be cost recoverable?

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
            label: "Net Income",
            backgroundColor: pattern.draw("circle", "#9a031e"),
        },
        {
            data: [0],
            label: "The Salaries",
            backgroundColor: pattern.draw("diamond", "#fb8b24")
        }
    ]
    chartHM.label = "";

    chartHM.options.title = { display: true, text: "How Many Hours?" };
    chartHM.options.legend = { display: true };

    function incomeFromHours (hrs) {
        // Hours * Hourly rate / 1M (for scaling)
        var income = (hrs * {{ site.data.constants.hourly }});
        return income;
    }

    function salariesFromHours (hrs) {
        var salaries = (hrs * {{ site.data.constants.salary }});
        return salaries;
    }

    function callback (hrs) {
        // Set the income.
        var income = incomeFromHours(hrs);
        var salaries = salariesFromHours(hrs);
        var net = income - salaries;

        chartHM.data.datasets[1].data = [  net ];
        chartHM.data.datasets[2].data = [ salaries ];

        var message = "";
        if (net < {{ site.data.constants.fixed }}) {
            message = "Not there yet.";
        } else {
            message = String.fromCodePoint(0x1F4B5)
                + " We cleared the ${{ site.data.constants.fixed }}M with " 
                + Math.floor(hrs) 
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
    There's a few <b>assumptions</b> made in this slide.
</p>

<p>
    First, not everyone is GS15s1. Some are GS14s. Some are above step one. <b>For all of the models in this story, I am assuming everyone is GS15s1</b>. This will introduce (some) error into the model, but it's a good first approximation.
</p>

<p>
    Second, not everyone sees a 20% regional adjustment. Some see less. Some see more. However, many 18F employees tend to be centered in areas where there is an adjustment of some sort. <b>By applying (some) regional adjustment upward, I approximate real salaries</b>.
</p>

<p>
    Finally, I do not know for certain if we have a 65% overhead. <b>Based on other numbers I have seen, this seems like a good approximation</b>. It is in keeping with other organizations I have been a part of.   
</p>

{% endcapture %}
{% include tellme prompt="several assumptions..." more=more %}
