Spree Sitemap Generator
=====================

Spree sitemap generator is a sitemap generator based on the sitemap_generator gem http://github.com/kjvarga/sitemap_generator. It adheres to the Sitemap 0.9 protocol specification.

Installation
=======

1) add the gem to your `Gemfile`:

`gem 'spree_sitemap_generator'`

2) run bundler:

`bundle install`

3) run the installer, it will create a `config/sitemap.rb` file with some sane defaults

`rails generate spree_sitemap_generator:install`

4) add sitemap to your `.gitignore`

`echo "public/sitemap*" >> .gitignore`

5) setup a daily cron job to regenrate your sitemap via the `rake sitemap:refresh` task. If you use the Whenever gem, add this to your `config/schedule.rb`

```
every 1.day, :at => '5:00 am' do
  rake "-s sitemap:refresh"
end
```

6) make sure crawlers can find the sitemap, by adding the following line to your `public/robots.txt` with your correct domain name

`echo "Sitemap: http://www.example.com/sitemap_index.xml.gz" >> public/robots.txt`


7) BOOM you're done!

More Configuration Options
==========================

Check out the README for the sitemap_generator gem at:
http://github.com/kjvarga/sitemap_generator

Features
========
- Notifies search engine of new sitemaps (Google, Yahoo, Ask, Bing)
- Supports large huge product catalogs
- Adheres to 0.9 Sitemap protocol specification
- Compresses sitemaps with gzip
- Provides basic sitemap of a Spree site (products, taxons, login page, signup page)
- Easily add additional sitemaps for pages you add to your spree site
- Supports Amazon S3 and other hosting services
- Thin wrapper over battle tested sitemap generator
- Supports adding [spree_essential_cms](https://github.com/citrus/spree_essential_cms) pages to the sitemap
- Creates video sitemap data for [spree_videos](https://github.com/iloveitaly/Spree-Videos) and youtube videos embedded in custom [spree_taxon_splash](https://github.com/iloveitaly/spree_taxon_splash) pages

Special Thanks
==============
- The creators of the sitemap_generator gem
- jackkinsella

Copyright (c) 2011 Joshua Nussbaum, released under the New BSD License
