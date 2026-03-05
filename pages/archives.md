---
layout: page
title: 归档
description: 历史日报归档
keywords: 归档, archive, daily report
comments: false
permalink: /archives/
---

{% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}

{% for year in posts_by_year %}
## {{ year.name }}年

<ul>
{% for post in year.items %}
  <li>
    <span style="color: #666;">{{ post.date | date: "%m月%d日" }}</span> 
    <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>
{% endfor %}
