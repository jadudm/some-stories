---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
title: Two Stories
layout: hello
---

One is a story for people who do the things.

Another is about turning knobs.

All people can, of course, read all stories.

## About The Stories

The stories are meant to be interacted with. 

In all cases, the stories start with simple assumptions and approximations. 

Then, those assumptions are peeled back one-by-one. 

None of the stories should be mistaken for reality.

## A Story For People Who Do Things

<ol>
{% for p in site.staff %}
    <li><a href="{{ p.url | prepend: site.baseurl }}">{{p.title}}</a></li>
{% endfor %}
</ol>

## A Story For People Who Turn Knobs

<hr>

Last rendered: {% last_modified_at %}

<small>Matt Jadud, PhD</small>