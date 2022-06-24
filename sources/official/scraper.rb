#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.css('a').text.tidy
    end

    def position
      noko.css('.subTitle-advanced-news').first.text.tidy
          .gsub(/,\s*$/, '')
          .split(/ and (?=Minister|Government)/)
          .map(&:tidy)
    end

    def empty?
      name == 'Government'
    end
  end

  class Members
    def member_container
      noko.css('ul.container-advanced-news li')
    end

    def member_items
      super.reject(&:empty?)
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
