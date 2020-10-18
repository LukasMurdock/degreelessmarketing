---
layout: ideas
title: Retention
description: A collection of marketing ideas to help you do better marketing.
date: 2020-10-17
color: "#C05621"
---

<div class="allBooks">
    {% for post in site.posts %}
      {% for category in post.categories %}
        {% if category == "Retention" %}
          {% include ideaCategory.html %}
        {% endif %}
      {% endfor %}
    {% endfor %}
</div>