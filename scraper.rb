#!/bin/env ruby
# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'csv'
require 'scraperwiki'
require 'pry'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

def noko_for(url)
  Nokogiri::HTML(open(url).read) 
end


def scrape_list(url)
  noko = noko_for(url)
  noko.css('#jsn-mainbody table td img').each do |img|
    data = { 
      id: File.basename(img.attr('src').split('/').last, '.*'),
      name: img.attr('alt'),
      image: URI.join(url, img.attr('src')).to_s
    }
    ScraperWiki.save_sqlite([:id, :name, :image], data)
  end
end

scrape_list('http://www.assemblee-nationale.tg/les-deputes/femmes-deputes.html')
