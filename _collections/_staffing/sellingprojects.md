---
title: We Sell Projects
layout: hello
permalink: /sellingprojects/
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
    <div class="grid-col-4">
        <p>
            As we engage in these projects (path analyses, exploration and iteration, etc.), we invoice time and bill against the project.
        </p>
        <p>
            Cost recoverability comes through billing hours on projects. <b>The knob is projects, not people</b>.
        </p>
    </div>
    <div class="grid-col-8 center">
        <table class="usa-table">
            <tr>
                <td> <b>Engagement</b> </td>
                <td> <b> Abbr. </b> </td>
                <td> <b>Duration</b> </td>
                <td> <b>Staff</b> </td>
                <td> <b>Value</b> </td>
            </tr>
            {% for eng in site.data.constants.engagements %}
                <tr>
                    <td> {{ eng[1].name }} </td>
                    <td> {{ eng[1].abbr }} </td>
                    <td> {{ eng[1].duration }}w </td>
                    <td> {{ eng[1].staff.low }}-{{ eng[1].staff.high }} </td>
                    <td> {{ eng[1].value | times: 1000 | to_integer }}K </td>
                </tr>
            {% endfor %}
        </table>
    </div>
</div>


<div class="grid-row">
    <div class="grid-col-4 center">
    <small>PAs</small>
       <div id="sliderPA"></div>
    </div>
    <div class="grid-col-4 center">
    <small>EIs</small>
       <div id="sliderEI"></div>
    </div>
    <div class="grid-col-4 center">
    <small>Bundles</small>
       <div id="sliderBU"></div>
    </div>
</div>
<div class="grid-row">
    <canvas id="ST"></canvas>
</div>
<div class="grid-row" style="display: flex; justify-content: center; margin: 2em;">
    <div id="message" style="align: text-center;">
    &nbsp;
    </div>
</div>

<em>Remember, there's no wranglers or other overheads calculated in to this picture.</em>

{% include chart id="ST" %}
{% include slider id="PA" %}
{% include slider id="EI" %}
{% include slider id="BU" %}

<script>
    // https://coolors.co/5f0f40-9a031e-fb8b24-e36414-0f4c5c
    chartST.data.datasets = [
        {
            data: [12],
            label: "The Overhead",
            backgroundColor: pattern.draw("square", "#5f0f40"), 
        },
        {
            data: [0],
            label: ["Low Staff"],
            backgroundColor: [ pattern.draw("zigzag", "#9a031e") ]
        },
        {
            data: [0],
            label: ["High Staff"],
            backgroundColor: [ pattern.draw("zigzag-vertical", "#FA0F3A") ]

        },
        {
            data: [0],
            label: "Salaries (Low Staff)",
            backgroundColor: pattern.draw("triangle", "#fb8b24")
        },
        {
            data: [0],
            label: "Salaries (High Staff)",
            backgroundColor: pattern.draw("triangle-inverted", "#FBA04B")
        }

    ]
    chartST.label = "";

    chartST.options.title = { display: true, text: "How Many Hours?" };
    chartST.options.legend = { display: true };

    function incomeFromHours (hrs) {
        // Hours * Hourly rate / 1M (for scaling)
        var income = (hrs * {{ site.data.constants.hourly }});
        return income;
    }

    function salariesFromHours (hrs) {
        var salaries = (hrs * {{ site.data.constants.salary }});
        return salaries;
    }

    function callback (_) {
        var PAs = sliderPA.value();
        var EIs = sliderEI.value();
        var BUs = sliderBU.value();
        var hoursLow = ((
            PAs 
            * {{ site.data.constants.engagements.PA.staff.low }} 
            * {{ site.data.constants.engagements.PA.duration }} 
            * {{ site.data.constants.hoursperweek }}
            ) +
            (
            EIs 
            * {{ site.data.constants.engagements.EI.staff.low }} 
            * {{ site.data.constants.engagements.EI.duration }} 
            * {{ site.data.constants.hoursperweek }}
            ) +
            (
            BUs 
            * {{ site.data.constants.engagements.BU.staff.low }} 
            * {{ site.data.constants.engagements.BU.duration }} 
            * {{ site.data.constants.hoursperweek }}
            )
            );

        var hoursHigh = ((
            PAs 
            * {{ site.data.constants.engagements.PA.staff.high }} 
            * {{ site.data.constants.engagements.PA.duration }} 
            * {{ site.data.constants.hoursperweek }}
            ) +
            (
            EIs 
            * {{ site.data.constants.engagements.EI.staff.high }} 
            * {{ site.data.constants.engagements.EI.duration }} 
            * {{ site.data.constants.hoursperweek }}
            ) +
            (
            BUs 
            * {{ site.data.constants.engagements.BU.staff.high }} 
            * {{ site.data.constants.engagements.BU.duration }} 
            * {{ site.data.constants.hoursperweek }}
            )
            );

        var salariesLow = hoursLow * {{ site.data.constants.salary }};
        var salariesHigh = hoursHigh * {{ site.data.constants.salary }};

        var billed = (PAs * {{ site.data.constants.engagements.PA.value }}) 
            + (EIs * {{ site.data.constants.engagements.EI.value }})
            + (BUs * {{ site.data.constants.engagements.BU.value }});
        
        var netLow = billed - salariesLow;
        var netHigh = billed - salariesHigh;

        var salaries = 0;

        chartST.data.datasets[1].data = [  netLow ];
        chartST.data.datasets[2].data = [  netHigh ];

        chartST.data.datasets[3].data = [ salariesLow ];
        chartST.data.datasets[4].data = [ salariesHigh ];



        var message = "";
        if (netLow < {{ site.data.constants.fixed }}) {
            message = "Between " + hoursLow + " and " + hoursHigh + " hours billed.";
        } else {
            message = "Between " + hoursLow + " and " + hoursHigh + " hours billed.<br>";
            message += String.fromCodePoint(0x1F4B5)
                + "&nbsp; We cleared the ${{ site.data.constants.fixed }}M&nbsp;"
                + String.fromCodePoint(0x1F4B5);
        }
        document.getElementById("message").innerHTML = message;
        chartST.update();
    };

    sliderPA.width(200);
    sliderPA.max(100);
    sliderPA.default(0);
    sliderPA.value(0);

    sliderEI.width(200);
    sliderEI.max(40);
    sliderEI.default(0);
    sliderEI.value(0);

    sliderBU.width(200);
    sliderBU.max(10);
    sliderBU.default(0);
    sliderBU.value(0);

    sliderPA.setCallbacks(callback);
    sliderEI.setCallbacks(callback);
    sliderBU.setCallbacks(callback);

    containerPA.call(sliderPA);
    containerEI.call(sliderEI);
    containerBU.call(sliderBU);

    chartST.update();
</script>