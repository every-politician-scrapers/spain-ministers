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
      noko.xpath('text()').first.text.tidy
          .gsub(/,\s*$/, '')
          .split(/ and (?=Minister|Government)/)
          .map(&:tidy)
    end
  end

  class Members
    def member_container
      noko.css('#MainContent ul li')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
