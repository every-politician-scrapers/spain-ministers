#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class String
  def ztidy
    gsub(/[\u200B-\u200D\uFEFF]/, '').tidy
  end
end

class WikipediaDate::Spanish
  def date_en
    super.ztidy
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Imagen'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[_ _ name _ _ start end].freeze
    end

    def raw_end
      super.gsub('†', '').gsub('en el cargo', '')
    end

    def tds
      noko.css('td,th')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
